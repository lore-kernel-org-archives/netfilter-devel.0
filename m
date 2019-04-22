Return-Path: <SRS0=3cJm=SY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3DBFC10F11
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 20:10:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 886AE2064A
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 20:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555963858;
	bh=2pVixEJfR9Zf2g8RzqnYMd8v0FVqVr8xHKoHWb8pyhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=J1Hkv94evwM3UQJ7HGFhswN0JTOSpCPqTaTkWdESzNgu9DcJ2IcygvuU9v3Ez1CBI
	 Y9OvlsYhLFYjL4eeNGfng+xVEwrPk0L1GrmoRKUXLLx1VjuQu+OnGXVB+QFbshWiOY
	 +ds7NI643ehZEEtrHy4VDrNwU85KR+Zu661fTy1U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728841AbfDVTm2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 15:42:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728824AbfDVTm2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 15:42:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CB9E2175B;
        Mon, 22 Apr 2019 19:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555962147;
        bh=2pVixEJfR9Zf2g8RzqnYMd8v0FVqVr8xHKoHWb8pyhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vk6RxQLMVobhpS8FGTJAq657Ody6TrHRRYDLn54iIzPTZxrI+Vre44hp+Ba1U+J8H
         u+nYpNsk5P3zIgKqas0e8tiRBQ6PA40eDsBQGsaPZ9brhPl1hx2K9y95uOC0Sg49qy
         Cvo3PbM1oigZkrVJJ3aKENWEZ0qyHll/zXWCwJaE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?q?M=C3=A1t=C3=A9=20Eckl?= <ecklm94@gmail.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 18/98] netfilter: fix NETFILTER_XT_TARGET_TEE dependencies
Date:   Mon, 22 Apr 2019 15:40:45 -0400
Message-Id: <20190422194205.10404-18-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190422194205.10404-1-sashal@kernel.org>
References: <20190422194205.10404-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit d1fa381033eb718df5c602f64b6e88676138dfc6 ]

With NETFILTER_XT_TARGET_TEE=y and IP6_NF_IPTABLES=m, we get a link
error when referencing the NF_DUP_IPV6 module:

net/netfilter/xt_TEE.o: In function `tee_tg6':
xt_TEE.c:(.text+0x14): undefined reference to `nf_dup_ipv6'

The problem here is the 'select NF_DUP_IPV6 if IP6_NF_IPTABLES'
that forces NF_DUP_IPV6 to be =m as well rather than setting it
to =y as was intended here. Adding a soft dependency on
IP6_NF_IPTABLES avoids that broken configuration.

Fixes: 5d400a4933e8 ("netfilter: Kconfig: Change select IPv6 dependencies")
Cc: Máté Eckl <ecklm94@gmail.com>
Cc: Taehee Yoo <ap420073@gmail.com>
Link: https://patchwork.ozlabs.org/patch/999498/
Link: https://lore.kernel.org/patchwork/patch/960062/
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 net/netfilter/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index beb3a69ce1d4..0f0e5806bf77 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -995,6 +995,7 @@ config NETFILTER_XT_TARGET_TEE
 	depends on NETFILTER_ADVANCED
 	depends on IPV6 || IPV6=n
 	depends on !NF_CONNTRACK || NF_CONNTRACK
+	depends on IP6_NF_IPTABLES || !IP6_NF_IPTABLES
 	select NF_DUP_IPV4
 	select NF_DUP_IPV6 if IP6_NF_IPTABLES
 	---help---
-- 
2.19.1

