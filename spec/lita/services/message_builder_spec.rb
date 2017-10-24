require "spec_helper"
require 'pry'

describe Lita::Services::MessageBuilder do
  let(:entries) do
    [
      {
        owner: "Khriztian",
        user_name: "Khriztian",
        user_email: "khriztian@platan.us",
        description: "Task 2",
        started_at: Time.at(1495199186).utc
      },
      {
        owner: "Leandro",
        user_name: "Leandro",
        user_email: "leandro@platan.us"
      },
      {
        owner: "rene@platan.us",
        user_name: nil,
        user_email: "rene@platan.us"
      },
      {
        owner: "Memo",
        user_name: "Memo",
        user_email: "memo@platan.us",
        project_name: "Proyecto 2",
        started_at: Time.at(1295216323).utc
      }
    ].map do |entry|
      UserTimeEntry.new(entry)
    end
  end

  let(:toggl_client) { double(:toggl_client, users_current_entries: entries) }
  let(:srv) { described_class.new(toggl_client) }

  before { allow(Date).to receive(:today).and_return(Date.new(2017, 5, 19)) }

  describe "#general_activity" do
    it "returns general activity message" do
      output = <<~EOS
        • *Khriztian* está toggleando :slightly_smiling_face:
        >*Proyecto:* :confused:
        >*Tarea:* Task 2
        >Desde las *01:06 PM* de hoy
        • *Leandro* no está toggleando en este momento :disappointed:
        • *rene@platan.us* no está toggleando en este momento :disappointed:
        • *Memo* está toggleando :slightly_smiling_face:
        >*Proyecto:* Proyecto 2
        >*Tarea:* :confused:
        >Desde el día *16/01/2011* a las *10:18 PM*
      EOS
      expect(srv.general_activity).to eq(output.chomp)
    end
  end

  describe "#active_users" do
    it "returns active users names" do
      expect(srv.active_users).to eq("• Khriztian\n• Memo")
    end
  end

  describe "#inactive_users" do
    it "returns inactive users names" do
      expect(srv.inactive_users).to eq("• Leandro\n• rene@platan.us")
    end
  end

  describe "#user_activity" do
    it { expect(srv.user_activity("lean")).to match("Leandro") }
    it { expect(srv.user_activity("rene")).to match("rene@platan.us") }
    it { expect(srv.user_activity("an")).to match("Khriztian") }
    it { expect(srv.user_activity("     m E  $% --mO--  ")).to match("Memo") }
    it { expect(srv.user_activity(nil)).to match(":confused: Creo que no") }
    it { expect(srv.user_activity("")).to match(":confused: Creo que no") }
    it { expect(srv.user_activity("Marta")).to match(":confused: Creo que no") }
  end
end
