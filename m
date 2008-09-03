From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 1/4] Update ulogd man page.
Date: Wed,  3 Sep 2008 22:19:00 +0200
Message-ID: <1220473143-17957-2-git-send-email-eric@inl.fr>
References: <>
 <1220473143-17957-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46788 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753551AbYICUsw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Sep 2008 16:48:52 -0400
In-Reply-To: <1220473143-17957-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch updates ulogd man page to add information about
the new features.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 ulogd.8 |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/ulogd.8 b/ulogd.8
index 7dfb2e9..d6eb2c9 100644
--- a/ulogd.8
+++ b/ulogd.8
@@ -2,7 +2,7 @@
 .\" First parameter, NAME, should be all caps
 .\" Second parameter, SECTION, should be 1-8, maybe w/ subsection
 .\" other parameters are allowed: see man(7), man(1)
-.TH ULOGD 8 "November 05, 2002" "Linux Netfilter"
+.TH ULOGD 8 "August 31, 2008" "Linux Netfilter"
 .\" Please adjust this date whenever revising the manpage.
 .\"
 .\" Some roff macros, for reference:
@@ -16,15 +16,15 @@
 .\" .sp <n>    insert n+1 empty lines
 .\" for manpage-specific macros, see man(7)
 .SH NAME
-ulogd \- netfilter/iptables ULOG daemon
+ulogd \- netfilter/iptables logging daemon
 .SH SYNOPSIS
 .B ulogd [options]
 .SH DESCRIPTION
 .B ulogd
-connects to the netlink device of the Linux kernel and reads messages
-from the netfilter that get queued with the iptables ULOG target. For
-this to work you have to compile the ULOG target into your kernel or
-load the respective module.
+listen to netfilter messages coming from Netfilter connection tracking
+or Netfilter packet logging subsystem. For this to work you have to
+compile NFCT event support and/or the ULOG and NFLOG target into your
+kernel or load the respective module.
 .PP
 The received messages can be logged into files or into a mySQL or
 PostgreSQL database.
@@ -42,6 +42,12 @@ show usage information
 .TP
 .B -V, --version
 show version information and copyright
+.TP
+.B -u <UID>, --uid <UID>
+change UID/GID
+.TP
+.B -i <pluginpath>, --info <pluginpath>
+display infos about plugin
 .SH FILES
 .I /etc/ulogd.conf
 .br
-- 
1.5.4.3

