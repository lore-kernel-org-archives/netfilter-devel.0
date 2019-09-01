Return-Path: <SRS0=UAOK=W4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03349C3A5A4
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 21:01:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE8DD2190F
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 21:01:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="XIpE4cb6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729041AbfIAVBX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Sep 2019 17:01:23 -0400
Received: from kadath.azazel.net ([81.187.231.250]:53570 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729013AbfIAVBX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Sep 2019 17:01:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GMg3YzppzusPUdVXNYlGJXVpD/USuK8aynnyrfVSRHQ=; b=XIpE4cb6gtSXKUZ07QjYpio6b3
        2WBUmTXdlKsV8WdsnQbAmOGG5+SKH8R+1zlaXQEL7GAnLe4CSmFlbP71Tb6zWmBdSDwWnD4kPyfao
        51T4G2KCjaaBYx55rp6fi2DxOJ85UJndasf7gRObXOZt1c1oGHtLNbhx5qc37Ta+B87T4ZdaptSFe
        Id9YWgFm7315TAH91S0iVH7KzYG9iOJhxAUVq9Z+C77pkS9q/OifpNGedEnhREyFC2nSqWrJ6n+xi
        pnjbw2WJY4xAqtHVyG/QHkZ1Fl/rQlDEmL98wQG/xhsj6ODAcRV7Kyaxcp+jIcGnwr7wVutQxBYtn
        AMqwk3KQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4Wor-0002Uf-Ra; Sun, 01 Sep 2019 21:51:29 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 24/29] netfilter: wrap some conntrack code in a CONFIG_NF_CONNTRACK check.
Date:   Sun,  1 Sep 2019 21:51:20 +0100
Message-Id: <20190901205126.6935-25-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190901205126.6935-1-jeremy@azazel.net>
References: <20190901205126.6935-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

struct nf_conntrack_zone is only required if CONFIG_NF_CONNTRACK.
Wrap its definition in a CONFIG_NF_CONNTRACK check.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/linux/netfilter/nf_conntrack_zones_common.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/netfilter/nf_conntrack_zones_common.h b/include/linux/netfilter/nf_conntrack_zones_common.h
index 8f3905e12a64..4596f9eb2e8f 100644
--- a/include/linux/netfilter/nf_conntrack_zones_common.h
+++ b/include/linux/netfilter/nf_conntrack_zones_common.h
@@ -13,6 +13,8 @@
 
 #define NF_CT_FLAG_MARK		1
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+
 struct nf_conntrack_zone {
 	u16	id;
 	u8	flags;
@@ -21,4 +23,6 @@ struct nf_conntrack_zone {
 
 extern const struct nf_conntrack_zone nf_ct_zone_dflt;
 
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK) */
+
 #endif /* _NF_CONNTRACK_ZONES_COMMON_H */
-- 
2.23.0.rc1

