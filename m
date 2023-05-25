Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BCEEC83005
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 May 2023 18:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243235AbjEYS4T (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 May 2023 14:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243504AbjEYSzY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 May 2023 14:55:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BBE211D;
        Thu, 25 May 2023 11:47:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5425864976;
        Thu, 25 May 2023 18:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483C5C433A0;
        Thu, 25 May 2023 18:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685040306;
        bh=tuPD9tbd1QFn6JVrf++j4GfjcNGEqO9MaIreX1BrwjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ll4kiKiv+P7V5ocPkJdnewhQwAmx2lk+6Gp+c+P+v7S7lQK4e8hwa49Y+HY1LQGrW
         Cl/miqQvK+5sG/kSgR+7IBrJd6xt3lYXi+SaonQZ4Cg40XopE8rK6DGok2cMuuvckF
         y+g+OWgdcT0LjkhVH+iEhqfYdXjYcy5YT5FEjXwg0EY0RggJtaDIa+BunVFfUOUF9b
         XIpnUUJTmoEabYI4bVY+vrl3Wby3yAdFNuahiz6V8RKquioGV8/ZdFqA+KQ72K8n6Y
         +MKYfTjdckkp8W3PZQpcRvj3X+Lu/pByFcvFElElA5HOi3kXXOvnjI9HlEH0vM8UDi
         mHm/NB9vZAchA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tom Rix <trix@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>, pablo@netfilter.org,
        kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 24/27] netfilter: conntrack: define variables exp_nat_nla_policy and any_addr with CONFIG_NF_NAT
Date:   Thu, 25 May 2023 14:43:50 -0400
Message-Id: <20230525184356.1974216-24-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230525184356.1974216-1-sashal@kernel.org>
References: <20230525184356.1974216-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit 224a876e37543eee111bf9b6aa4935080e619335 ]

gcc with W=1 and ! CONFIG_NF_NAT
net/netfilter/nf_conntrack_netlink.c:3463:32: error:
  ‘exp_nat_nla_policy’ defined but not used [-Werror=unused-const-variable=]
 3463 | static const struct nla_policy exp_nat_nla_policy[CTA_EXPECT_NAT_MAX+1] = {
      |                                ^~~~~~~~~~~~~~~~~~
net/netfilter/nf_conntrack_netlink.c:2979:33: error:
  ‘any_addr’ defined but not used [-Werror=unused-const-variable=]
 2979 | static const union nf_inet_addr any_addr;
      |                                 ^~~~~~~~

These variables use is controlled by CONFIG_NF_NAT, so should their definitions.

Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 58bba2e2691fa..eed597097fe1e 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2689,7 +2689,9 @@ static int ctnetlink_exp_dump_mask(struct sk_buff *skb,
 	return -1;
 }
 
+#if IS_ENABLED(CONFIG_NF_NAT)
 static const union nf_inet_addr any_addr;
+#endif
 
 static __be32 nf_expect_get_id(const struct nf_conntrack_expect *exp)
 {
@@ -3189,10 +3191,12 @@ ctnetlink_change_expect(struct nf_conntrack_expect *x,
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_NF_NAT)
 static const struct nla_policy exp_nat_nla_policy[CTA_EXPECT_NAT_MAX+1] = {
 	[CTA_EXPECT_NAT_DIR]	= { .type = NLA_U32 },
 	[CTA_EXPECT_NAT_TUPLE]	= { .type = NLA_NESTED },
 };
+#endif
 
 static int
 ctnetlink_parse_expect_nat(const struct nlattr *attr,
-- 
2.39.2

