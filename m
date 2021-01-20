Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67F1EC433DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Jan 2021 14:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E3C723356
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Jan 2021 14:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731903AbhATOPS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Jan 2021 09:15:18 -0500
Received: from mail-wr1-f47.google.com ([209.85.221.47]:42772 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732666AbhATNjp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Jan 2021 08:39:45 -0500
Received: by mail-wr1-f47.google.com with SMTP id m4so23116561wrx.9
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Jan 2021 05:39:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=OLfF0spozksxfONXz9yh+9WoiKIXPq1TfnSumuh8esE=;
        b=QSWiB69Hck3gE2sIVa2SjOZ4OHRMMXh5ABSl7tjjAVi7hqc02c5xSce0C2mnSQXjni
         WCglxtYNa/nKTdS/YxaD2CmLG478NnRY/G+IJrpKJbDegr5HlHIjUP/QSYuKezH0k6NS
         Tx4cjKEYbPKUCI5kpHDZHxXJzWaomQMGJG48vu7ilZPnCKt1HzqK1ReIPrSyBxVJspdl
         YKj5pMeolL/izx6/7AFi2YvsJHLiFYh3KDQbPIF1pIoZNXGa9OgihGMmQ4V9Cz4lbXmG
         Kj7epC2h+mjUfqrhSPh+MTGgBAl7EhaPg5/AcsKhubKnkOXE9sa9IhybtnmWVOfQhEqJ
         ZglQ==
X-Gm-Message-State: AOAM532Xqvulbxo8FPVHITbcB+ZX4zOLOmYqJrqRl87PDhs6ROSs6h7Z
        x2Y87aaBZ9cypiM28HmojKn9IFVMXoPU5Q==
X-Google-Smtp-Source: ABdhPJxaLvLc2uLksR97LTugyJeKsEV3pCKfuTnM4+MylaiY3Tq5rFlCYnCQmscjFJoNlpuDctstLQ==
X-Received: by 2002:a5d:6cd4:: with SMTP id c20mr9347487wrc.57.1611149941843;
        Wed, 20 Jan 2021 05:39:01 -0800 (PST)
Received: from localhost ([213.194.141.17])
        by smtp.gmail.com with ESMTPSA id y63sm4199036wmd.21.2021.01.20.05.39.00
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 05:39:01 -0800 (PST)
Subject: [conntrack-tools PATCH] conntrackd: introduce yes & no config values
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Date:   Wed, 20 Jan 2021 14:39:00 +0100
Message-ID: <161114994034.48299.3516818154943179595.stgit@endurance>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

They are equivalent of 'on' and 'off' and makes the config easier to understand.

Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 conntrackd.conf.5     |  110 +++++++++++++++++++++++++------------------------
 src/read_config_lex.l |    8 +++-
 2 files changed, 61 insertions(+), 57 deletions(-)

diff --git a/conntrackd.conf.5 b/conntrackd.conf.5
index 673f895..a73c3f7 100644
--- a/conntrackd.conf.5
+++ b/conntrackd.conf.5
@@ -22,7 +22,7 @@
 .\" <http://www.gnu.org/licenses/>.
 .\" %%%LICENSE_END
 .\"
-.TH CONNTRACKD.CONF 5 "Jan 27, 2019"
+.TH CONNTRACKD.CONF 5 "Jan 20, 2021"
 
 .SH NAME
 conntrackd.conf \- configuration file for conntrackd daemon
@@ -133,7 +133,7 @@ experiments measuring the cycles spent by the acknowledgment handling
 with oprofile).
 
 .TP
-.BI "DisableExternalCache <on|off>"
+.BI "DisableExternalCache <yes|no>"
 This clause allows you to disable the external cache. Thus, the state entries
 are directly injected into the kernel conntrack table. As a result, you save
 memory in user-space but you consume slots in the kernel conntrack table for
@@ -144,19 +144,19 @@ If you are installing \fBconntrackd(8)\fP for first time, please read the user
 manual and I encourage you to consider using the fail-over scripts instead of
 enabling this option!
 
