Return-Path: <SRS0=UAOK=W4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B438C3A5A4
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 21:02:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 196B32190F
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 21:02:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="pGBUYxPA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbfIAVCI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Sep 2019 17:02:08 -0400
Received: from kadath.azazel.net ([81.187.231.250]:53660 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729085AbfIAVCH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Sep 2019 17:02:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FR0MpU4KHXBrP1ahQl7aUyUN4zyTKtmhmQWrFZL+4IU=; b=pGBUYxPA6DF747FzsYvHnqI7lG
        ERnx7waQU3/ouyWjnwIHlC2lKsuIg9/RXnPjkcfBkesdBiqc06YISuifyzAVkdHsnPDZ8XuTCqQKB
        kCDQwGb8dhMsDUqiK1KuKuWukbItP37ln95BxKZLx/Fqvrv/Hv+AKS+DvTbBJ/Dgm1XhYtBO8Vwi5
        il8vyGDdk88NQyyMu4KrXNXaCZrj4CdnDxOEf36KiWVMWOSIekd3CeecP/48A/KaqdRQbQIus8MRt
        QYK7L55iwVm8S4z0vRoKk/sqYDfKtY3M6dWmnao+ILMLA2im8GiWH/COo59vD3CLxc4fLegbT/mrI
        VC249G6w==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4Wor-0002Uf-1X; Sun, 01 Sep 2019 21:51:29 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 19/29] netfilter: wrap union nf_conntrack_proto members in CONFIG_NF_CT_PROTO_* check.
Date:   Sun,  1 Sep 2019 21:51:15 +0100
Message-Id: <20190901205126.6935-20-jeremy@azazel.net>
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

