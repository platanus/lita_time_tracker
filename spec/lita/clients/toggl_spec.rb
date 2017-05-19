require "spec_helper"
require 'pry'

describe Lita::Clients::Toggl do
  describe "#users_current_entires" do
    let(:api_token) { "XXX" }

    let(:workspaces) do
      [
        {
          "id" => 236416,
          "name" => "Platanus' workspace"
        }
      ]
    end

    let(:projects) do
      [
        {
          "id" => 40969653,
          "name" => "Proyecto 1"
        }, {
          "id" => 16028572,
          "name" => "Proyecto 2"
        }
      ]
    end

    let(:dashboard) do
      {
        "activity" =>
          [
            {
              "user_id" => 2824888,
              "project_id" => 40969653,
              "duration" => -1495037680,
              "description" => "Task 1",
              "stop" => "2017-05-19T18:27:51+00:00",
              "tid" => nil
            },
            {
              "user_id" => 2870463,
              "project_id" => 40969653,
              "duration" => -1495199186,
              "description" => "Task 2",
              "stop" => nil,
              "tid" => nil
            },
            {
              "user_id" => 549348,
              "project_id" => 16028572,
              "duration" => -1495216323,
              "description" => "Task 3",
              "stop" => nil,
              "tid" => nil
            }
          ]
      }
    end

    let(:users) do
      [
        {
          "id" => 2870463,
          "email" => "khriztian@platan.us",
          "fullname" => "Khriztian"
        },
        {
          "id" => 549348,
          "email" => "leandro@platan.us",
          "fullname" => "Leandro"
        },
        {
          "id" => 2824888,
          "email" => "rene@platan.us",
          "fullname" => nil
        },
        {
          "id" => 799899,
          "email" => "memo@platan.us",
          "fullname" => "Memo"
        }
      ]
    end

    let(:api_instance) do
      api_methods = {
        workspaces: workspaces,
        dashboard: dashboard,
        users: users,
        projects: projects
      }

      double(:api_instance, api_methods)
    end

    def expect_entry_to_match_data(entry, data)
      expect(entry.owner).to eq(data[:owner])
      expect(entry.user_name).to eq(data[:user_name])
      expect(entry.user_email).to eq(data[:user_email])
      expect(entry.project_name).to eq(data[:project_name])
      expect(entry.description).to eq(data[:description])
      expect(entry.active).to eq(data[:active])
      expect(entry.started_at).to eq(data[:started_at])
    end

    before do
      expect(::TogglV8::API).to receive(:new).with(api_token).and_return(api_instance)
      @result = described_class.new(api_token).users_current_entires
    end

    it { expect(@result.count).to eq(4) }

    it "builds active time entries" do
      data = {
        owner: "Khriztian",
        user_name: "Khriztian",
        user_email: "khriztian@platan.us",
        project_name: "Proyecto 1",
        description: "Task 2",
        active: true,
        started_at: Time.parse("2017-05-19 10:06:26.000000000 -0300")
      }

      expect_entry_to_match_data(@result[0], data)

      data = {
        owner: "Leandro",
        user_name: "Leandro",
        user_email: "leandro@platan.us",
        project_name: "Proyecto 2",
        description: "Task 3",
        active: true,
        started_at: Time.parse("2017-05-19 14:52:03.000000000 -0300")
      }

      expect_entry_to_match_data(@result[1], data)
    end

    it "builds inactive time entry when stop attribute is not present in user's activity" do
      data = {
        owner: "rene@platan.us",
        user_name: nil,
        user_email: "rene@platan.us",
        project_name: "Proyecto 1",
        description: "Task 1",
        active: false,
        started_at: nil
      }

      expect_entry_to_match_data(@result[2], data)
    end

    it "builds inactive time entry when user has not activity" do
      data = {
        owner: "Memo",
        user_name: "Memo",
        user_email: "memo@platan.us",
        project_name: nil,
        description: nil,
        active: false,
        started_at: nil
      }

      expect_entry_to_match_data(@result[3], data)
    end
  end
end