-By default, this clause is set off.
+By default this is set to no, meaning the external cache is enabled.
 
 .TP
-.BI "StartupResync <on|off>"
+.BI "StartupResync <yes|no>"
 Order conntrackd to request a complete conntrack table resync against the other
 node at startup. A single request will be made.
 
 This is useful to get in sync with another node which has been running while we
 were down.
 
-Example: StartupResync on
+Example: StartupResync yes
 
-By default, this clause is set off.
+By default, this clause is set to no.
 
 .SS Mode ALARM
 
@@ -201,14 +201,14 @@ In this synchronization mode you may configure \fBDisableInternalCache\fP,
 \fBStartupResync\fP.
 
 .TP
-.BI "DisableInternalCache <on|off>"
+.BI "DisableInternalCache <yes|no>"
 This clause allows you to disable the internal cache. Thus, the synchronization
 messages are directly sent through the dedicated link.
 
-This option is set off by default.
+This option is set to no by default.
 
 .TP
-.BI "DisableExternalCache <on|off>"
+.BI "DisableExternalCache <yes|no>"
 Same as in \fBFTFW\fP mode.
 
 .TP
@@ -220,7 +220,7 @@ Same as in \fBFTFW\fP mode.
 Same as in \fBFTFW\fP mode.
 
 .TP
-.BI "StartupResync <on|off>"
+.BI "StartupResync <yes|no>"
 Same as in \fBFTFW\fP mode.
 
 .SS MULTICAST
@@ -326,7 +326,7 @@ to increase the buffer size.
 Example: RcvSocketBuffer 1249280
 
 .TP
-.BI "Checksum <on|off>"
+.BI "Checksum <yes|no>"
 Enable/Disable message checksumming. This is a good property to achieve
 fault-tolerance. In case of doubt, use it.
 
@@ -395,7 +395,7 @@ Same as in the \fBMulticast\fP transport protocol configuration.
 Same as in the \fBMulticast\fP transport protocol configuration.
 
 .TP
-.BI "Checksum <on|off>"
+.BI "Checksum <yes|no>"
 Same as in the \fBMulticast\fP transport protocol configuration.
 
 
@@ -419,7 +419,7 @@ Example:
 		Interface eth2
 		SndSocketBuffer 1249280
 		RcvSocketBuffer 1249280
-		Checksum on
+		Checksum yes
 	}
 .fi
 
@@ -429,7 +429,7 @@ Other unsorted options that are related to the synchronization protocol
 or transport mechanism.
 
 .TP
-.BI "TCPWindowTracking <on|off>"
+.BI "TCPWindowTracking <yes|no>"
 TCP state-entries have window tracking disabled by default, you can enable it
 with this option. As said, default is off.
 This feature requires a \fBLinux kernel >= 2.6.36\fP.
@@ -465,7 +465,7 @@ This top-level section contains generic configuration directives for the
 \fBconntrackd(8)\fP daemon.
 
 .TP
-.BI "Systemd <on|off>"
+.BI "Systemd <yes|no>"
 Enable \fBsystemd(1)\fP runtime support if \fBconntrackd(8)\fP is compiled
 with the proper configuration. Then you can use a service unit of
 \fIType=notify\fP.
@@ -474,7 +474,7 @@ Obviously, this requires the init of your system to be \fBsystemd(1)\fP.
 
 Note: \fBsystemd(1)\fP watchdog is supported as well.
 
-Example: Systemd on
+Example: Systemd yes
 
 By default runtime support is enabled if conntrackd was built with the systemd
 feature. Otherwise is off.
@@ -503,15 +503,15 @@ dead entries cached for possible retransmission during state synchronization.
 Example: HashLimit 131072
 
 .TP
-.BI "LogFile <on|off|filename>"
+.BI "LogFile <yes|no|filename>"
 Enable \fBconntrackd(8)\fP to log to a file.
 
-Example: LogFile on
+Example: LogFile no
 
