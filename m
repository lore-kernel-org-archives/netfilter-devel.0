Return-Path: <SRS0=j12K=W5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E47BC3A59E
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66EDE22CF7
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="d7a4DGut"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbfIBXch (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Sep 2019 19:32:37 -0400
Received: from kadath.azazel.net ([81.187.231.250]:44130 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfIBXch (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Sep 2019 19:32:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FR0MpU4KHXBrP1ahQl7aUyUN4zyTKtmhmQWrFZL+4IU=; b=d7a4DGutE4YnbqmCqUlezGsVWn
        GnZ+/PjkaRyQT20TGL85mxVj6LShIhn4vex7y8wgdh5ooi8LNV6hPuEgubQVay/d4hOraZ5gxgyjb
        71p1FpUzD5imhZIiQguGwB/ul69YwLKv3CBQLG7NCKBry3z+iZisBa5wV+9HJHzRMp9wRfgflGzcc
        l15bTm1nreH0YAgfPZ6SRyVhgPc4++GSG1VsNkG6KHY7HDpM5KhEjiH2LRTGjyV8T9aC+NUYVzOFC
        fNx0Urc1Gz7WWXKmeyjZv7x9QaqVjopSDiDASBh0/9f6nQiux2gguhIFRBel7hnwZPe46Lf65uPgf
        gAkwrWSQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4vPR-0004la-PW; Tue, 03 Sep 2019 00:06:53 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 20/30] netfilter: wrap union nf_conntrack_proto members in CONFIG_NF_CT_PROTO_* check.
Date:   Tue,  3 Sep 2019 00:06:40 +0100
Message-Id: <20190902230650.14621-21-jeremy@azazel.net>
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

dccp, sctp and gre are only used in code enabled by particular
CONFIG_NF_CT_PROTO_* options.  Wrap them in the checks for those
options.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/net/netfilter/nf_conntrack.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 22275f42f0bb..0673cf685741 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -33,11 +33,17 @@ struct nf_ct_udp {
 /* per conntrack: protocol private data */
 union nf_conntrack_proto {
 	/* insert conntrack proto private data here */
+#ifdef CONFIG_NF_CT_PROTO_DCCP
 	struct nf_ct_dccp dccp;
+#endif
+#ifdef CONFIG_NF_CT_PROTO_SCTP
 	struct ip_ct_sctp sctp;
+#endif
 	struct ip_ct_tcp tcp;
 	struct nf_ct_udp udp;
+#ifdef CONFIG_NF_CT_PROTO_GRE
 	struct nf_ct_gre gre;
+#endif
 	unsigned int tmpl_padto;
 };
 
-- 
2.23.0.rc1

