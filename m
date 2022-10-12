Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5566AC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Oct 2022 15:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiJLPTQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Oct 2022 11:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiJLPSv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Oct 2022 11:18:51 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C6FDFB7B
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Oct 2022 08:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZPEs5ya1sJNh76paaNBB3cIubNWwziK/VIlPLZ62VPw=; b=Cx2N8/Vp9DkOju6ib6TOzvcCAM
        oEThXGknaBR9vghLgkWoQm01vsbhm+GYN9ez2AHSKk+N8N19PskoZwA0g9/FiNigotU1ERF2JjPPD
        u3tmSWEUSXoOG43pUTDVEogFJiBwC88deHakLfxQJI2CMqsmJQE5TYAuM6/YjcZ9k2T/Vs6oEXW+P
        GtlqyxxXTJKJvcWh1P8g2S8zr6g52PMEUJyJJTB3XagSXD1+GPsNj0KmGz6Fd2bh5C6+jtm/HSuxu
        rZXIATXMbuNt9ikyy6JQ2PRY/RC2oq5GEwC7MLlQTtLBTtCx1Vx69EmLAO4iYQ2WwdY1wpkkhPX1Q
        OjdXtnAw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oidVF-0002pC-WB; Wed, 12 Oct 2022 17:18:38 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH v2 08/12] tests: libxt_recent.t: Add missing default values
Date:   Wed, 12 Oct 2022 17:17:58 +0200
Message-Id: <20221012151802.11339-9-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221012151802.11339-1-phil@nwl.cc>
References: <20221012151802.11339-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The extensions always prints --name, --mask and (default) --rsource
options.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_recent.t | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_recent.t b/extensions/libxt_recent.t
index 9a83918ea5835..cf23aabc6e63b 100644
--- a/extensions/libxt_recent.t
+++ b/extensions/libxt_recent.t
@@ -1,8 +1,8 @@
 :INPUT,FORWARD,OUTPUT
--m recent --set;=;OK
+-m recent --set;-m recent --set --name DEFAULT --mask 255.255.255.255 --rsource;OK
 -m recent --rcheck --hitcount 8 --name foo --mask 255.255.255.255 --rsource;=;OK
 -m recent --rcheck --hitcount 12 --name foo --mask 255.255.255.255 --rsource;=;OK
--m recent --update --rttl;=;OK
+-m recent --update --rttl;-m recent --update --rttl --name DEFAULT --mask 255.255.255.255 --rsource;OK
 -m recent --set --rttl;;FAIL
 -m recent --rcheck --hitcount 999 --name foo --mask 255.255.255.255 --rsource;;FAIL
 # nonsensical, but all should load successfully:
-- 
2.34.1

