require "spec_helper"

describe Lita::Handlers::TimeTracker, lita_handler: true do
  let(:general_activity_msg) { double }
  let(:active_users_msg) { double }
  let(:inactive_users_msg) { double }
  let(:user_activity_msg) { double }
  let(:builder) do
    builder_methods = {
      general_activity: general_activity_msg,
      active_users: active_users_msg,
      inactive_users: inactive_users_msg
    }

    double(:builder_methods, builder_methods)
  end

  before do
    allow_any_instance_of(described_class).to receive(:message_builder).and_return(builder)
  end

  it { is_expected.to route("me muestras la actividad en toggl?") }
  it { is_expected.to route("me muestras la actividad en harvest?") }
  it { is_expected.to route("en que wea andan?") }
  it { is_expected.to route("en qué wea andan?") }
  it { is_expected.to route("quienes togglean?") }
  it { is_expected.to route("quiénes togglean?") }
  it { is_expected.to route("quienes no togglean?") }
  it { is_expected.to route("quiénes no togglean?") }
  it { is_expected.to route("me muestras el toggl de leandro?") }
  it { is_expected.to route("me muestras el harvest de leandro?") }

  it "responds with general activity message" do
    send_message("me muestras la actividad en toggl?")
    expect(replies.last).to eq(general_activity_msg)
  end

  it "responds with active users message" do
    send_message("quienes togglean?")
    expect(replies.last).to eq(active_users_msg)
  end

  it "responds with inactive users message" do
    send_message("quienes no togglean?")
    expect(replies.last).to eq(inactive_users_msg)
  end

  it "responds with specific user activity" do
    expect(builder).to receive(:user_activity).with("leandro").and_return(user_activity_msg)
    send_message("me muestras el toggl de leandro?")
    expect(replies.last).to eq(user_activity_msg)
  end
end
