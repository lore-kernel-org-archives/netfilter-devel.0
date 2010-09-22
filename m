From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 4/6] ulogd.conf: add a complex but useful stack example
Date: Wed, 22 Sep 2010 02:47:20 +0200
Message-ID: <1285116442-32490-5-git-send-email-eric@inl.fr>
References: <1285116442-32490-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:33860 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755582Ab0IVAy5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Sep 2010 20:54:57 -0400
In-Reply-To: <1285116442-32490-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a complex but useful stack example. It was
undocumented that multiple output plugin can be used in the
same stack.

This patch change a variable name to fix some example stacks.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 ulogd.conf.in |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/ulogd.conf.in b/ulogd.conf.in
index de5bc11..75b4880 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -58,6 +58,9 @@ plugin="@libdir@/ulogd/ulogd_raw2packet_BASE.so"
 # this is a stack for packet-based logging via LOGEMU with filtering on MARK
 #stack=log2:NFLOG,mark1:MARK,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
 
+# this is a stack for packet-based logging via SYSLOG and logging to LOGEMU after filtering on MARK
+#stack=log2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,sys1:SYSLOG,mark1:MARK,emu1:LOGEMU
+
 # this is a stack for flow-based logging via LOGEMU
 #stack=ct1:NFCT,ip2str1:IP2STR,print1:PRINTFLOW,emu1:LOGEMU
 
@@ -209,8 +212,8 @@ table="ulog"
 pass="ulog2"
 procedure="INSERT_PACKET_FULL"
 
-[sys2]
-facility=LOG_LOCAL2
+[sys1]
+facility=LOG_LOCAL1
 
 [nacct1]
 sync = 1
-- 
1.6.1

