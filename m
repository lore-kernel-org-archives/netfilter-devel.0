From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 16/53] netfilter: udplite: Remove duplicated udplite4/6 declaration
Date: Mon,  1 May 2017 12:46:43 +0200
Message-ID: <1493635640-24325-17-git-send-email-pablo@netfilter.org>
References: <1493635640-24325-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1493635640-24325-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Gao Feng <fgao@ikuai8.com>

There are two nf_conntrack_l4proto_udp4 declarations in the head file
nf_conntrack_ipv4/6.h. Now remove one which is not enbraced by the macro
CONFIG_NF_CT_PROTO_UDPLITE.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h | 1 -
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
index 6ff32815641b..919e4e8af327 100644
--- a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
@@ -14,7 +14,6 @@ extern struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4;
 
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4;
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4;
-extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite4;
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp;
 #ifdef CONFIG_NF_CT_PROTO_DCCP
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp4;
diff --git a/include/net/netfilter/ipv6/nf_conntrack_ipv6.h b/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
index c59b82456f89..eaea968f8657 100644
--- a/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
+++ b/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
@@ -5,7 +5,6 @@ extern struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6;
 
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6;
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6;
-extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite6;
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6;
 #ifdef CONFIG_NF_CT_PROTO_DCCP
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp6;
-- 
2.1.4
