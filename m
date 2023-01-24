Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10CB7C25B4E
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Jan 2023 18:17:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbjAXSRT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Jan 2023 13:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjAXSRT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Jan 2023 13:17:19 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB7E4B18E;
        Tue, 24 Jan 2023 10:17:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=sGkPrI9T/JW6jnSg9wDuqsLtaD2yspPjDXYdbyVMsxI=; b=I9HSSIsvH0lz8CbRWWYXLvc/kK
        Y9c21GvyfnZX+L3AoyuNSUaXneCHLKb2LK72ouvB9RQ+OgyyqPnlKefdVvXWVijwGJzYDf6yaU3aW
        Bkt6JYHyQZPtWM/D+aSTusl8/nq+XPSUmuc98fPzCJ0DgTX16YkO2Wsu8hktXNp0NLVfY4zV1HDRa
        aQhyaX+5fU1dSl1mvftGLZCCT7skwfro5k/wxOGgDtXWuze3w0mnfb9RFXoKhHOYtNTe/dAtaAjxi
        NcdTn+3qQ6svUjemrIOHbdD9K5VCt0eI4XZS7hR5smQS9JeDiwD76Za3vDBTrxxvJkaADJAS+Fpp+
        AQDormgg==;
Received: from [2601:1c2:d80:3110::9307] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pKNr1-004vgD-81; Tue, 24 Jan 2023 18:17:07 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH net-next] net: Kconfig: fix spellos
Date:   Tue, 24 Jan 2023 10:17:06 -0800
Message-Id: <20230124181706.16825-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fix spelling in net/ Kconfig files.
(reported by codespell)

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
---
 net/netfilter/ipset/Kconfig |    2 +-
 net/sched/Kconfig           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -- a/net/netfilter/ipset/Kconfig b/net/netfilter/ipset/Kconfig
--- a/net/netfilter/ipset/Kconfig
+++ b/net/netfilter/ipset/Kconfig
@@ -30,7 +30,7 @@ config IP_SET_BITMAP_IP
 	depends on IP_SET
 	help
 	  This option adds the bitmap:ip set type support, by which one
-	  can store IPv4 addresses (or network addresse) from a range.
+	  can store IPv4 addresses (or network addresses) from a range.
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
diff -- a/net/sched/Kconfig b/net/sched/Kconfig
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -337,7 +337,7 @@ config NET_SCH_FQ
 	  Say Y here if you want to use the FQ packet scheduling algorithm.
 
 	  FQ does flow separation, and is able to respect pacing requirements
-	  set by TCP stack into sk->sk_pacing_rate (for localy generated
+	  set by TCP stack into sk->sk_pacing_rate (for locally generated
 	  traffic)
 
 	  To compile this driver as a module, choose M here: the module
