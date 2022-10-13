Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B4BC433FE
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Oct 2022 14:38:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiJMOiL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 Oct 2022 10:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiJMOiK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Oct 2022 10:38:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A76E4F669
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2022 07:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665671888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=nC9c/Jm+RObmmIWeKgmV4nIyU2Y/0ZFQ8QWu0FDOBK0=;
        b=Vxz0DegimTHilVgxcmE893k3kDMLvK8BWzr5eZSg5KSCDFVzEPtbPcLTqGi94yzlCt980p
        4cC6g412LKaIuBYpwCp+/Ga5F01iprxc5csKY7CkZwHSSlT/dztctVYBlrCSAXxU/W40r5
        5FB+peoqjNj5eZsaS+heN8xFmDEtBNI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-460-zYW0GXlwMtKB86Jti4YJsQ-1; Thu, 13 Oct 2022 10:38:06 -0400
X-MC-Unique: zYW0GXlwMtKB86Jti4YJsQ-1
Received: by mail-wm1-f69.google.com with SMTP id b7-20020a05600c4e0700b003bde2d860d1so1275218wmq.8
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2022 07:38:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nC9c/Jm+RObmmIWeKgmV4nIyU2Y/0ZFQ8QWu0FDOBK0=;
        b=LMKp3u4EQITc/ShrBoknwFhPTxQkyKuuTVbi8t133JVTjAf/a0p6NSSQ5Am478vKgE
         Bem2tZUiX2FT52dIWpxPy175ABqva4SQ+8hEu7Ple8DK6Aq0X0kdiITSrJTaKTO1euWi
         9ynvoWKGYyssNHUWH4oGDYCGZWKGyfgRUa5v2U9ihiywOmQzbYEBvVs4Gx/AT4XMmWjL
         +QlTMMbW3SbQhOtXAjb5poLbZ011I/eadMXI5PUDLUZ83XuVj4zsZ7isUvp3YZ5BlrkO
         Jc9E8JtQu4SEx040Kd/vV/1tH6DC0S5pmP64dA8G8+j42jTwIyEgto4UA2Aq0a1+QQ01
         V1ow==
X-Gm-Message-State: ACrzQf3WAOJEthIRy02oWIKdLXzX/dwxo5+/CM+QYlLmeDbw3LcZwXy2
        DSY/V0PCnL0R0GGiy5yuCzSRT1hMIlAvQBELzpo1fUTJcD81B4NkOVkskOGT9hXo5bGhZEl2JdD
        TBec1vpkTMXg8KxVdEACvyKgJcLQe
X-Received: by 2002:a1c:2507:0:b0:3b3:3681:f774 with SMTP id l7-20020a1c2507000000b003b33681f774mr6984117wml.134.1665671870398;
        Thu, 13 Oct 2022 07:37:50 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4APSDwcDxmBbyuFFlLl9MxcaVs8zOmKaldZaDbiBU/tW8rQnuf6Egvnmm/R4jzWr/9QxfPYg==
X-Received: by 2002:a1c:2507:0:b0:3b3:3681:f774 with SMTP id l7-20020a1c2507000000b003b33681f774mr6984102wml.134.1665671870161;
        Thu, 13 Oct 2022 07:37:50 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id ay38-20020a05600c1e2600b003c6b70a4d69sm4463261wmb.42.2022.10.13.07.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 07:37:49 -0700 (PDT)
Date:   Thu, 13 Oct 2022 16:37:47 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>, kadlec@netfilter.org,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Lorenzo Colitti <lorenzo@google.com>
Subject: [PATCH nf] netfilter: rpfilter/fib: Set ->flowic_uid correctly for
 user namespaces.
Message-ID: <8853c474dc0f7baafcd3efb8e34a4d12be472495.1665671763.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently netfilter's rpfilter and fib modules implicitely initialise
->flowic_uid with 0. This is normally the root UID. However, this isn't
the case in user namespaces, where user ID 0 is mapped to a different
kernel UID. By initialising ->flowic_uid with sock_net_uid(), we get
the root UID of the user namespace, thus keeping the same behaviour
whether or not we're running in a user namepspace.

Note, this is similar to commit 8bcfd0925ef1 ("ipv4: add missing
initialization for flowi4_uid"), which fixed the rp_filter sysctl.

Fixes: 622ec2c9d524 ("net: core: add UID to flows, rules, and routes")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/ipv4/netfilter/ipt_rpfilter.c  | 1 +
 net/ipv4/netfilter/nft_fib_ipv4.c  | 1 +
 net/ipv6/netfilter/ip6t_rpfilter.c | 1 +
 net/ipv6/netfilter/nft_fib_ipv6.c  | 2 ++
 4 files changed, 5 insertions(+)

diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
index ff85db52b2e5..ded5bef02f77 100644
--- a/net/ipv4/netfilter/ipt_rpfilter.c
+++ b/net/ipv4/netfilter/ipt_rpfilter.c
@@ -78,6 +78,7 @@ static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	flow.flowi4_tos = iph->tos & IPTOS_RT_MASK;
 	flow.flowi4_scope = RT_SCOPE_UNIVERSE;
 	flow.flowi4_l3mdev = l3mdev_master_ifindex_rcu(xt_in(par));
+	flow.flowi4_uid = sock_net_uid(xt_net(par), NULL);
 
 	return rpfilter_lookup_reverse(xt_net(par), &flow, xt_in(par), info->flags) ^ invert;
 }
diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index e886147eed11..fc65d69f23e1 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -65,6 +65,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	struct flowi4 fl4 = {
 		.flowi4_scope = RT_SCOPE_UNIVERSE,
 		.flowi4_iif = LOOPBACK_IFINDEX,
+		.flowi4_uid = sock_net_uid(nft_net(pkt), NULL),
 	};
 	const struct net_device *oif;
 	const struct net_device *found;
diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
index 69d86b040a6a..a01d9b842bd0 100644
--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -40,6 +40,7 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
 		.flowi6_l3mdev = l3mdev_master_ifindex_rcu(dev),
 		.flowlabel = (* (__be32 *) iph) & IPV6_FLOWINFO_MASK,
 		.flowi6_proto = iph->nexthdr,
+		.flowi6_uid = sock_net_uid(net, NULL),
 		.daddr = iph->saddr,
 	};
 	int lookup_flags;
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index 91faac610e03..36dc14b34388 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -66,6 +66,7 @@ static u32 __nft_fib6_eval_type(const struct nft_fib *priv,
 	struct flowi6 fl6 = {
 		.flowi6_iif = LOOPBACK_IFINDEX,
 		.flowi6_proto = pkt->tprot,
+		.flowi6_uid = sock_net_uid(nft_net(pkt), NULL),
 	};
 	u32 ret = 0;
 
@@ -163,6 +164,7 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	struct flowi6 fl6 = {
 		.flowi6_iif = LOOPBACK_IFINDEX,
 		.flowi6_proto = pkt->tprot,
+		.flowi6_uid = sock_net_uid(nft_net(pkt), NULL),
 	};
 	struct rt6_info *rt;
 	int lookup_flags;
-- 
2.21.3

