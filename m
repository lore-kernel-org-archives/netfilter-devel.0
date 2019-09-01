Return-Path: <SRS0=UAOK=W4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03033C3A5A8
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 21:02:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBC6B2190F
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 21:02:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="OnDYYKYo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbfIAVCJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Sep 2019 17:02:09 -0400
Received: from kadath.azazel.net ([81.187.231.250]:53672 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729106AbfIAVCJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Sep 2019 17:02:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Pm9MZTEpDGxE5vADyK9rgG4UEEBLW9mSX/Spnmv1vTc=; b=OnDYYKYoNkKFR0O2fM1g3aIKvF
        +ACODsGc68tz6GnYeFFcK8iYDdLayk03oy9olIQ6Cp0TQ2o2yAPlJOevWZF3cP6/nCVIa+yqSfwsT
        ZEKbKg4Wnted++jpALgbNa2cQGmOFYXQc5J+Y74wgATYSPDPeK0Z+VmKkbYtCrhWvGSrwfx92y21C
        uj6mqAIS4YuHH6kyGjOrezJlgpgaUnTfXa+IrDkWNaFeh14sspzd7u1yOZ2o2FQ4qv257swZmWYbu
        gz4fM3FpOGr1rjxaY4VLbvaT3bF5tS0KOUz1WB6P+R78dA5lbCum1tXvMKt7grKHDzX7ZyEWhgOoF
        HcU80wSQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4Wor-0002Uf-De; Sun, 01 Sep 2019 21:51:29 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 21/29] netfilter: wrap inline timeout function in CONFIG_NETFILTER_TIMEOUT check.
Date:   Sun,  1 Sep 2019 21:51:17 +0100
Message-Id: <20190901205126.6935-22-jeremy@azazel.net>
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

