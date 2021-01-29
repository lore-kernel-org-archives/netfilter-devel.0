Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A3BBC433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Jan 2021 20:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD78D64E04
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Jan 2021 20:12:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbhA2ULy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Jan 2021 15:11:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233290AbhA2UJn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Jan 2021 15:09:43 -0500
X-Greylist: delayed 559 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 29 Jan 2021 12:08:52 PST
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B8CC061574
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jan 2021 12:08:52 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 2687367401CA;
        Fri, 29 Jan 2021 20:57:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mail.kfki.hu; h=
        mime-version:message-id:from:from:date:date:received:received
        :received:received; s=20151130; t=1611950264; x=1613764665; bh=9
        bfQBoS20Ayh4lgOFpAYmOU1UtN8w4WzsWM/Ng1QMx0=; b=AoHyuCHzm2ah1GTP9
        L/TOQb5ssr5SnIxLkSko52YC347svbWlhc7HeLrKt/CTaDsMDr5Q0FW2FLhzWv/1
        SCsJDgRF8NRZEhJY7ixtGQVUzlExIgab0mlSYKlpk2nGg2qLD7Z+0XHDnPAkLjAz
        EaVJ1wn1m8X5DBaEHejNnoqEC4=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Fri, 29 Jan 2021 20:57:44 +0100 (CET)
Received: from localhost.kfki.hu (host-94-248-219-210.kabelnet.hu [94.248.219.210])
        (Authenticated sender: kadlecsik.jozsef@wigner.mta.hu)
        by smtp0.kfki.hu (Postfix) with ESMTPSA id C8B6E67401C8;
        Fri, 29 Jan 2021 20:57:43 +0100 (CET)
Received: by localhost.kfki.hu (Postfix, from userid 1000)
        id 5BE32300364; Fri, 29 Jan 2021 20:57:43 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by localhost.kfki.hu (Postfix) with ESMTP id 57D903001FB;
        Fri, 29 Jan 2021 20:57:43 +0100 (CET)
Date:   Fri, 29 Jan 2021 20:57:43 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@mail.kfki.hu>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH] netfilter: Fix attempt to update deleted entry in
 xt_recent
Message-ID: <4347729e-9cf2-bda9-19d7-ad3338f6baaa@mail.kfki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Please review the next patch and consider applying it in the nf branch:

When both --reap and --update flag are specified, there's a code
path at which the entry to be updated is reaped beforehand,
which then leads to kernel crash. Reap only entries which won't be
updated.

Fixes kernel bugzilla #207773.

Reported by Reindl Harald.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/xt_recent.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 606411869698..0446307516cd 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -152,7 +152,8 @@ static void recent_entry_remove(struct recent_table *t, struct recent_entry *e)
 /*
  * Drop entries with timestamps older then 'time'.
  */
-static void recent_entry_reap(struct recent_table *t, unsigned long time)
+static void recent_entry_reap(struct recent_table *t, unsigned long time,
+			      struct recent_entry *working, bool update)
 {
 	struct recent_entry *e;
 
@@ -161,6 +162,12 @@ static void recent_entry_reap(struct recent_table *t, unsigned long time)
 	 */
 	e = list_entry(t->lru_list.next, struct recent_entry, lru_list);
 
+	/*
+	 * Do not reap the entry which are going to be updated.
+	 */
+	if (e == working && update)
+		return;
+
 	/*
 	 * The last time stamp is the most recent.
 	 */
@@ -303,7 +310,8 @@ recent_mt(const struct sk_buff *skb, struct xt_action_param *par)
 
 		/* info->seconds must be non-zero */
 		if (info->check_set & XT_RECENT_REAP)
-			recent_entry_reap(t, time);
+			recent_entry_reap(t, time, e,
+				info->check_set & XT_RECENT_UPDATE && ret);
 	}
 
 	if (info->check_set & XT_RECENT_SET ||
-- 
2.20.1

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
