Return-Path: <SRS0=j12K=W5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B0F7C3A59E
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E512622CF7
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="CQv4FX9r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbfIBXc3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Sep 2019 19:32:29 -0400
Received: from kadath.azazel.net ([81.187.231.250]:44082 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfIBXc3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Sep 2019 19:32:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Pm9MZTEpDGxE5vADyK9rgG4UEEBLW9mSX/Spnmv1vTc=; b=CQv4FX9rhXQmF0VMt7sh2BDI9M
        hqtIygS6ttldf2G1pFpYRvyKpHX0VUVY1s/UknZkcd3KMGxWe8FgmjS56acWzjoxWMr6GZBd11QPx
        f/E4ABwoXdMPUO49SMH5kiaKbUMexl/fvhDPvPVg8mPBy6DgC/+KLkCWoMdO1P0lKXdq19ME9swmy
        5PijWAMw1VDIR9E+51hfHi4qU5Zylsl5eyF9J7NKATV+CZ0Y+cM2gu3HyAgAMIBsJfZS+jCQiM/ji
        0CcegCA25rxFQDmorOjFAJXEd6nkUB51Y9yxXqQKkQfB+xzIqrVMgy3mK7Z4eGwqEi0nnaFeG8SGn
        K4U/NXFw==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4vPS-0004la-4k; Tue, 03 Sep 2019 00:06:54 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 22/30] netfilter: wrap inline timeout function in CONFIG_NETFILTER_TIMEOUT check.
Date:   Tue,  3 Sep 2019 00:06:42 +0100
Message-Id: <20190902230650.14621-23-jeremy@azazel.net>
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

nf_ct_timeout_data is only called if CONFIG_NETFILTER_TIMEOUT is
enabled.  Wrap its contents in a CONFIG_NETFILTER_TIMEOUT check like the
other inline functions in nf_conntrack_timeout.h.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/net/netfilter/nf_conntrack_timeout.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/net/netfilter/nf_conntrack_timeout.h b/include/net/netfilter/nf_conntrack_timeout.h
index 00a8fbb2d735..6dd72396f534 100644
--- a/include/net/netfilter/nf_conntrack_timeout.h
+++ b/include/net/netfilter/nf_conntrack_timeout.h
@@ -32,6 +32,7 @@ struct nf_conn_timeout {
 static inline unsigned int *
 nf_ct_timeout_data(const struct nf_conn_timeout *t)
 {
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	struct nf_ct_timeout *timeout;
 
 	timeout = rcu_dereference(t->timeout);
@@ -39,6 +40,9 @@ nf_ct_timeout_data(const struct nf_conn_timeout *t)
 		return NULL;
 
 	return (unsigned int *)timeout->data;
+#else
+	return NULL;
+#endif
 }
 
 static inline
-- 
2.23.0.rc1

