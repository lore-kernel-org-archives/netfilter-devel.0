Return-Path: <SRS0=suf1=VM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F24E8C7618F
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jul 2019 11:23:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4CEA2080A
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jul 2019 11:23:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lAntxpbe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729799AbfGOLXn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jul 2019 07:23:43 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45695 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729814AbfGOLXn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jul 2019 07:23:43 -0400
Received: by mail-wr1-f68.google.com with SMTP id f9so16620794wre.12
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jul 2019 04:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=kc0S3mFcbtM9X2cItKfZZV6mfNwHU1lebr4GxLX2rI4=;
        b=lAntxpbeksTcYXsbX1bYAGQ9M6xlyDcCw5j7/Ap/uDxdimdwrlREGNF91WgJH9NtOD
         SplpiBFt79kYNcUIxZvQ8SYJAkD8pIanGJ5LkWfFP57gfOSQikK1vZzAALFayzvf0ks1
         cMm3LSENy6oi3ckfgpA2BLfh2GZuaqkyHj2JA1zcvHGsY4BQY6uVaGAmRDEqsCVcFcrf
         Dc3bgv4W/96lxQGqD+X/zEZn9XFzUCtQWXw5F74doc+orRm+MZIQtAaihcv11PWyL09m
         NcPc/IihrqrNq5+qFl1FJG+COHQxQ3w6w9JFFARnGuJaqorR+5tIhoihXXcboLw8MuVw
         Ir3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=kc0S3mFcbtM9X2cItKfZZV6mfNwHU1lebr4GxLX2rI4=;
        b=h5zZDNGRc074ckod1WExorQaBCVgiYZvDM7dE2N+x4dgo0P2RNoosx+b1qLoT+LsJa
         E6rzsUL2rk19V5j8CTb06L8dANZscDc74VouwvTANMaRiX4ZnfxW2r7wltT21cVoUWoi
         xMAJwMuKD4Di3lGOMBsuZDbIcDdfDKuJo2b7/OHPj+uKsCU3RUk5FRTVNrZBJsQEWhuu
         SJ1QJhPKA9GZqf643bXBVys2FDA1ZTr1AG1Jr+OmO1T1wLbv4w3jWqEZJMFDgW7VUDZ/
         3G/dx1/6x5HTtZz0eUSP1RuTC0RXL8LQNM/2DrzO/+DEYxF/aDnXuIy6z4OWnofsi6uQ
         10Yg==
X-Gm-Message-State: APjAAAUAM+YGQ+s9L+NaqmeQPT7Zkix0Bu4JVNKHCNwzLKTx1Bo1Sjh3
        +t7w7HLGOr2W1n8RkIzuhnULo0Eq
X-Google-Smtp-Source: APXvYqwsB9EnopvvFfV5XQ0Pfp1PoPmoOLnJubTQXEQAQf/NJ6PH7LGLytM5SfgyY7qOJrrvcf+zcA==
X-Received: by 2002:a5d:5348:: with SMTP id t8mr27854464wrv.159.1563189820910;
        Mon, 15 Jul 2019 04:23:40 -0700 (PDT)
Received: from nevthink ([185.79.20.147])
        by smtp.gmail.com with ESMTPSA id l25sm12691115wme.13.2019.07.15.04.23.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Jul 2019 04:23:40 -0700 (PDT)
Date:   Mon, 15 Jul 2019 13:23:37 +0200
From:   Laura Garcia Liebana <nevola@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org
Subject: [PATCH nf] netfilter: fix symhash with modulus one
Message-ID: <20190715112337.gobsm3ljlmgtarnf@nevthink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The rule below doesn't work as the kernel raises -ERANGE.

nft add rule netdev nftlb lb01 ip daddr set \
	symhash mod 1 map { 0 : 192.168.0.10 } fwd to "eth0"

This patch allows to use the symhash modulus with one
element, in the same way that the other types of hashes and
algorithms that uses the modulus parameter.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 net/netfilter/nft_hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index fe93e731dc7f..b836d550b919 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -129,7 +129,7 @@ static int nft_symhash_init(const struct nft_ctx *ctx,
 	priv->dreg = nft_parse_register(tb[NFTA_HASH_DREG]);
 
 	priv->modulus = ntohl(nla_get_be32(tb[NFTA_HASH_MODULUS]));
-	if (priv->modulus <= 1)
+	if (priv->modulus < 1)
 		return -ERANGE;
 
 	if (priv->offset + priv->modulus - 1 < priv->offset)
-- 
2.11.0

