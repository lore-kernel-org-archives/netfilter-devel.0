Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7670C433E6
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Mar 2021 11:55:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F06B64F6B
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Mar 2021 11:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbhCQLyg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Mar 2021 07:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbhCQLyG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Mar 2021 07:54:06 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 64BE0C06174A
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Mar 2021 04:54:06 -0700 (PDT)
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 05FD363547
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Mar 2021 12:54:02 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 2/3] netfilter: flowtable: move FLOW_OFFLOAD_DIR_MAX away from enumeration
Date:   Wed, 17 Mar 2021 12:53:53 +0100
Message-Id: <20210317115354.1805-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210317115354.1805-1-pablo@netfilter.org>
References: <20210317115354.1805-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This allows to remove the default case which should not ever happen and
that was added to avoid gcc warnings on unhandled FLOW_OFFLOAD_DIR_MAX
enumeration case.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h | 2 +-
 net/netfilter/nf_flow_table_core.c    | 4 ----
 net/netfilter/nf_flow_table_ip.c      | 8 --------
 3 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 54c4d5c908a5..ce507251b3d8 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -86,8 +86,8 @@ static inline bool nf_flowtable_hw_offload(struct nf_flowtable *flowtable)
 enum flow_offload_tuple_dir {
 	FLOW_OFFLOAD_DIR_ORIGINAL = IP_CT_DIR_ORIGINAL,
 	FLOW_OFFLOAD_DIR_REPLY = IP_CT_DIR_REPLY,
-	FLOW_OFFLOAD_DIR_MAX = IP_CT_DIR_MAX
 };
+#define FLOW_OFFLOAD_DIR_MAX	IP_CT_DIR_MAX
 
 struct flow_offload_tuple {
 	union {
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index ff5d94b644ac..3bdbd962a084 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -454,8 +454,6 @@ int nf_flow_snat_port(const struct flow_offload *flow,
 		new_port = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_port;
 		hdr->dest = new_port;
 		break;
-	default:
-		return -1;
 	}
 
 	return nf_flow_nat_port(skb, thoff, protocol, port, new_port);
@@ -482,8 +480,6 @@ int nf_flow_dnat_port(const struct flow_offload *flow,
 		new_port = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst_port;
 		hdr->source = new_port;
 		break;
-	default:
-		return -1;
 	}
 
 	return nf_flow_nat_port(skb, thoff, protocol, port, new_port);
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 2b8ee5dcef64..2c369cc1819e 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -96,8 +96,6 @@ static int nf_flow_snat_ip(const struct flow_offload *flow, struct sk_buff *skb,
 		new_addr = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_v4.s_addr;
 		iph->daddr = new_addr;
 		break;
-	default:
-		return -1;
 	}
 	csum_replace4(&iph->check, addr, new_addr);
 
@@ -121,8 +119,6 @@ static int nf_flow_dnat_ip(const struct flow_offload *flow, struct sk_buff *skb,
 		new_addr = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst_v4.s_addr;
 		iph->saddr = new_addr;
 		break;
-	default:
-		return -1;
 	}
 	csum_replace4(&iph->check, addr, new_addr);
 
@@ -371,8 +367,6 @@ static int nf_flow_snat_ipv6(const struct flow_offload *flow,
 		new_addr = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_v6;
 		ip6h->daddr = new_addr;
 		break;
-	default:
-		return -1;
 	}
 
 	return nf_flow_nat_ipv6_l4proto(skb, ip6h, thoff, &addr, &new_addr);
@@ -396,8 +390,6 @@ static int nf_flow_dnat_ipv6(const struct flow_offload *flow,
 		new_addr = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst_v6;
 		ip6h->saddr = new_addr;
 		break;
-	default:
-		return -1;
 	}
 
 	return nf_flow_nat_ipv6_l4proto(skb, ip6h, thoff, &addr, &new_addr);
-- 
2.20.1

