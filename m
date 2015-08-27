From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [conntrackd] allowing DisableExternalCache in alarm mode
Date: Thu, 27 Aug 2015 12:57:42 +0200
Message-ID: <CAOkSjBh2KtYcSEQ7=h_h+R9CE53pwGtBAiQ_OZF0aTX0fhY0fw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:33530 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbbH0K6D convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Aug 2015 06:58:03 -0400
Received: by lbbsx3 with SMTP id sx3so8910915lbb.0
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Aug 2015 03:58:02 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

The documentation about DisableExternalCache reads:

 <<<
 [...]
 You can also use this option with the NOTRACK and ALARM modes.
 This increases CPU consumption in the backup firewall but now you do n=
ot
 need to commit the flow-states during the master failures since they a=
re
 already in the in-kernel Connection Tracking table. Moreover, you save
 memory in the backup firewall since you do not need to store the
 foreign flow-states anymore.
 >>>

However, the config parser doesn't allows it. Patch seems rather trivia=
l:

diff --git a/src/read_config_yy.y b/src/read_config_yy.y
index 73fabbf..d53aa70 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -908,6 +908,7 @@ sync_mode_alarm_line: refreshtime
                         | purge
                         | relax_transitions
                         | delay_destroy_msgs
+                        | disable_external_cache
                         ;

 sync_mode_ftfw_list:


However, there seems to be some missing bits somewhere, the backup
node prints this in the logs:

[...]
[Thu Aug 27 12:49:46 2015] (pid=3D15176) [ERROR] inject-add2: No such
file or directory
Thu Aug 27 12:49:46 2015 tcp      6 17949 ESTABLISHED
src=3D192.162.26.14 dst=3D192.168.5.134 sport=3D39089 dport=3D2015 [ASS=
URED]
mark=3D0
[Thu Aug 27 12:49:56 2015] (pid=3D15176) [ERROR] inject-add2: No such
file or directory
Thu Aug 27 12:49:56 2015 tcp      6 17949 ESTABLISHED
src=3D192.162.26.14 dst=3D192.168.5.134 sport=3D39089 dport=3D2015 [ASS=
URED]
mark=3D0
[...]

Note, always the same connection. In my busy test environment, this
ENOENT happens every few seconds Perhaps a race condition somewhere?

I would appreciate any hint/advice/pointer.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
