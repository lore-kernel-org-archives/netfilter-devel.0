Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F220FEB64DC
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Jul 2023 03:23:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjGKDXl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jul 2023 23:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjGKDXk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jul 2023 23:23:40 -0400
Received: from zg8tndyumtaxlji0oc4xnzya.icoremail.net (zg8tndyumtaxlji0oc4xnzya.icoremail.net [46.101.248.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DC962C0;
        Mon, 10 Jul 2023 20:23:36 -0700 (PDT)
Received: from localhost.localdomain (unknown [39.174.92.167])
        by mail-app4 (Coremail) with SMTP id cS_KCgBHTQ0Ry6xkZRACCQ--.54427S4;
        Tue, 11 Jul 2023 11:22:59 +0800 (CST)
From:   Lin Ma <linma@zju.edu.cn>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>
Subject: [PATCH v1] netfilter: conntrack: validate cta_ip via parsing
Date:   Tue, 11 Jul 2023 11:22:57 +0800
Message-Id: <20230711032257.3561166-1-linma@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cS_KCgBHTQ0Ry6xkZRACCQ--.54427S4
X-Coremail-Antispam: 1UD129KBjvJXoW7tr47WF1rGrW8WF43Ww1UGFg_yoW8Ar13pa
        4FgasrK39rJr40qw4Duw18WF9rCF4kZry5ur9IyaySyF1Dtw1j9ayrGF9xur13CFWkXr42
        vF4YqF45J3WUCaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvj14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
        Y2ka0xkIwI1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
        xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
        MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
        0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
        JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoO
        J5UUUUU
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In current ctnetlink_parse_tuple_ip() function, nested parsing and
validation is splitting as two parts. This is unnecessary as the
nla_parse_nested_deprecated function supports validation in the fly.
These two finially reach same place __nla_validate_parse with same
validate flag.

nla_parse_nested_deprecated
  __nla_parse(.., NL_VALIDATE_LIBERAL, ..)
    __nla_validate_parse

nla_validate_nested_deprecated
  __nla_validate_nested(.., NL_VALIDATE_LIBERAL, ..)
    __nla_validate
      __nla_validate_parse

This commit removes the call to nla_validate_nested_deprecated and pass
cta_ip_nla_policy when do parsing.

Fixes: 8cb081746c03 ("netlink: make validation more configurable for future strictness")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
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
2.17.1

