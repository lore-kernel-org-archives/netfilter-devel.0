Return-Path: <SRS0=j12K=W5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D69FAC3A59E
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE67822CF7
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="WJeQTXRK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbfIBXc0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Sep 2019 19:32:26 -0400
Received: from kadath.azazel.net ([81.187.231.250]:44056 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726775AbfIBXc0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Sep 2019 19:32:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GMg3YzppzusPUdVXNYlGJXVpD/USuK8aynnyrfVSRHQ=; b=WJeQTXRKXJ+ODKHEs9UsqR4Y0Q
        psLy+WoqcuHTUZJ2UgEnz1YDFbt3RaCRHT9aISb2fuErC1hOJDV/2RYXT5AfcHPAiRwFNyzrQg4Qq
        oUGEBTV4Ez7xh/HJKQpXZXh8VD64+WSz8cPON38g+mJl9ltO3IvhYmfT/4epjMfeyUMJuIRL6bP2B
        Vo3vCsaFz2Dn3Xh0kzWQBqJA/s5uZzdXIuX508uHDfUhUW0t9Awe9cnEeGbjDLhAYJBI0phVsQOZq
        JVyUL0Ln2KTXOO/ofBZWprksQ23czUzQQpC7rDtTwW3OZyd2zJNB6EsSRWMizSxgh1zVVLDQhbs/8
        7x6fqgOA==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4vPS-0004la-Ju; Tue, 03 Sep 2019 00:06:54 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 25/30] netfilter: wrap some conntrack code in a CONFIG_NF_CONNTRACK check.
Date:   Tue,  3 Sep 2019 00:06:45 +0100
Message-Id: <20190902230650.14621-26-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190902230650.14621-1-jeremy@azazel.net>
References: <20190902230650.14621-1-jeremy@azazel.net>
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

