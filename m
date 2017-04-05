From: gfree.wind@foxmail.com
Subject: [PATCH nf-next v2 1/1] netfilter: udplite: Remove duplicated udplite4/6 declaration
Date: Wed,  5 Apr 2017 09:57:04 +0800
Message-ID: <1491357424-72486-1-git-send-email-gfree.wind@foxmail.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbguseast2.qq.com ([54.204.34.130]:52623 "EHLO
        smtpbguseast2.qq.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752053AbdDEB5R (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Apr 2017 21:57:17 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

There are two nf_conntrack_l4proto_udp4 declarations in the head file
nf_conntrack_ipv4/6.h. Now remove one which is not enbraced by the macro
CONFIG_NF_CT_PROTO_UDPLITE.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 v2: Remove the duplicated declaration in ipv6, per Gao Feng
 v1: initial version

 include/net/netfilter/ipv4/nf_conntrack_ipv4.h | 1 -
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
index 6ff3281..919e4e8 100644
--- a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
@@ -14,7 +14,6 @@
 
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4;
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4;
-extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite4;
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp;
 #ifdef CONFIG_NF_CT_PROTO_DCCP
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp4;
diff --git a/include/net/netfilter/ipv6/nf_conntrack_ipv6.h b/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
index c59b824..eaea968 100644
--- a/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
+++ b/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
@@ -5,7 +5,6 @@
 
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6;
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6;
-extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite6;
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6;
 #ifdef CONFIG_NF_CT_PROTO_DCCP
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp6;
-- 
1.9.1




