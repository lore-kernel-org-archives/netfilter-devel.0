Return-Path: <SRS0=j12K=W5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4462C3A5A5
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81DCB216C8
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:06:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="u9YL3YTg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbfIBXG6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Sep 2019 19:06:58 -0400
Received: from kadath.azazel.net ([81.187.231.250]:43574 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbfIBXGy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Sep 2019 19:06:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=y2uX4Nq+fO08QfKQpLlmhPngoasV9LseO0YHKuuTg70=; b=u9YL3YTgHKWgIDcgnZHAt1Fqv0
        EaulMYGFKNAns7KLKojaw0uJIn7t+s+9FA78wLuj3++vXWZpPryXW6QYUo7aNfoT63ZTye0HoT6Ex
        h5XRuwLjHaZUj8hElKW8q63NgW1qzwPRl5wb7euiPmBsyc95pcmM9smtmdAjd3zRYzGpBz7tCY6A0
        IoC03Z0VLmvaxENIhrOiVF5nsq0FWHVV5oSPZTmvjp0aWF5lGu9U2l/62LQ6XXHkVLFNzv4vHDhq4
        QYRfGY/N/XoOyqKJGA01UT5RnnhKerYbo8e2GBQCS+1wwBsFuGCZpCYQPGUFSQuH4aLDLrOPkr8VN
        uGhKs92A==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4vPP-0004la-EO; Tue, 03 Sep 2019 00:06:51 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 06/30] netfilter: fix Kconfig formatting error.
Date:   Tue,  3 Sep 2019 00:06:26 +0100
Message-Id: <20190902230650.14621-7-jeremy@azazel.net>
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

Indent the type of CONFIG_NETFILTER_NETLINK_ACCT correctly.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 net/netfilter/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 6244bf3de4af..34ec7afec116 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -20,7 +20,7 @@ config NETFILTER_FAMILY_ARP
 	bool
 
 config NETFILTER_NETLINK_ACCT
-tristate "Netfilter NFACCT over NFNETLINK interface"
+	tristate "Netfilter NFACCT over NFNETLINK interface"
 	depends on NETFILTER_ADVANCED
 	select NETFILTER_NETLINK
 	help
-- 
2.23.0.rc1

