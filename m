Return-Path: <SRS0=u4e5=WH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3329C0650F
	for <netfilter-devel@archiver.kernel.org>; Sun, 11 Aug 2019 13:16:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDCF6216F4
	for <netfilter-devel@archiver.kernel.org>; Sun, 11 Aug 2019 13:16:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="qaitRhRI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbfHKNQT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 11 Aug 2019 09:16:19 -0400
Received: from kadath.azazel.net ([81.187.231.250]:55494 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfHKNQT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Aug 2019 09:16:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HNb1J9wbH5bMeFa6u2LvOTfXcDb7HGJNKPTOEOKC5TA=; b=qaitRhRIEmIH/ePZTMM1XTGpH1
        h2X3XGid3/ijHbeWBCwP/JRjXjCV9gJiNi0fzuNqHOBgJLXIqjMz6y93zOJRhYw90Zw8YcJVMOTFi
        OLwoD7O3fbe2crjjuSBAN8c42PfN0FMZ+3FQNXB9oUKrANu4wjSt5breLJDw6wiAJP2jgCd1to/Iy
        E6X55oekc0jzJFJtkbE9AgPIVF1pgIOAVhJt5GvKJ5bZgFwvWSdVOgaUmJyxbCEMQ/15aWQMgf9/R
        YSs0SWrWoKFggyTAJPuC8O42helHGnmvTIEYSQsIr0hzFdJgT2HMgLwaZ44OCjQkWDgMZzqK4wQ9l
        oBuwHAqA==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1hwnhp-0002CN-Hl; Sun, 11 Aug 2019 14:16:17 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     =?UTF-8?q?Franta=20Hanzl=C3=ADk?= <franta@hanzlici.cz>
Subject: [PATCH xtables-addons 1/2] xt_pknock, xt_SYSRQ: don't set shash_desc::flags.
Date:   Sun, 11 Aug 2019 14:16:16 +0100
Message-Id: <20190811131617.10365-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190811113826.5e594d8f@franta.hanzlici.cz>
References: <20190811113826.5e594d8f@franta.hanzlici.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

shash_desc::flags was removed from the kernel in 5.1.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/pknock/xt_pknock.c | 1 -
 extensions/xt_SYSRQ.c         | 1 -
 2 files changed, 2 deletions(-)

diff --git a/extensions/pknock/xt_pknock.c b/extensions/pknock/xt_pknock.c
index c76901ac4c1a..8021ea07e1b9 100644
--- a/extensions/pknock/xt_pknock.c
+++ b/extensions/pknock/xt_pknock.c
@@ -1125,7 +1125,6 @@ static int __init xt_pknock_mt_init(void)
 
 	crypto.size = crypto_shash_digestsize(crypto.tfm);
 	crypto.desc.tfm = crypto.tfm;
-	crypto.desc.flags = 0;
 
 	pde = proc_mkdir("xt_pknock", init_net.proc_net);
 	if (pde == NULL) {
diff --git a/extensions/xt_SYSRQ.c b/extensions/xt_SYSRQ.c
index c386c7e2db5d..183692f49489 100644
--- a/extensions/xt_SYSRQ.c
+++ b/extensions/xt_SYSRQ.c
@@ -114,7 +114,6 @@ static unsigned int sysrq_tg(const void *pdata, uint16_t len)
 	}
 
 	desc.tfm   = sysrq_tfm;
-	desc.flags = 0;
 	ret = crypto_shash_init(&desc);
 	if (ret != 0)
 		goto hash_fail;
-- 
2.20.1

