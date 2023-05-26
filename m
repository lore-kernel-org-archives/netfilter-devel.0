Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 607F6C77B7A
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 May 2023 18:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbjEZSdY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 May 2023 14:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236289AbjEZSdV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 May 2023 14:33:21 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E375C12A;
        Fri, 26 May 2023 11:33:19 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id E582E320034E;
        Fri, 26 May 2023 14:33:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 26 May 2023 14:33:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1685125998; x=1685212398; bh=Zp
        LZLV3QsZzobTyFE801nMuW76L2OIyWSnXDegF+FC0=; b=HQQzH7zBos7ePDHTLR
        2mQtrxw/xexlZ0c1sd7ucEYNiAP2s3zrnzuUK1/4cEVWu1idF8S/67n+hEHWdWEi
        PupgL5L1+KrC2ygGKLN5w0uocm/65loGHIajNC19uq6syq7/pp4Zdy6wJMtTYiJA
        sB2s73V11j/JxusIxmitojHVkTXHU2zGAqJmRA8inHZdKGWPaioBwf4evKfj2i15
        GxJwTBOofaG54AlDBkAWPCqNkqnQVLz+XKvzwBS28QwFWWYXlGf1BBjzHc7ii2QU
        T/j2f4b3nnS3dmmyJ4D1Gg2Hktr/8awFgxOuewXkV8Vu9ca9HT53vysCJZVy0Apb
        XWQw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1685125998; x=1685212398; bh=ZpLZLV3QsZzob
        TyFE801nMuW76L2OIyWSnXDegF+FC0=; b=A0XsmL4WcnXUffSNl4gL4p4JimDrP
        TTr8x5vePekDrzFBCsJ8iWh1PXo7cPu/bEn5I2fxCyK4CyzmS437L8b7aE52NIA1
        844T0phlzxmWDyZw/xcBTPhiZ9Kxjcyutd9LoCO/uv/1QvNgnFe1pA6e/ypZT60d
        0xqkIm9DNXM2PWAeAqJkZbHK5/oEEE8+SDk4Zxeu9M96HLTABcze6M0CntijyTEj
        y1w5BB9ukaoU+HZqZ+S8DSiWG9TptkKJEIiw4alMY8HBdLJl5RlIAzoJ5mvUk7yh
        zt3Om0gjMKHHSFknZvdmgpfS2Px410fKUvt0ktkmU6K8+RKYyrqR8QUDQ==
X-ME-Sender: <xms:bvtwZKkNeX1o9Q-d6xMJhXIwQwtrLRG-6qOKkIJ-u_tkoGXNDN1lDQ>
    <xme:bvtwZB3Dkpy64vaIOJ37rlshsUal26BRvaH_g_RpiFJAnWGMJZXeWq3r0UWR3H0YX
    HfOO20ktdnddQ>
X-ME-Received: <xmr:bvtwZIp55YFhbzwZ1T0CB4xtQq0cn44FFTdaa7nONlPS0XGKworTPnhL6lYlig>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeejledguddvgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehge
    dvvedvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:bvtwZOknAnajz5nNT2LF0RCS-R0mXYuoXfywQ-kmbm0I4cReOzjSkw>
    <xmx:bvtwZI0Y1kOSD0iXWfdzdB-zj8LEeDaie190RYeEH1SZl65wV_FZDA>
    <xmx:bvtwZFu-GaUxfr4W91HNws7FI_jCVadHd5lZvmJ_A63NO55HJQhBUA>
    <xmx:bvtwZCov2QmCs1eY4JUK4AOstSrr0sWT__aBA9DwE0mkZCfwSgmJBg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 26 May 2023 14:33:17 -0400 (EDT)
Date:   Fri, 26 May 2023 19:33:16 +0100
From:   Greg KH <greg@kroah.com>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     stable@vger.kernel.org, pablo@netfilter.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 4.14 1/1] netfilter: nf_tables: bogus EBUSY in helper
 removal from transaction
Message-ID: <2023052609-rake-exclusive-27f9@gregkh>
References: <20230519192859.2272157-1-cascardo@canonical.com>
 <20230519192859.2272157-2-cascardo@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230519192859.2272157-2-cascardo@canonical.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 19, 2023 at 04:28:59PM -0300, Thadeu Lima de Souza Cascardo wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> commit 8ffcd32f64633926163cdd07a7d295c500a947d1 upstream.
> 
> Proper use counter updates when activating and deactivating the object,
> otherwise, this hits bogus EBUSY error.
> 
> Fixes: cd5125d8f518 ("netfilter: nf_tables: split set destruction in deactivate and destroy phase")
> Reported-by: Laura Garcia <nevola@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> ---
>  net/netfilter/nft_objref.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
> 

Now queued up, thanks.

greg k-h
