Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 059F6C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Sep 2021 18:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D223961209
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Sep 2021 18:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242335AbhI1Sxr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Sep 2021 14:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242305AbhI1Sxr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Sep 2021 14:53:47 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8585FC06161C
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Sep 2021 11:52:07 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id x8so12003858plv.8
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Sep 2021 11:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=WJuRa4wasjbhsnCdqxL3Xo92pH8SS9eDtOb8VwpUFO4=;
        b=GCwrooQ+6s6ii9hj7FGNZJqZqnaIwE27CeXrfyl5jbMBdC5/fA1plr0IYazGJW5LCF
         mlHK25TC6IRe2ODjwbgek4ygTr1RFfXBErHCMkdzaWNgTB+ZAnFixx3B4wtuq7GxbCr5
         54ENJw3CbtoMEO6rGznZzZvb2ZvB4tgDDmtHPdctluasuELVtkMAsw3rS32ogfADGtm6
         pJ9CufZXOPOVf7QKXPYGaWtoUWW3kBor1yE2REpZoURUT+E/O6MxVLxKuuk1CTinnePa
         wwDfZTXHUKCm4i2ho9uKlr9dsFwUJKA4VUJobvFpBgXO9Rf4jWXywJLERaNFcqM+8UEd
         tU3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=WJuRa4wasjbhsnCdqxL3Xo92pH8SS9eDtOb8VwpUFO4=;
        b=iDmJurtI4LkvhoozWOe4E721w2PVLAdi1ZhVBGnwbkkbXJdpvxQ1JvdID2NaPBuxc0
         aHf/0IQgwBkBUXsFv+lT88DxZP7Xz7Zo2R1rkMdwWxSgEXiP5szt40+UdJseq2atuapa
         wwiyvsvgRkSpe5So5S0zA25SjtT3OwXJp3D+Flvt3ktbWrAvr3HnUPLTpLpXJ5LOfkVw
         WFt0cm2R12zKiIMH7eoZ3B0TNiwIr5CeIOpXNbbBEdIyaA64JQBkgKDpnBI29Bcz9PQI
         Jz4Ffsiq49HPpLIzNqwP9Bx44K3L4Np+OK9gZBr7xjKkG+efiD2u0hxPzs5CINSrDHr7
         5X6w==
X-Gm-Message-State: AOAM53356A6joM53xC6pxcXAV3isblxnsSF4YpMBEBDVO+hpaYsG/GFC
        YhR2MeqfG9j0uRentabaL5XCvn119t0=
X-Google-Smtp-Source: ABdhPJzf+B25UO7JR0yKL6o0PsPpyuRBZTt2umoNEAVIW2gQmN9jcajOcuw7hs63A1WRCAH9vAAliQ==
X-Received: by 2002:a17:90a:1912:: with SMTP id 18mr1734141pjg.24.1632855126967;
        Tue, 28 Sep 2021 11:52:06 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id q21sm3104636pjg.55.2021.09.28.11.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 11:52:06 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Wed, 29 Sep 2021 04:52:01 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_log v2] src: doc: revise doxygen for all
 other modules
Message-ID: <YVNkUdbTR0MXGCRB@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210917044335.15568-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210917044335.15568-1-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

You applied v3. No need to keep this one in the patchwork.

Cheers ... Duncan.
