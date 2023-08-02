Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB2ADC0015E
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 02:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbjHBCFY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Aug 2023 22:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbjHBCFU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Aug 2023 22:05:20 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C9C212D
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Aug 2023 19:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=E8i5KO/mnc/447x/fuy39LL95sX3Isa8AgthkQ0CpHg=; b=WZwYZTbmrJcx6OosOph7lNPCF/
        5fOFKzmfzsil82d+QS5OPPKD8Y2d7zmb+jG564XvaCqM84kFa73NaPLk+cFxg1JS7f+3n2PF6otMd
        XQ/+CUvxUIdU2z/X2guPZJJ1yfPKtqXRRhY93NiGG6h52N9dwyIDUfIfN3z0PW5GYKgwxv1Zwl2uf
        0D3oFtawgPTuBUdlT+W2sXDS3mNHFe9xwotkNeL6iKXb1vnJkNJ/0C0ytrZhVGfrtZmBfwukViOfl
        Tnd81a5gHsyN+sJWibvHh/0HDucdU3swXb+KgeYqGVFbitJoYOz35kpep9Lz3AyOpBI7OPk41SRWV
        L7xAWraA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qR1Ek-0002tI-5X; Wed, 02 Aug 2023 04:05:18 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     debian@helgefjell.de
Subject: [iptables PATCH 04/16] man: iptables.8: Clarify --goto description
Date:   Wed,  2 Aug 2023 04:03:48 +0200
Message-Id: <20230802020400.28220-5-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230802020400.28220-1-phil@nwl.cc>
References: <20230802020400.28220-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Text speaks about behaviour of RETURN target when used in chains
redirected to using --goto instead of --jump, not the difference between
--jump option and "return".

Reported-by: debian@helgefjell.de
Fixes: 17fc163babc34 ("add 'goto' support (Henrik Nordstrom <hno@marasystems.com>)")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables.8.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index 85af18008daab..c83275b294872 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -316,7 +316,7 @@ incremented.
 .TP
 \fB\-g\fP, \fB\-\-goto\fP \fIchain\fP
 This specifies that the processing should continue in a user
-specified chain. Unlike the \-\-jump option return will not continue
+specified chain. Unlike with the \-\-jump option, \fBRETURN\fP will not continue
 processing in this chain but instead in the chain that called us via
 \-\-jump.
 .TP
-- 
2.40.0

