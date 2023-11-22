Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB4AC61D97
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 12:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343884AbjKVMyw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 07:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343895AbjKVMys (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 07:54:48 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F87AD71
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 04:54:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=eSmks/Rb6Eej+jGCwX8PmHud+0dwuiF8GilSktgB2NA=; b=qbji7rUl+XeHcMrNfKEawnEKZY
        3LfVSQfGXppDBeKoy4kgCfFmChAUxAz7IrIOsAnvfZkYprSoOIq0h7MqSyXrT1FwnnwuNTzn81Ng2
        HzrwkaVYGHuufGJk1n3pYPXKX4o+8fqCqzYCcxcE8lQamJ5QjDM6ofM+nmGPBrdvsd+kd/65ekHCd
        +aFuwSSyx0PnK03Lk0n0MXbJzDAKVyp4lj5uiabieq6m6Z960GB1JYwHxBXjCenBJecbHJWeVuT4h
        Ios//h/5hqWL2FNz/ooDWmg6uI898IA7i7gBNoksO0QrEFiPhixaskn93Ah1xEMsiYmgfkpivHsHi
        omPC7zQA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1r5mkX-0005Sg-KJ
        for netfilter-devel@vger.kernel.org; Wed, 22 Nov 2023 13:54:37 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 04/12] xshared: All variants support -v
Date:   Wed, 22 Nov 2023 14:02:14 +0100
Message-ID: <20231122130222.29453-5-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231122130222.29453-1-phil@nwl.cc>
References: <20231122130222.29453-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Update OPTSTRING_COMMON and remove the flag from *_OPTSTRING defines.

Fixes: 51d9d9e081344 ("ebtables: Support verbose mode")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/iptables/xshared.h b/iptables/xshared.h
index c77556a1987dc..815b9d3e98726 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -75,10 +75,10 @@ struct xtables_globals;
 struct xtables_rule_match;
 struct xtables_target;
 
-#define OPTSTRING_COMMON "-:A:C:D:E:F::I:L::M:N:P:VX::Z::" "c:d:i:j:o:p:s:t:"
-#define IPT_OPTSTRING	OPTSTRING_COMMON "R:S::W::" "46bfg:h::m:nvw::x"
-#define ARPT_OPTSTRING	OPTSTRING_COMMON "R:S::" "h::l:nvx" /* "m:" */
-#define EBT_OPTSTRING	OPTSTRING_COMMON "hv"
+#define OPTSTRING_COMMON "-:A:C:D:E:F::I:L::M:N:P:VX::Z::" "c:d:i:j:o:p:s:t:v"
+#define IPT_OPTSTRING	OPTSTRING_COMMON "R:S::W::" "46bfg:h::m:nw::x"
+#define ARPT_OPTSTRING	OPTSTRING_COMMON "R:S::" "h::l:nx" /* "m:" */
+#define EBT_OPTSTRING	OPTSTRING_COMMON "h"
 
 /* define invflags which won't collide with IPT ones.
  * arptables-nft does NOT use the legacy ARPT_INV_* defines.
-- 
2.41.0

