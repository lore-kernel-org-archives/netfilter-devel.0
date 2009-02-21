From: Jan Engelhardt <jengelh@medozas.de>
Subject: netfilter: install missing headers
Date: Sat, 21 Feb 2009 04:44:57 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902210443180.32599@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@vyatta.com>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54470 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbZBUDo6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 22:44:58 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


I hope now I got it right!

---8<---
parent 5eebd6df9f3304f74b611fe47bab50fd3a1c668b (v2.6.29-rc4-30-g5eebd6d)
commit 499c9627ecb75566801d96f0e91c9da356b6a8c8
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sat Feb 21 04:44:18 2009 +0100

netfilter: install missing headers

iptables imports headers from (the unifdefed headers of a)
kernel tree, but some headers happened to not be installed.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/Kbuild      |    6 ++++++
 include/linux/netfilter_ipv6/Kbuild |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index 5a8af87..84644ad 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -13,8 +13,11 @@ header-y += xt_NFQUEUE.h
 header-y += xt_RATEEST.h
 header-y += xt_SECMARK.h
 header-y += xt_TCPMSS.h
+header-y += xt_TCPOPTSTRIP.h
+header-y += xt_TPROXY.h
 header-y += xt_comment.h
 header-y += xt_connbytes.h
+header-y += xt_connlimit.h
 header-y += xt_connmark.h
 header-y += xt_conntrack.h
 header-y += xt_dccp.h
@@ -30,6 +33,7 @@ header-y += xt_mark.h
 header-y += xt_multiport.h
 header-y += xt_owner.h
 header-y += xt_pkttype.h
+header-y += xt_quota.h
 header-y += xt_rateest.h
 header-y += xt_realm.h
 header-y += xt_recent.h
@@ -39,6 +43,8 @@ header-y += xt_statistic.h
 header-y += xt_string.h
 header-y += xt_tcpmss.h
 header-y += xt_tcpudp.h
+header-y += xt_time.h
+header-y += xt_u32.h
 
 unifdef-y += nf_conntrack_common.h
 unifdef-y += nf_conntrack_ftp.h
diff --git a/include/linux/netfilter_ipv6/Kbuild b/include/linux/netfilter_ipv6/Kbuild
index 8887a5f..aca4bd1 100644
--- a/include/linux/netfilter_ipv6/Kbuild
+++ b/include/linux/netfilter_ipv6/Kbuild
@@ -11,6 +11,7 @@ header-y += ip6t_length.h
 header-y += ip6t_limit.h
 header-y += ip6t_mac.h
 header-y += ip6t_mark.h
+header-y += ip6t_mh.h
 header-y += ip6t_multiport.h
 header-y += ip6t_opts.h
 header-y += ip6t_owner.h
-- 
# Created with git-export-patch

