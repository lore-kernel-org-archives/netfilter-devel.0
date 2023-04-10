Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9FDBC77B61
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Apr 2023 09:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjDJJfG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Apr 2023 05:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjDJJfF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Apr 2023 05:35:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0705F30DC
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Apr 2023 02:35:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9381961006
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Apr 2023 09:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8E8C433EF;
        Mon, 10 Apr 2023 09:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681119303;
        bh=NqIj0ztQ9m2BllexE2PgMMJoy6AJCkqZCNP2gz7TVus=;
        h=From:To:Cc:Subject:Date:From;
        b=Um+2wWS9x7NqMT+fyJVGTlXkWWBcQeJjUEy2bPlt4yBnUqtB7vCtmhWhVsJ9gIsNi
         V2u4fzVg1WMSSPrRVwzhBEW3EYL1m5eGJh86IWgwqEvzaOHRpIlm6Ygmn7GAMHCct0
         FtsLsk+VCqHORt1UlqC7WqHuMs+4zhpd8sH4gjUZsWsJFn1UMIgHgO42L059RjKmZA
         zYN9hcF8iKQgEx2nEhqarRpQOd0SZAlEpeU7jrlgipLMB804XmARU0r0wnqha4ux90
         Q5/Hpvz2SKsbAfuzu7tQpMbBx1cfN11kuc16uEzrPwA1bueT6feghRoULpzzujoQ+n
         iDygqb8Qw8B/Q==
From:   Tzung-Bi Shih <tzungbi@kernel.org>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        tzungbi@kernel.org, jiejiang@chromium.org,
        jasongustaman@chromium.org, garrick@chromium.org
Subject: [PATCH v2] netfilter: conntrack: fix wrong ct->timeout value
Date:   Mon, 10 Apr 2023 17:34:54 +0800
Message-Id: <20230410093454.853575-1-tzungbi@kernel.org>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

(struct nf_conn)->timeout is an interval before the conntrack
confirmed.  After confirmed, it becomes a timestamp[1].

It is observed that timeout of an unconfirmed conntrack have been
altered by calling ctnetlink_change_timeout().  As a result,
`nfct_time_stamp` was wrongly added to `ct->timeout` twice[2].

Skip changing timeout if the conntrack is unconfirmed.

[1]: https://elixir.bootlin.com/linux/v6.3-rc5/source/net/netfilter/nf_conntrack_core.c#L1257
[2]: https://elixir.bootlin.com/linux/v6.3-rc5/source/include/net/netfilter/nf_conntrack_core.h#L92

Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
---
Changes from v1 (https://lore.kernel.org/netfilter-devel/20230410060935.253503-1-tzungbi@kernel.org/T/#u):
- Just skip updating if the conntrack is unconfirmed per review comment.

 net/netfilter/nf_conntrack_netlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index fbc47e4b7bc3..f5abea20774c 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1986,6 +1986,10 @@ static int ctnetlink_change_helper(struct nf_conn *ct,
 static int ctnetlink_change_timeout(struct nf_conn *ct,
 				    const struct nlattr * const cda[])
 {
+	/* skip changing timeout if the conntrack is unconfirmed */
+	if (!nf_ct_is_confirmed(ct))
+		return 0;
+
 	return __nf_ct_change_timeout(ct, (u64)ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ);
 }
 
-- 
2.40.0.577.gac1e443424-goog

