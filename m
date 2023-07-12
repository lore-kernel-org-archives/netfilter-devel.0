Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73E39EB64D9
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jul 2023 13:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbjGLNdJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Jul 2023 09:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbjGLNdB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jul 2023 09:33:01 -0400
Received: from zg8tndyumtaxlji0oc4xnzya.icoremail.net (zg8tndyumtaxlji0oc4xnzya.icoremail.net [46.101.248.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D997FC0
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jul 2023 06:32:58 -0700 (PDT)
Received: from localhost.localdomain (unknown [125.120.151.75])
        by mail-app2 (Coremail) with SMTP id by_KCgBXSsJ0q65kozGECQ--.10889S4;
        Wed, 12 Jul 2023 21:32:37 +0800 (CST)
From:   Lin Ma <linma@zju.edu.cn>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>
Subject: [PATCH v2] netfilter: conntrack: validate cta_ip via parsing
Date:   Wed, 12 Jul 2023 21:32:36 +0800
Message-Id: <20230712133236.280999-1-linma@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: by_KCgBXSsJ0q65kozGECQ--.10889S4
X-Coremail-Antispam: 1UD129KBjvJXoW7tr47AFyDKryDKr4rKF1DGFg_yoW8Ar4Dpa
        4rKF9rK39rJr40qw4Uu3WxWF9rCF4kZry5uryayaySyFn8Jr1j9ayrGF9xuF13CrWkXr42
        vF4YqF43J3WUAaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
        Y2ka0xkIwI1lc2xSY4AK67AK6ry8MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
        1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
        b7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
        vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
        cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
        nxnUUI43ZEXa7VUjHGQDUUUUU==
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

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
---
V1 -> V2: remove Fixes tag as this does not fix anything,
          and adjust the commit message

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
2.17.1

