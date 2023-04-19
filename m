Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27527C77B73
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Apr 2023 05:15:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbjDSFPk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Apr 2023 01:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbjDSFPi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Apr 2023 01:15:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A178730DC
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Apr 2023 22:15:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A3946305A
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2023 05:15:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2195FC433EF;
        Wed, 19 Apr 2023 05:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681881336;
        bh=sjko2/KPncsLa0CgnXSbu+s/uXxgzMKeweEBTNhyiUU=;
        h=From:To:Cc:Subject:Date:From;
        b=aSaVAlbjJRJdC9SnVwQ53mfL2LZx5s+k6kEPW/7QcI4elkDok73CPBZOO/tlk9b5d
         nyVfMBIhyoSTVsRW9WUvckhGLnBAPqfSXYzZC3qf6R74wAV4CojJxl5b9CYXz86y9r
         PZLVxnGhjillgPIsnZ6bGPD6zUINFPKk0Rx6Y+b0n5ubXSkXx8SPtepsC/FN7Q4F8O
         WvztBpwRaLoKsl92hIxZ79rSsYTjf9eZ4cXlJWmrCWoEoQmZYiRRKg4+ipRa2RySdL
         P5rV8Kt6U4SqX+hcm13AjZYP3D2ZdVhvoRUrm1cTLAzO9Su8iPGLF09VoDrLILGqcy
         5fKeYRVHErmHw==
From:   Tzung-Bi Shih <tzungbi@kernel.org>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        tzungbi@kernel.org, jiejiang@chromium.org,
        jasongustaman@chromium.org, garrick@chromium.org
Subject: [PATCH v3] netfilter: conntrack: fix wrong ct->timeout value
Date:   Wed, 19 Apr 2023 13:15:26 +0800
Message-ID: <20230419051526.3170053-1-tzungbi@kernel.org>
X-Mailer: git-send-email 2.40.0.396.gfff15efe05-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

(struct nf_conn)->timeout is an interval before the conntrack
confirmed.  After confirmed, it becomes a timestamp[1].

It is observed that timeout of an unconfirmed conntrack:
- Set by calling ctnetlink_change_timeout().  As a result,
  `nfct_time_stamp` was wrongly added to `ct->timeout` twice[2].
- Get by calling ctnetlink_dump_timeout().  As a result,
  `nfct_time_stamp` was wrongly subtracted[3].

Separate the 2 cases in:
- Setting `ct->timeout` in __nf_ct_set_timeout().
- Getting `ct->timeout` in ctnetlink_dump_timeout().

[1]: https://elixir.bootlin.com/linux/v6.3-rc5/source/net/netfilter/nf_conntrack_core.c#L1257
[2]: https://elixir.bootlin.com/linux/v6.3-rc5/source/include/net/netfilter/nf_conntrack_core.h#L92
[3]: https://elixir.bootlin.com/linux/v6.3-rc5/source/include/net/netfilter/nf_conntrack.h#L296

Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
---
Changes from v2 (https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230410093454.853575-1-tzungbi@kernel.org/):
- Revert to v1 and apply partial changes per discussion thread in v1.
- Don't use WRITE_ONCE() and READ_ONCE() on unconfirmed conntrack.

Changes from v1 (https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230410060935.253503-1-tzungbi@kernel.org/):
- Just skip updating if the conntrack is unconfirmed per review comment.

 include/net/netfilter/nf_conntrack_core.h | 6 +++++-
 net/netfilter/nf_conntrack_netlink.c      | 7 ++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 71d1269fe4d4..3384859a8921 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -89,7 +89,11 @@ static inline void __nf_ct_set_timeout(struct nf_conn *ct, u64 timeout)
 {
 	if (timeout > INT_MAX)
 		timeout = INT_MAX;
-	WRITE_ONCE(ct->timeout, nfct_time_stamp + (u32)timeout);
+
+	if (nf_ct_is_confirmed(ct))
+		WRITE_ONCE(ct->timeout, nfct_time_stamp + (u32)timeout);
+	else
+		ct->timeout = (u32)timeout;
 }
 
 int __nf_ct_change_timeout(struct nf_conn *ct, u64 cta_timeout);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index fbc47e4b7bc3..9e0fd72dc166 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -176,7 +176,12 @@ static int ctnetlink_dump_status(struct sk_buff *skb, const struct nf_conn *ct)
 static int ctnetlink_dump_timeout(struct sk_buff *skb, const struct nf_conn *ct,
 				  bool skip_zero)
 {
-	long timeout = nf_ct_expires(ct) / HZ;
+	long timeout;
+
+	if (nf_ct_is_confirmed(ct))
+		timeout = nf_ct_expires(ct) / HZ;
+	else
+		timeout = ct->timeout / HZ;
 
 	if (skip_zero && timeout == 0)
 		return 0;
-- 
2.40.0.396.gfff15efe05-goog

