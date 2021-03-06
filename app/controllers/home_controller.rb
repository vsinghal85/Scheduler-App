class HomeController < ApplicationController
  

  def index

  if current_client==nil && current_teacher==nil
   redirect_to new_client_session_path
  end

    @client=params[:client_id]
  end

def new
@event=params[:event_id]  
end

def create

@events=Event.find(params[:event_id])
@events.teacher_id=params[:Teacher_Id]
@events.event_location=params[:location]
@events.save


 redirect_to home_show_path
end

 def show
 @events=nil
 if current_client
@events=current_client.events.all   
 end

 end

 def data

  if current_client!=nil
   events = current_client.events.all
  end
  if current_teacher!=nil
    events = current_teacher.events.all
   end 

   if(params[:param1]!=nil)
    client=Client.find(params[:param1])
    events=client.events.all
  end

   render :json => events.map {|event| {

              :id => event.id,
              :start_date => event.start_date.to_formatted_s(:db),
              :end_date => event.end_date.to_formatted_s(:db),
              :text => event.text,
              :rec_type => event.rec_type,
              :event_length => event.event_length,
              :event_pid => event.event_pid,
               :event_location => event.event_location,
              :teacher_id => event.teacher_id
          }}
 end

 def db_action
  
   mode = params['!nativeeditor_status']
   id = params['id']
   start_date = params['start_date']
   end_date = params['end_date']
   text = params['text']
   rec_type = params['rec_type']
   event_length = params['event_length']
   event_pid = params['event_pid']
   tid = id
   event_location = params[:event_location]
   teacher_id =params[:teacher_id]
   case mode
     when 'inserted'
       event = Event.create :start_date => start_date, :end_date => end_date, :text => text,
                            :rec_type => rec_type, :event_length => event_length, :event_pid => event_pid, :event_location => event_location, :teacher_id => teacher_id
       tid = event.id
      if !current_teacher && current_client
       event.client_id=current_client.id
       event.save
     end
       if rec_type == 'none'
         mode = 'deleted'
       end

     when 'deleted'
       if rec_type != ''
         Event.where(event_pid: id).destroy_all
       end

       if event_pid != 0 and event_pid != ''
         event = Event.find(id)
         event.rec_type = 'none'
         if !current_teacher && current_client
         event.save
       end
       else
         Event.find(id).destroy
       end

     when 'updated'
       if rec_type != ''
         Event.where(event_pid: id).destroy_all
       end
     
       event = Event.find(id)
       event.start_date = start_date
       event.end_date = end_date
       event.text = text
       event.rec_type = rec_type
       event.event_length = event_length
       event.event_pid = event_pid
       event.event_location =event_location
       event.teacher_id = teacher_id
       if !current_teacher && current_client
       event.save
     end
   end

   render :json => {
              :type => mode,
              :sid => id,
              :tid => tid,
          }
 end
end