-Default is off. The default logfile is \fB/var/log/conntrackd.log\fP.
+Default is no. Default logfile is \fB/var/log/conntrackd.log\fP.
 
 .TP
-.BI "Syslog <on|off|facility>"
+.BI "Syslog <yes|no|facility>"
 Enable connection logging via Syslog. If you set the facility, use the same as
 in the \fBStats\fP section, otherwise you'll get a warning message.
 
@@ -545,7 +545,7 @@ size growth that can be reached.
 Example:  NetlinkBufferSizeMaxGrowth 8388608
 
 .TP
-.BI "NetlinkOverrunResync <on|off|value>"
+.BI "NetlinkOverrunResync <yes|no|value>"
 If the daemon detects that Netlink is dropping state-change events, it
 automatically schedules a resynchronization against the Kernel after 30 seconds
 (default value). Resynchronizations are expensive in terms of CPU consumption
@@ -554,20 +554,20 @@ that do not exist anymore.
 
 Note: Be careful of setting a very small value here.
 
-Example: NetlinkOverrunResync on
+Example: NetlinkOverrunResync yes
 
 The default value is \fB30\fP seconds.
 If not specified, the daemon assumes that this option is enabled and uses the
 default value.
 
 .TP
-.BI "NetlinkEventsReliable <on|off>"
+.BI "NetlinkEventsReliable <yes|no>"
 If you want reliable event reporting over Netlink, set on this option. If you
 set on this clause, it is a good idea to set off \fBNetlinkOverrunResync\fP.
 
 You need \fBLinux Kernel >= 2.6.31\fP for this option to work.
 
-Example: NetlinkEventsReliable on
+Example: NetlinkEventsReliable yes
 
 This option is off by default.
 
@@ -758,29 +758,29 @@ This top-level section indicates \fBconntrackd(8)\fP to work as a statistic
 collector for the nf_conntrack linux kernel subsystem.
 
 .TP
-.BI "LogFile <on|off|filename>"
+.BI "LogFile <yes|no|filename>"
 If you enable this option, the daemon writes the information about destroyed
 connections to a logfile.
 
-Default is off. Default filename is \fB/var/log/conntrackd-stats.log\fP.
+Default is no. Default filename is \fB/var/log/conntrackd-stats.log\fP.
 
 .TP
-.BI "NetlinkEventsReliable <on|off>"
+.BI "NetlinkEventsReliable <yes|no>"
 If you want reliable event reporting over Netlink, set on this option. If
 you set on this clause, it is a good idea to set off
 \fBNetlinkOverrunResync\fP. This requires \fBLinux kernel >= 2.6.31\fP.
 
-Default is off.
+Default is no.
 
 .TP
-.BI "Syslog <on|off|facility>"
+.BI "Syslog <yes|no|facility>"
 Enable connection logging via Syslog.
 If you set the facility, use the same as in the \fBGeneral\fP section,
 otherwise you'll get a warning message.
 
 Example: Syslog local0
 
-Default is off.
+Default is no.
 
 .SH HELPER
 Note: this configuration is very advanced and has nothing to do with
