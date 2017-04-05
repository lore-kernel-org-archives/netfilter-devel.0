From: gfree.wind@foxmail.com
Subject: [PATCH nf-next 1/1] netfilter: udplite4: Remove duplicated udplite4 declaration
Date: Wed,  5 Apr 2017 09:23:15 +0800
Message-ID: <1491355395-52913-1-git-send-email-gfree.wind@foxmail.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbguseast2.qq.com ([54.204.34.130]:51701 "EHLO
        smtpbguseast2.qq.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752657AbdDEBXb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Apr 2017 21:23:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

There are two nf_conntrack_l4proto_udp4 declarations in the head file
nf_conntrack_ipv4.h. Now remove one which is not enbraced by the macro
CONFIG_NF_CT_PROTO_UDPLITE.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h | 1 -
 1 file changed, 1 deletion(-)

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
-- 
1.9.1




