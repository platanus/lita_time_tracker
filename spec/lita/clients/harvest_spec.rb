require "spec_helper"
require 'pry'

describe Lita::Clients::Harvest do
  describe "#users_current_entries" do
    let(:token) { "XXX" }
    let(:account_id) { "123" }

    let(:users) do
      {
        "users" => [
          {
            "id" => 2870463,
            "email" => "khriztian@platan.us",
            "first_name" => "Khriztian",
            "last_name" => nil
          },
          {
            "id" => 549348,
            "email" => "leandro@platan.us",
            "first_name" => "Leandro",
            "last_name" => "Segovia"
          },
          {
            "id" => 2824888,
            "email" => "rene@platan.us",
            "first_name" => nil,
            "last_name" => nil
          },
          {
            "id" => 799899,
            "email" => "memo@platan.us",
            "first_name" => "Memo",
            "last_name" => nil
          }
        ]
      }.to_json
    end

    let(:entries) do
      {
        "time_entries" => [
          {
            "user" => {
              "id" => 2824888
            },
            "client" => {
              "name" => "Client 1"
            },
            "project" => {
              "name" => "Project 1"
            },
            "task" => {
              "name" => "Task 1"
            },
            "notes" => "Note 1",
            "started_at" => nil
          },
          {
            "user" => {
              "id" => 2870463
            },
            "client" => {
              "name" => "Client 2"
            },
            "project" => {
              "name" => nil
            },
            "task" => {
              "name" => "Task 2"
            },
            "started_at" => "2017-05-30T19:32:42Z"
          },
          {
            "user" => {
              "id" => 549348
            },
            "client" => {
              "name" => nil
            },
            "project" => {
              "name" => "Project 3"
            },
            "task" => {
              "name" => nil
            },
            "notes" => "Note 3",
            "started_at" => "2017-05-30T16:21:42Z"
          }
        ]
      }.to_json
    end

    let(:auth_headers) do
      {
        "Authorization" => "Bearer #{token}",
        "Harvest-Account-Id" => account_id
      }
    end

    let(:users_url) { "#{described_class::API_URL}/users.json" }
    let(:users_response) { double(:users_response, body: users, success?: true) }
    let(:entries_url) { "#{described_class::API_URL}/time_entries.json" }
    let(:entires_response) { double(:entires_response, body: entries, success?: true) }

    before do
      expect(HTTParty).to(
        receive(:get).with(users_url, headers: auth_headers).and_return(users_response)
      )

      expect(HTTParty).to(
        receive(:get).with(entries_url, headers: auth_headers).and_return(entires_response)
      )

      @result = described_class.new(account_id, token).users_current_entries
    end

    it { expect(@result.count).to eq(4) }

    it "builds active time entries" do
      data = {
        owner: "Khriztian",
        user_name: "Khriztian",
        user_email: "khriztian@platan.us",
        project_name: "Client 2",
        description: "Task 2",
        active: true,
        started_at: Time.parse("2017-05-30 16:32:42.000000000 -0300")
      }

      expect_entry_to_match_data(@result[0], data)

      data = {
        owner: "Leandro Segovia",
        user_name: "Leandro Segovia",
        user_email: "leandro@platan.us",
        project_name: "Project 3",
        description: "Note 3",
        active: true,
        started_at: Time.parse("2017-05-30 13:21:42.000000000 -0300")
      }

      expect_entry_to_match_data(@result[1], data)
    end

    it "builds inactive time entry when started_at attribute is null in user's activity" do
      data = {
        owner: "rene@platan.us",
        user_name: nil,
        user_email: "rene@platan.us",
        project_name: "Client 1 - Project 1",
        description: "Task 1: Note 1",
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
