From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH] Sort matches/targets in Kbuild file
Date: Sat, 20 Oct 2007 18:06:52 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710201805420.1997@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44548 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985AbXJTQGy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Oct 2007 12:06:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Same as before. If using stgit/quilt, this one should go right after 
netfilter-01-sort-matches-targets-in-nf-makefiles.diff, before xt_tos 
(which I'll resend in total, without delta)

===Patch begins here===

Sort matches and targets in the Kbuild file.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 include/linux/netfilter/Kbuild      |   18 +++++++++---------
 include/linux/netfilter_ipv4/Kbuild |   28 ++++++++++++++--------------
 include/linux/netfilter_ipv6/Kbuild |    2 +-
 3 files changed, 24 insertions(+), 24 deletions(-)

Index: linux-2.6/include/linux/netfilter/Kbuild
===================================================================
--- linux-2.6.orig/include/linux/netfilter/Kbuild
+++ linux-2.6/include/linux/netfilter/Kbuild
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
Index: linux-2.6/include/linux/netfilter_ipv4/Kbuild
===================================================================
--- linux-2.6.orig/include/linux/netfilter_ipv4/Kbuild
+++ linux-2.6/include/linux/netfilter_ipv4/Kbuild
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
Index: linux-2.6/include/linux/netfilter_ipv6/Kbuild
===================================================================
--- linux-2.6.orig/include/linux/netfilter_ipv6/Kbuild
+++ linux-2.6/include/linux/netfilter_ipv6/Kbuild
@@ -14,8 +14,8 @@ header-y += ip6t_mark.h
 header-y += ip6t_multiport.h
 header-y += ip6t_opts.h
 header-y += ip6t_owner.h
-header-y += ip6t_policy.h
 header-y += ip6t_physdev.h
+header-y += ip6t_policy.h
 header-y += ip6t_rt.h
 
 unifdef-y += ip6_tables.h

