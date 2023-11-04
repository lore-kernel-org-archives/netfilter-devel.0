Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4375FC4332F
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Nov 2023 03:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbjKDDk0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 23:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjKDDkZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 23:40:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84478BF;
        Fri,  3 Nov 2023 20:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=4mCxdG9T2wmKjWyKacxf7Q3fDFsqsmniLHS/1fYzUhw=; b=2VJ7ChI6RysLfYXFkxskUFnrQI
        h3HQEUaIQcovrCqDginVglHl66WEtTXngyjtNFIGD17jcpUI7Gwi6gM/q2/Dy6NCD9c8qjKvvruDi
        v8PawS3YXhXo6N9r1oHY4x7rPoJH1uAgc7/lZYyTAVcF9JiCaGYBLQZWzLBEDEPWQg0qtJiFfEKuK
        awVqDSxQUSsfl2/Nwd2LT2k0vPfGQqrlHkfmIddYf4hSfUt/FWjsMPhg2cAMmkkpJWqbrJ+LA92pI
        3jree4dQK7uUi3on9LX0F+nP/4YVO3Za8eYloFjkteAoIOj+JtGFJVrZZ9Cg8uIhbUcp1qujlCHtZ
        m8PiYYMw==;
Received: from [50.53.46.231] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qz7WG-00CZj5-3B;
        Sat, 04 Nov 2023 03:40:21 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH] netfilter: nat: add MODULE_DESCRIPTION
Date:   Fri,  3 Nov 2023 20:40:17 -0700
Message-ID: <20231104034017.14909-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a MODULE_DESCRIPTION() to iptable_nat.c to avoid a build warning:

WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/netfilter/iptable_nat.o

This is only exposed when using "W=n".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
---
 net/ipv4/netfilter/iptable_nat.c |    1 +
 1 file changed, 1 insertion(+)

diff -- a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -169,4 +169,5 @@ static void __exit iptable_nat_exit(void
 module_init(iptable_nat_init);
 module_exit(iptable_nat_exit);
 
+MODULE_DESCRIPTION("Netfilter NAT module");
 MODULE_LICENSE("GPL");
