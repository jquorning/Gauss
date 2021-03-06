--
--  The author disclaims copyright to this source code.  In place of
--  a legal notice, here is a blessing:
--
--    May you do good and not evil.
--    May you find forgiveness for yourself and forgive others.
--    May you share freely, not taking more than you give.
--

with Ada.Text_IO;

with AWS.Config;
with AWS.Server.Log;
with AWS.Services.Page_Server;

package body Web_Server is

   Server : AWS.Server.HTTP;

   procedure Startup is

      Config : constant AWS.Config.Object := AWS.Config.Get_Current;

   begin
      if AWS.Config.Directory_Browser_Page (Config) /= "" then
         AWS.Services.Page_Server.Directory_Browsing (True);
      end if;

      if AWS.Config.Log_Filename_Prefix (Config) /= "" then
         AWS.Server.Log.Start (Server);
      end if;

      if AWS.Config.Error_Log_Filename_Prefix (Config) /= "" then
         AWS.Server.Log.Start_Error (Server);
      end if;

      AWS.Server.Start
        (Web_Server => Server,
         Dispatcher => Virtual_Hosts.Dispatcher,
         Config     => Config);

   end Startup;


   procedure Work_Until_Stopped is
      use AWS.Server;
   begin
      Wait (Forever);
   end Work_Until_Stopped;


   procedure Shutdown is
   begin
      Ada.Text_IO.Put_Line ("AWS server shutdown in progress.");
      AWS.Server.Shutdown (Server);
   end Shutdown;


end Web_Server;

