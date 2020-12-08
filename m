Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B89DEC4361B
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Dec 2020 12:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61BE422C7D
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Dec 2020 12:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729245AbgLHMHR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Dec 2020 07:07:17 -0500
Received: from alva.zappa.cx ([213.136.63.253]:53190 "EHLO alva.zappa.cx"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728281AbgLHMHQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 07:07:16 -0500
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Dec 2020 07:07:16 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=zappa.cx;
         s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:Subject:From:To:Sender:Reply-To:Cc:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bGUv4dtqWHvv07no+gLXf+dIuZnqTGA7mLvx0BUt4bU=; b=bize6a3HAPFb08HD69DdiaGBtc
        IzkU1FNBeXvXlmVkoOvpgpe07L57zZ6SLQJavH18uwyG+DBvWHKdCPSLGEEssM3FK0YrjAWrz7ty9
        1OFgxUKwuHeoX6Q1/uMKupLADIp98cnFT0VL3oGGHFZmzeZOTCc/CHSlyyTEIcS8oZEs=;
Received: from [195.178.160.156] (helo=matrix.zappa.cx)
        by alva.zappa.cx with esmtp (Exim 4.92)
        (envelope-from <sunkan@zappa.cx>)
        id 1kmbae-0000QX-Es
        for netfilter-devel@vger.kernel.org; Tue, 08 Dec 2020 12:55:32 +0100
Received: from [172.17.18.166] (h-63-242.A137.corp.bahnhof.se [213.136.63.242])
        (authenticated bits=0)
        by matrix.zappa.cx (8.15.2/8.15.2/Debian-14~deb10u1) with ESMTPSA id 0B8BtU4A020734
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
        for <netfilter-devel@vger.kernel.org>; Tue, 8 Dec 2020 12:55:32 +0100
To:     netfilter-devel@vger.kernel.org
From:   Andreas Sundstrom <sunkan@zappa.cx>
Subject: [PATCH] Remove IP_NF_IPTABLES dependency for NET_ACT_CONNMARK
Message-ID: <c9657e87-731c-3219-62eb-0cc15b0ff4cd@zappa.cx>
Date:   Tue, 8 Dec 2020 12:55:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: sv-SE
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.11 (matrix.zappa.cx [192.168.20.100]); Tue, 08 Dec 2020 12:55:32 +0100 (CET)
X-Scanned-By: MIMEDefang 2.84 on 192.168.20.100
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

IP_NF_IPTABLES is a superfluous dependency


To be able to select NET_ACT_CONNMARK when iptables has not been
enabled this dependency needs to be removed.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=210539
Signed-off-by: Andreas Sundstrom <sunkan@zappa.cx>
---
  net/sched/Kconfig | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index a3b37d88800e..4bb5c04b72d3 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -912,7 +912,7 @@ config NET_ACT_BPF

  config NET_ACT_CONNMARK
         tristate "Netfilter Connection Mark Retriever"
-       depends on NET_CLS_ACT && NETFILTER && IP_NF_IPTABLES
+       depends on NET_CLS_ACT && NETFILTER
         depends on NF_CONNTRACK && NF_CONNTRACK_MARK
         help
           Say Y here to allow retrieving of conn mark
-- 
2.20.1

