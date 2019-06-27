Return-Path: <SRS0=TR/Z=U2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14D74C4321A
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 21:23:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE62920828
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 21:23:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e8WcsRJn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfF0VXN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jun 2019 17:23:13 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51802 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfF0VXN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jun 2019 17:23:13 -0400
Received: by mail-wm1-f67.google.com with SMTP id 207so7068386wma.1
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2019 14:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=v+rPAmWKbAphv5k04PTXLiaxiT/3EGoLBiOMvCJtyww=;
        b=e8WcsRJnj0Al65f+emB5w8zSygDZyOhWhGdQNFfqqiRaG9TcwBHYNvsIEJWc/k+krk
         aqoVTOP9axU0l5zhtbaCCfvt/hKbEqD/fSfgnzkja2rBYbR5i5N6CGQ9+cTnNhoNgDsD
         7uS1/kaVObYgli5e9v/smv+RcYe7x32Df3ttoQtCu2rTMj4Lpcp0mQoIm85re3NZUAhQ
         r0OS5zQPsc6kzN/VqsY8YFx5fZIr4xCqSwoHLIVOu67rlb5uIO7496yO1LBJ+AfxacF6
         gmetv5kvcsMy/zJJjx2Kxr4ISKGxUfOQlcNqF6oqER356fUUI/K6yu7UGQ9Orq9NFuyQ
         3sDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=v+rPAmWKbAphv5k04PTXLiaxiT/3EGoLBiOMvCJtyww=;
        b=GoetprHsZqF5A9N7Sw16HdajuuyjLDJWxQujYZ/wr9az/dmXR6VlhMuiAYp/QS2dyp
         m0hKomy4dyozcWaGwz9fbHdUg33pvTx2ZIPB0GRBSvlXWs4hwWkOUMp/ROPaR8yE3T0X
         lmnTwSpsLPpzHA5wRtk965a1rTinQS7K23BIIPMh469KKrKzydbwFCle+nfjXgZmLRvK
         cRj9tLnX41v2BrUBXvp8tyoXo9nHOEZrg8F7CQpPBZlaEZfUQhv++1RFiatoipbPZbvH
         Ucl3r9WwKrTKnBpVabeXwzAQk2pumcV1/efASl/GG/9z5emZQ6XgMlsDXMRtu9XUwRL1
         5lPw==
X-Gm-Message-State: APjAAAU7cDk6R0D8Si2K5tmp84NsAZkvPBS/Hm+a1VlET3U2mMmUVQ1t
        4J/Ju2rX7hY3Rm/E3iRoZwlN50SM
X-Google-Smtp-Source: APXvYqyl/ZItaLpAGCNVzercSSHJ/7f2LJ6cNdwX99cBhjetPZW8pmlq2w+DzMpCGYdgmIN123Cpmw==
X-Received: by 2002:a1c:7414:: with SMTP id p20mr4316858wmc.145.1561670591009;
        Thu, 27 Jun 2019 14:23:11 -0700 (PDT)
Received: from jong.localdomain ([77.127.68.150])
        by smtp.gmail.com with ESMTPSA id m9sm208664wrn.92.2019.06.27.14.23.10
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 14:23:10 -0700 (PDT)
Date:   Fri, 28 Jun 2019 00:23:08 +0300
From:   Yonatan Goldschmidt <yon.goldschmidt@gmail.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] netfilter: nat: Update obsolete comment on get_unique_tuple()
Message-ID: <20190627212307.GB4897@jong.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Commit c7232c9979cba ("netfilter: add protocol independent NAT core")
added nf_nat_core.c based on ipv4/netfilter/nf_nat_core.c,
with this comment copied.

Referred function doesn't exist anymore, and anyway since day one
of this file it should have referred the generic __nf_conntrack_confirm(),
added in 9fb9cbb1082d6.

Signed-off-by: Yonatan Goldschmidt <yon.goldschmidt@gmail.com>
---
 net/netfilter/nf_nat_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 9ab410455992..3f6023ed4966 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -519,7 +519,7 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
  * and NF_INET_LOCAL_OUT, we change the destination to map into the
  * range. It might not be possible to get a unique tuple, but we try.
  * At worst (or if we race), we will end up with a final duplicate in
- * __ip_conntrack_confirm and drop the packet. */
+ * __nf_conntrack_confirm and drop the packet. */
 static void
 get_unique_tuple(struct nf_conntrack_tuple *tuple,
                 const struct nf_conntrack_tuple *orig_tuple,
---

