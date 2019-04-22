Return-Path: <SRS0=3cJm=SY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46B11C282CE
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 20:04:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BC1020685
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 20:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555963455;
	bh=qynrjD5BEuyxbHQS+eq3A8+Wu/GNztzTGPDWJnJyiPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Pve+ccFNJC2K1yHu5slLjZ2hliZPnWigiwGrYBp7gJogd80X9NPfpMMFl6F+BNHAP
	 0sdfWeYWQFALur2wiMH9sBxQK0iJkyDiTeg+q/gE2n2gB5lVNqUK8D6FIrK8nB+1Cn
	 U7Ik21mjWu+dTbYHHdgM49yV6aYoUuk8/IFfgWhE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732166AbfDVUEI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 16:04:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729818AbfDVTpl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 15:45:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32CB7218EA;
        Mon, 22 Apr 2019 19:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555962340;
        bh=qynrjD5BEuyxbHQS+eq3A8+Wu/GNztzTGPDWJnJyiPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LpvvPSIDA1Yr+EEwaBkTKu7AtJII39zeQ7Emr+mxBHpKt6uBR0gfEN8vEdjNz4nCn
         V1uFeICmwaB/UuI2kAkVIjUisqx/B+bdqwxPIrZRvjbZ8vePG74Sah+JWXQkcf0Jf5
         oyzujGRGX9IHklWu8QpD7Xt2Nk/6mv9fBwZ7NSD0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?q?M=C3=A1t=C3=A9=20Eckl?= <ecklm94@gmail.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 12/68] netfilter: fix NETFILTER_XT_TARGET_TEE dependencies
Date:   Mon, 22 Apr 2019 15:44:20 -0400
Message-Id: <20190422194516.11634-12-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190422194516.11634-1-sashal@kernel.org>
References: <20190422194516.11634-1-sashal@kernel.org>
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
index f61c306de1d0..e0fb56d67d42 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -1003,6 +1003,7 @@ config NETFILTER_XT_TARGET_TEE
 	depends on NETFILTER_ADVANCED
 	depends on IPV6 || IPV6=n
 	depends on !NF_CONNTRACK || NF_CONNTRACK
+	depends on IP6_NF_IPTABLES || !IP6_NF_IPTABLES
 	select NF_DUP_IPV4
 	select NF_DUP_IPV6 if IP6_NF_IPTABLES
 	---help---
-- 
2.19.1

