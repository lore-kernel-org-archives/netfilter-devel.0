Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 815EFC04A6A
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 16:10:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbjHBQKk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 12:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbjHBQKj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 12:10:39 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E571BE4
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2023 09:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MWeaXO23/cRPDfD8MyOfdqI5pGjDquqExDX7m/5Svn8=; b=Wm8bfI3+xM703fear4bOselZVZ
        q0wOijNZyG0vB4+3gBgNREHFKr0RvQn6nnPVRGL+N/wMt1xGYEX/QzhukKuJYPC94EcnPr50cbZuz
        VDiXOUNiq/vyKx+brBPDqqUUuJfMAvslfM77acxoj1ERjIcYGoRqgKP85GFgkHRHt6ksiYoItzGMZ
        aGGtiAyvbH/zghwkRYHtKGyTkDhCelscXXUHyJmTijuFGPn9ZSte4J45y2b20uFYcq7KpJoPuys/W
        2GVcv3Fm0imqwYR/3i95oLPWFSgfF9fOPAzK2xEYgT1i2WuFcDUL5zpDK4H/ATa50ppY73be6eE4/
        6GoEk2Lw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qREQm-0004y7-Tv
        for netfilter-devel@vger.kernel.org; Wed, 02 Aug 2023 18:10:36 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 04/15] man: iptables.8: Clarify --goto description
Date:   Wed,  2 Aug 2023 18:09:12 +0200
Message-Id: <20230802160923.17949-5-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230802160923.17949-1-phil@nwl.cc>
References: <20230802160923.17949-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Text speaks about behaviour of RETURN target when used in chains
redirected to using --goto instead of --jump, not the difference between
--jump option and "return".

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

