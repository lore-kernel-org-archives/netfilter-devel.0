From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/07]: Sort matches/targets in Kbuild file
Date: Fri,  2 Nov 2007 12:23:16 +0100 (MET)
Message-ID: <20071102112005.22803.46558.sendpatchset@localhost.localdomain>
References: <20071102112000.22803.92699.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45739 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbXKBLXR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Nov 2007 07:23:17 -0400
In-Reply-To: <20071102112000.22803.92699.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: Sort matches/targets in Kbuild file

Sort matches and targets in the Kbuild file.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5bbc87888870ac8831766b731f509a552e25815f
tree dbaae8867aa93a71478e09f1fda4826514e5f05f
parent af0bb06e1500a6ea534e94f1fd941865bce00b3d
author Jan Engelhardt <jengelh@computergmbh.de> Fri, 02 Nov 2007 11:58:57 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 02 Nov 2007 11:58:57 +0100

 include/linux/netfilter/Kbuild      |   18 +++++++++---------
 include/linux/netfilter_ipv4/Kbuild |   28 ++++++++++++++--------------
 include/linux/netfilter_ipv6/Kbuild |    2 +-
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index f2eaea2..b87e83a 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -4,25 +4,28 @@ header-y += nfnetlink_conntrack.h
 header-y += nfnetlink_log.h
 header-y += nfnetlink_queue.h
 header-y += xt_CLASSIFY.h
+header-y += xt_CONNMARK.h
+header-y += xt_CONNSECMARK.h
+header-y += xt_DSCP.h
+header-y += xt_MARK.h
+header-y += xt_NFLOG.h
+header-y += xt_NFQUEUE.h
+header-y += xt_SECMARK.h
+header-y += xt_TCPMSS.h
 header-y += xt_comment.h
 header-y += xt_connbytes.h
 header-y += xt_connmark.h
-header-y += xt_CONNMARK.h
 header-y += xt_conntrack.h
 header-y += xt_dccp.h
 header-y += xt_dscp.h
-header-y += xt_DSCP.h
 header-y += xt_esp.h
-header-y += xt_helper.h
 header-y += xt_hashlimit.h
+header-y += xt_helper.h
 header-y += xt_length.h
 header-y += xt_limit.h
 header-y += xt_mac.h
 header-y += xt_mark.h
-header-y += xt_MARK.h
 header-y += xt_multiport.h
-header-y += xt_NFQUEUE.h
-header-y += xt_NFLOG.h
 header-y += xt_pkttype.h
 header-y += xt_policy.h
 header-y += xt_realm.h
@@ -32,9 +35,6 @@ header-y += xt_statistic.h
 header-y += xt_string.h
 header-y += xt_tcpmss.h
 header-y += xt_tcpudp.h
-header-y += xt_SECMARK.h
-header-y += xt_CONNSECMARK.h
-header-y += xt_TCPMSS.h
 
 unifdef-y += nf_conntrack_common.h
 unifdef-y += nf_conntrack_ftp.h
diff --git a/include/linux/netfilter_ipv4/Kbuild b/include/linux/netfilter_ipv4/Kbuild
index 7185792..3a7105b 100644
--- a/include/linux/netfilter_ipv4/Kbuild
+++ b/include/linux/netfilter_ipv4/Kbuild
@@ -1,47 +1,47 @@
-header-y += ipt_addrtype.h
-header-y += ipt_ah.h
 header-y += ipt_CLASSIFY.h
 header-y += ipt_CLUSTERIP.h
+header-y += ipt_CONNMARK.h
+header-y += ipt_DSCP.h
+header-y += ipt_ECN.h
+header-y += ipt_LOG.h
+header-y += ipt_MARK.h
+header-y += ipt_NFQUEUE.h
+header-y += ipt_REJECT.h
+header-y += ipt_SAME.h
+header-y += ipt_TCPMSS.h
+header-y += ipt_TOS.h
+header-y += ipt_TTL.h
+header-y += ipt_ULOG.h
+header-y += ipt_addrtype.h
+header-y += ipt_ah.h
 header-y += ipt_comment.h
 header-y += ipt_connbytes.h
 header-y += ipt_connmark.h
-header-y += ipt_CONNMARK.h
 header-y += ipt_conntrack.h
 header-y += ipt_dccp.h
 header-y += ipt_dscp.h
-header-y += ipt_DSCP.h
 header-y += ipt_ecn.h
-header-y += ipt_ECN.h
 header-y += ipt_esp.h
 header-y += ipt_hashlimit.h
 header-y += ipt_helper.h
 header-y += ipt_iprange.h
 header-y += ipt_length.h
 header-y += ipt_limit.h
-header-y += ipt_LOG.h
 header-y += ipt_mac.h
 header-y += ipt_mark.h
-header-y += ipt_MARK.h
 header-y += ipt_multiport.h
-header-y += ipt_NFQUEUE.h
 header-y += ipt_owner.h
 header-y += ipt_physdev.h
 header-y += ipt_pkttype.h
 header-y += ipt_policy.h
 header-y += ipt_realm.h
 header-y += ipt_recent.h
-header-y += ipt_REJECT.h
-header-y += ipt_SAME.h
 header-y += ipt_sctp.h
 header-y += ipt_state.h
 header-y += ipt_string.h
 header-y += ipt_tcpmss.h
-header-y += ipt_TCPMSS.h
 header-y += ipt_tos.h
-header-y += ipt_TOS.h
 header-y += ipt_ttl.h
-header-y += ipt_TTL.h
-header-y += ipt_ULOG.h
 
 unifdef-y += ip_queue.h
 unifdef-y += ip_tables.h
diff --git a/include/linux/netfilter_ipv6/Kbuild b/include/linux/netfilter_ipv6/Kbuild
index 9dd978d..8887a5f 100644
--- a/include/linux/netfilter_ipv6/Kbuild
+++ b/include/linux/netfilter_ipv6/Kbuild
@@ -14,8 +14,8 @@ header-y += ip6t_mark.h
 header-y += ip6t_multiport.h
 header-y += ip6t_opts.h
 header-y += ip6t_owner.h
-header-y += ip6t_policy.h
 header-y += ip6t_physdev.h
+header-y += ip6t_policy.h
 header-y += ip6t_rt.h
 
 unifdef-y += ip6_tables.h
