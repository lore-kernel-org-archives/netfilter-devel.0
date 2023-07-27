Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2738C001DC
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jul 2023 13:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbjG0Ngc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jul 2023 09:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbjG0Ngc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jul 2023 09:36:32 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF7C272C;
        Thu, 27 Jul 2023 06:36:31 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qP1AG-0003Ep-S0; Thu, 27 Jul 2023 15:36:24 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>, Lin Ma <linma@zju.edu.cn>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 4/5] netfilter: conntrack: validate cta_ip via parsing
Date:   Thu, 27 Jul 2023 15:35:59 +0200
Message-ID: <20230727133604.8275-5-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230727133604.8275-1-fw@strlen.de>
References: <20230727133604.8275-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

In current ctnetlink_parse_tuple_ip() function, nested parsing and
validation is splitting as two parts,  which could be cleanup to a
simplified form. As the nla_parse_nested_deprecated function
supports validation in the fly. These two finially reach same place
__nla_validate_parse with same validate flag.

nla_parse_nested_deprecated
  __nla_parse(.., NL_VALIDATE_LIBERAL, ..)
    __nla_validate_parse

nla_validate_nested_deprecated
  __nla_validate_nested(.., NL_VALIDATE_LIBERAL, ..)
    __nla_validate
      __nla_validate_parse

This commit removes the call to nla_validate_nested_deprecated and pass
cta_ip_nla_policy when do parsing.

Signed-off-by: Lin Ma <linma@zju.edu.cn>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_netlink.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 69c8c8c7e9b8..334db22199c1 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1321,15 +1321,11 @@ static int ctnetlink_parse_tuple_ip(struct nlattr *attr,
 	struct nlattr *tb[CTA_IP_MAX+1];
 	int ret = 0;
 
-	ret = nla_parse_nested_deprecated(tb, CTA_IP_MAX, attr, NULL, NULL);
+	ret = nla_parse_nested_deprecated(tb, CTA_IP_MAX, attr,
+					  cta_ip_nla_policy, NULL);
 	if (ret < 0)
 		return ret;
 
-	ret = nla_validate_nested_deprecated(attr, CTA_IP_MAX,
-					     cta_ip_nla_policy, NULL);
-	if (ret)
-		return ret;
-
 	switch (tuple->src.l3num) {
 	case NFPROTO_IPV4:
 		ret = ipv4_nlattr_to_tuple(tb, tuple, flags);
-- 
2.41.0

