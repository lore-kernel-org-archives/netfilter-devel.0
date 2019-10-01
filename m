Return-Path: <SRS0=ZC8Q=X2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C84DC388F3
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Oct 2019 08:55:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 587802133F
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Oct 2019 08:55:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="lbsGjsWG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733193AbfJAIz2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Oct 2019 04:55:28 -0400
Received: from mail-m964.mail.126.com ([123.126.96.4]:49510 "EHLO
        mail-m964.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbfJAIz2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Oct 2019 04:55:28 -0400
X-Greylist: delayed 1819 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Oct 2019 04:55:26 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=8+PkyfTKytiTLsOI38
        wFrb2knSB9Am6i5LeugKWw9WQ=; b=lbsGjsWGEkeVAIkDd4hYYzzM1Pjr32hoS5
        a4ZpV12XLxW49wzP4EaHN7rcCAfppBn1LZeRTR6GI48uO++0CHywuMaZqwxh/E1P
        Sg5JmrsQWdUwDjul59BMda1SsF+I6e20d+LqrNKSTdPKZat3CNWt/IDSXB9xHbxs
        E6423apYs=
Received: from localhost.localdomain (unknown [123.116.149.18])
        by smtp9 (Coremail) with SMTP id NeRpCgCnLRpbDZNdDyGnAA--.8531S2;
        Tue, 01 Oct 2019 16:25:00 +0800 (CST)
From:   wh_bin@126.com
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wh_bin@126.com
Subject: [PATCH] netfilter:get_next_corpse():No need to double check the *bucket
Date:   Tue,  1 Oct 2019 16:24:41 +0800
Message-Id: <20191001082441.7140-1-wh_bin@126.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: NeRpCgCnLRpbDZNdDyGnAA--.8531S2
X-Coremail-Antispam: 1Uf129KBjvJXoWrurW7uryfZry3tFWfZFyxXwb_yoW8JryUpw
        nakw1ay34xWrs0yF4Fgry7AFsxCws3ua1jgr45G34rGwnrGwn8CF48Kry7Xas8Xrs5JF13
        Ars0yw1j9F1kXw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UTKZZUUUUU=
X-Originating-IP: [123.116.149.18]
X-CM-SenderInfo: xzkbuxbq6rjloofrz/1tbiWBxBol1w0rQrGwAAsc
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Hongbin Wang <wh_bin@126.com>

The *bucket is in for loops,it has been checked.

Signed-off-by: Hongbin Wang <wh_bin@126.com>
---
 net/netfilter/nf_conntrack_core.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0c63120b2db2..8d48babe6561 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2000,14 +2000,12 @@ get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
 		lockp = &nf_conntrack_locks[*bucket % CONNTRACK_LOCKS];
 		local_bh_disable();
 		nf_conntrack_lock(lockp);
-		if (*bucket < nf_conntrack_htable_size) {
-			hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[*bucket], hnnode) {
-				if (NF_CT_DIRECTION(h) != IP_CT_DIR_ORIGINAL)
-					continue;
-				ct = nf_ct_tuplehash_to_ctrack(h);
-				if (iter(ct, data))
-					goto found;
-			}
+		hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[*bucket], hnnode) {
+			if (NF_CT_DIRECTION(h) != IP_CT_DIR_ORIGINAL)
+				continue;
+			ct = nf_ct_tuplehash_to_ctrack(h);
+			if (iter(ct, data))
+				goto found;
 		}
 		spin_unlock(lockp);
 		local_bh_enable();
-- 
2.17.1

