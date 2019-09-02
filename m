Return-Path: <SRS0=j12K=W5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3598BC3A5A7
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03CB922CF7
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="twVPcts4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfIBXcE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Sep 2019 19:32:04 -0400
Received: from kadath.azazel.net ([81.187.231.250]:43914 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfIBXcE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Sep 2019 19:32:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZmvKMdx1Yja1CfdPxcR6lw1Mp1wLQW+OmLCcmt4PitM=; b=twVPcts4t2nNSlNfPHP/DNwWSf
        tGULVKMya7Eie6OKPX8jz2+HhIyO+THe90HTsE21PmvWIHe1svg3qDg6n+CLDdCiU27NWpiGq9rse
        qRd/RXFRt4Jg+dQ9jEvSEr7ghr3eh5rJyMueLwKI44TnjE/YQgHBzHTF/mV3KoGtaYvyfY6yIstVQ
        vHTW8ZgJ4MKqTBUKTogOUmth3s5V2jqPojfJx3+HzXUUcrfQ8qkUoGROPU9H9PMMHtl2sBnxgZOtB
        nJ7++WSf1ElDbfkclxChKvuga6UQo6qRjH5TZSWee0o5lutLyOFeM7b9BQiSPS/cA7Gmc3t4iOvBi
        8nJvmD3g==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4vPS-0004la-Oo; Tue, 03 Sep 2019 00:06:54 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 26/30] netfilter: add CONFIG_NETFILTER check to linux/netfilter.h.
Date:   Tue,  3 Sep 2019 00:06:46 +0100
Message-Id: <20190902230650.14621-27-jeremy@azazel.net>
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

The bulk of this header is already wrapped in CONFIG_NETFILTER or
CONFIG_NF_CONNTRACK checks.  The last few definitions are also only
required if CONFIG_NETFILTER is enabled.  Add another conditional for
that remainder.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/linux/netfilter.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 3bed59528fed..075d48ef6a48 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -16,6 +16,7 @@
 #include <net/net_namespace.h>
 
 #ifdef CONFIG_NETFILTER
+
 static inline int NF_DROP_GETERR(int verdict)
 {
 	return -(verdict >> NF_VERDICT_QBITS);
@@ -415,11 +416,13 @@ static inline int nf_hook(u_int8_t pf, unsigned int hook, struct net *net,
 {
 	return 1;
 }
+
 struct flowi;
 static inline void
 nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, u_int8_t family)
 {
 }
+
 #endif /*CONFIG_NETFILTER*/
 
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
@@ -440,6 +443,8 @@ static inline bool nf_ct_get_tuple_skb(struct nf_conntrack_tuple *dst_tuple,
 }
 #endif
 
+#ifdef CONFIG_NETFILTER
+
 struct nf_conn;
 enum ip_conntrack_info;
 
@@ -486,4 +491,6 @@ struct nf_bridge_frag_data {
 	__be16  vlan_proto;
 };
 
+#endif /* CONFIG_NETFILTER */
+
 #endif /*__LINUX_NETFILTER_H*/
-- 
2.23.0.rc1

