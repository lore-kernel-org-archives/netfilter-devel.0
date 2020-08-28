Return-Path: <SRS0=v1Ge=CG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 604ADC433E6
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Aug 2020 16:58:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA6542074A
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Aug 2020 16:58:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=opendium.com header.i=@opendium.com header.b="jr4PpUci"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgH1Q6a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Aug 2020 12:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbgH1Q63 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Aug 2020 12:58:29 -0400
X-Greylist: delayed 2247 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 28 Aug 2020 09:58:28 PDT
Received: from opendium2.opendium.net (opendium2.opendium.net [IPv6:2a01:4f8:10b:3d07::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E2AC061264
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Aug 2020 09:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=opendium.com; s=open; h=Content-Type:MIME-Version:Date:Message-ID:To:
        Subject:From:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XlOvnqiNVPx7uykD+x3MYYtKADTDOKh6kQWIb5+2nJw=; b=jr4PpUciLfkrhiw1tS5wtne8E5
        36ZRtPEEvPrP6ocG/i3lexy78XQztFMDo4sfhSv3UJ3JUzIEWg26ivZ+3kD9vjxgoCQ/0Y8sbrpdT
        eW4Je0o1uUz0Ex8zZDKEldzXxj4rE+drelBHI+3L7rhoGJ9VGniD05ZR16bqwkos2nP0=;
Received: from [2a00:1940:103:8:c032:ccff:fe47:456e] (helo=rivendell.nexusuk.org)
        by opendium2.opendium.net with esmtpsa (TLSv1.3:TLS_AES_128_GCM_SHA256:128)
        (Exim 4.92.3)
        (envelope-from <steve@opendium.com>)
        id 1kBh7b-0006Jl-QE
        for netfilter-devel@vger.kernel.org; Fri, 28 Aug 2020 17:20:59 +0100
From:   Steve Hill <steve@opendium.com>
Subject: [PATCH] netfilter: No increment ctx->level for NFT_GOTO
Organization: Opendium
To:     netfilter-devel@vger.kernel.org
Message-ID: <231a0c69-60b1-0b18-0ed6-fcf7a9058ff0@opendium.com>
Date:   Fri, 28 Aug 2020 17:20:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------AA7A2FB1FFA83754A30DE8F5"
Content-Language: en-GB
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a multi-part message in MIME format.
--------------AA7A2FB1FFA83754A30DE8F5
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

nft_immediate_validate() and nft_lookup_validate_setelem() treat 
NFT_GOTO and NFT_JUMP identically, incrementing pctx->level for both. 
This results in a -EMLINK ("Too many links") being unexpectedly returned 
for rulesets that use lots of gotos.

This fixes this problem by not incrementing pctx->level when following 
gotos.

Fixes: https://bugzilla.netfilter.org/show_bug.cgi?id=1459
Signed-off-by: Steve Hill <steve@opendium.com>
---
diff -urN 
linux-4.18.0-193.14.2.el8.x86_64.vanilla/net/netfilter/nft_immediate.c 
linux-4.18.0-193.14.2.el8.x86_64.opendium/net/netfilter/nft_immediate.c
--- 
linux-4.18.0-193.14.2.el8.x86_64.vanilla/net/netfilter/nft_immediate.c 
2020-07-19 15:03:44.000000000 +0100
+++ 
linux-4.18.0-193.14.2.el8.x86_64.opendium/net/netfilter/nft_immediate.c 
2020-08-26 15:39:47.004754668 +0100
@@ -113,13 +113,19 @@

      switch (data->verdict.code) {
      case NFT_JUMP:
-    case NFT_GOTO:
          pctx->level++;
          err = nft_chain_validate(ctx, data->verdict.chain);
          if (err < 0)
              return err;
          pctx->level--;
          break;
+    case NFT_GOTO:
+        err = nft_chain_validate(ctx, data->verdict.chain);
+        if (err < 0)
+            return err;
+        break;
      default:
          break;
      }
diff -urN 
linux-4.18.0-193.14.2.el8.x86_64.vanilla/net/netfilter/nft_lookup.c 
linux-4.18.0-193.14.2.el8.x86_64.opendium/net/netfilter/nft_lookup.c
--- linux-4.18.0-193.14.2.el8.x86_64.vanilla/net/netfilter/nft_lookup.c 
2020-07-19 15:03:44.000000000 +0100
+++ linux-4.18.0-193.14.2.el8.x86_64.opendium/net/netfilter/nft_lookup.c 
2020-08-26 15:42:35.885223417 +0100
@@ -176,13 +176,19 @@
      data = nft_set_ext_data(ext);
      switch (data->verdict.code) {
      case NFT_JUMP:
-    case NFT_GOTO:
          pctx->level++;
          err = nft_chain_validate(ctx, data->verdict.chain);
          if (err < 0)
              return err;
          pctx->level--;
          break;
+    case NFT_GOTO:
+        err = nft_chain_validate(ctx, data->verdict.chain);
+        if (err < 0)
+            return err;
+        break;
      default:
          break;
      }

--------------AA7A2FB1FFA83754A30DE8F5
Content-Type: text/x-vcard; charset=utf-8;
 name="steve.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="steve.vcf"

begin:vcard
fn:Steve Hill
n:Hill;Steve
org:Opendium Limited
adr:1 Brue Close;;Highfield House;Bruton;Somerset;BA10 0HY;England
email;internet:steve@opendium.com
title:Technical Director
x-mozilla-html:FALSE
url:https://www.opendium.com
version:2.1
end:vcard


--------------AA7A2FB1FFA83754A30DE8F5--
