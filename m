From: pablo@netfilter.org
Subject: [PATCH 3/3] src: add example use of GPRINT to ulogd.conf.in configuration file
Date: Wed, 22 Feb 2012 13:33:33 +0100
Message-ID: <1329914013-2132-4-git-send-email-pablo@netfilter.org>
References: <1329914013-2132-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50070 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab2BVMdx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Feb 2012 07:33:53 -0500
In-Reply-To: <1329914013-2132-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Example on how this display one conntrack:

timestamp=2012/02/22-13:16:54,orig.ip.saddr=192.168.1.129,orig.ip.daddr=173.194.34.235,orig.ip.protocol=6,orig.l4.sport=58221,orig.l4.dport=80,orig.raw.pktlen=1206,orig.raw.pktcount=4,reply.ip.saddr=173.194.34.235,reply.ip.daddr=192.168.1.129,reply.ip.protocol=6,reply.l4.sport=80,reply.l4.dport=58221,reply.raw.pktlen=1104,reply.raw.pktcount=3,ct.mark=0,ct.id=846180008,ct.event=4,flow.end.sec=1329913014,flow.end.usec=413771,oob.family=2,oob.protocol=0

and one NFLOG line look like this

timestamp=2012/02/22-13:21:24,raw.pktlen=40,raw.pktcount=1,oob.prefix=test,oob.time.sec=1329913284,oob.time.usec=226795,oob.mark=0,oob.ifindex_in=3,oob.hook=1,raw.mac_len=14,oob.family=2,oob.protocol=2048,raw.label=0,raw.type=1,raw.mac.addrlen=6

People that like parsing comma-separated key-value files will
like this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 ulogd.conf.in |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/ulogd.conf.in b/ulogd.conf.in
index 71e8255..b33e69c 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -41,7 +41,6 @@ plugin="@pkglibexecdir@/ulogd_output_LOGEMU.so"
 plugin="@pkglibexecdir@/ulogd_output_SYSLOG.so"
 plugin="@pkglibexecdir@/ulogd_output_XML.so"
 #plugin="@pkglibexecdir@/ulogd_output_SQLITE3.so"
-#plugin="@pkglibexecdir@/ulogd_output_OPRINT.so"
 plugin="@pkglibexecdir@/ulogd_output_GPRINT.so"
 #plugin="@pkglibexecdir@/ulogd_output_NACCT.so"
 #plugin="@pkglibexecdir@/ulogd_output_PCAP.so"
@@ -63,11 +62,14 @@ plugin="@pkglibexecdir@/ulogd_inpflow_NFACCT.so"
 # this is a stack for packet-based logging via LOGEMU with filtering on MARK
 #stack=log2:NFLOG,mark1:MARK,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
 
+# this is a stack for packet-based logging via GPRINT
+#stack=log1:NFLOG,gp1:GPRINT
+
 # this is a stack for flow-based logging via LOGEMU
 #stack=ct1:NFCT,ip2str1:IP2STR,print1:PRINTFLOW,emu1:LOGEMU
 
-# this is a stack for flow-based logging via OPRINT
-#stack=ct1:NFCT,op1:OPRINT
+# this is a stack for flow-based logging via GPRINT
+#stack=ct1:NFCT,gp1:GPRINT
 
 # this is a stack for flow-based logging via XML
 #stack=ct1:NFCT,xml1:XML
-- 
1.7.7.3