@@ -899,15 +899,15 @@ collector.
 
 .nf
 Stats {
-	LogFile on
-	NetlinkEventsReliable Off
-	Syslog off
+	LogFile yes
+	NetlinkEventsReliable no
+	Syslog yes
 }
 General {
-	Systemd on
+	Systemd yes
 	HashSize 8192
 	HashLimit 65535
-	Syslog on
+	Syslog yes
 	LockFile /var/lock/conntrack.lock
 	UNIX {
 		Path /var/run/conntrackd.ctl
@@ -942,7 +942,7 @@ Sync {
 		ResendQueueSize 131072
 		PurgeTimeout 60
 		ACKWindowSize 300
-		DisableExternalCache Off
+		DisableExternalCache no
 	}
 	Multicast {
 		IPv4_address 225.0.0.50
@@ -951,7 +951,7 @@ Sync {
 		Interface eth2
 		SndSocketBuffer 1249280
 		RcvSocketBuffer 1249280
-		Checksum on
+		Checksum yes
 	}
 	Multicast Default {
 		IPv4_address 225.0.0.51
@@ -960,27 +960,27 @@ Sync {
 		Interface eth3
 		SndSocketBuffer 1249280
 		RcvSocketBuffer 1249280
-		Checksum on
+		Checksum yes
 	}
 	Options {
-		TCPWindowTracking Off
-		ExpectationSync On
+		TCPWindowTracking no
+		ExpectationSync yes
 	}
 }
 General {
-	Systemd on
+	Systemd yes
 	HashSize 32768
 	HashLimit 131072
-	LogFile on
-	Syslog off
+	LogFile yes
+	Syslog no
 	LockFile /var/lock/conntrack.lock
 	UNIX {
 		Path /var/run/conntrackd.ctl
 	}
 	NetlinkBufferSize 2097152
 	NetlinkBufferSizeMaxGrowth 8388608
-	NetlinkOverrunResync On
-	NetlinkEventsReliable Off
+	NetlinkOverrunResync yes
+	NetlinkEventsReliable no
 	EventIterationLimit 100
 	Filter From Userspace {
 		Protocol Accept {
@@ -1007,8 +1007,8 @@ It includes common general configuration as well.
 .nf
 Sync {
 	Mode NOTRACK {
-		DisableInternalCache on
-		DisableExternalCache on
+		DisableInternalCache yes
+		DisableExternalCache yes
 	}
 	TCP {
 		IPv4_address 192.168.2.100
@@ -1017,27 +1017,27 @@ Sync {
 		Interface eth2
 		SndSocketBuffer 1249280
 		RcvSocketBuffer 1249280
-		Checksum on
+		Checksum yes
 	}
 	Options {
-		TCPWindowTracking Off
-		ExpectationSync On
+		TCPWindowTracking no
+		ExpectationSync yes
 	}
 }
 General {
-	Systemd on
+	Systemd yes
 	HashSize 32768
 	HashLimit 131072
-	LogFile on
-	Syslog off
+	LogFile yes
+	Syslog no
 	LockFile /var/lock/conntrack.lock
 	UNIX {
 		Path /var/run/conntrackd.ctl
 	}
 	NetlinkBufferSize 2097152
 	NetlinkBufferSizeMaxGrowth 8388608
-	NetlinkOverrunResync On
-	NetlinkEventsReliable Off
+	NetlinkOverrunResync yes
+	NetlinkEventsReliable no
 	EventIterationLimit 100
 	Filter From Userspace {
 		Protocol Accept {
diff --git a/src/read_config_lex.l b/src/read_config_lex.l
index b0d9e61..f1f4fe3 100644
--- a/src/read_config_lex.l
+++ b/src/read_config_lex.l
@@ -35,6 +35,10 @@ nl		[\n\r]
 
 is_on		[o|O][n|N]
 is_off		[o|O][f|F][f|F]
+is_yes		[y|Y][e|E][s|S]
+is_no		[n|N][o|O]
+is_true		{is_on}|{is_yes}
+is_false	{is_off}|{is_no}
 integer		[0-9]+
 signed_integer	[\-\+][0-9]+
 path		\/[^\"\n ]*
@@ -138,8 +142,8 @@ notrack		[N|n][O|o][T|t][R|r][A|a][C|c][K|k]
 "Systemd"			{ return T_SYSTEMD; }
 "StartupResync"			{ return T_STARTUP_RESYNC; }
 
-{is_on}			{ return T_ON; }
-{is_off}		{ return T_OFF; }
+{is_true}		{ return T_ON; }
+{is_false}		{ return T_OFF; }
 {integer}		{ yylval.val = atoi(yytext); return T_NUMBER; }
 {signed_integer}	{ yylval.val = atoi(yytext); return T_SIGNED_NUMBER; }
 {ip4}			{ yylval.string = strdup(yytext); return T_IP; }

