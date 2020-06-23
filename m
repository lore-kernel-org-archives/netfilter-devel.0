Return-Path: <SRS0=AczV=AE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1A2BC433E1
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jun 2020 23:11:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 733CA20874
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jun 2020 23:11:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OSNwLeem"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388634AbgFWXLt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Jun 2020 19:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387603AbgFWXLs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jun 2020 19:11:48 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51594C061573
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2020 16:11:48 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id k23so91278iom.10
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2020 16:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wr7D9qr23jJoi0F0i5hYffC0PVGDdnNDhckq1mg1t2s=;
        b=OSNwLeemY9rtEB1iTQWkQR68Anwn6/4GraoyNdS+hChQUBdhrOrB2Q+K3/x6FFs8Lr
         bHYWu3UAtEa/gmj9j8DcTtaWQ4bbz/jNTZUWrfLVxZ7kbkj9LLvw6XpaJEx00K79asfu
         x8C0qdmkWnNHdN23nIjkGQO5q55aRKaV+t3mXi5UnGhwbTAh4AlmuL03ShDBMM7itPXH
         zUWaHKKKkaRZDNT2aADwPsqrSepK1KNFuuMf9pryMFr/t5KvSrofaH2+e+6C4vf84nYW
         2+bFF+oWjejxa+v0X+O5fbcfjsgAtPLA/4NlW9ABOp6Zk/+9CTnkTp7RS8Vp5NlqKZkj
         u8jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wr7D9qr23jJoi0F0i5hYffC0PVGDdnNDhckq1mg1t2s=;
        b=nsSWVI3amGnJIBi9ZPFvtDf1nE11HVEoOxsWZfhtb7jNS5t0Mvj5/TsT8Mx7HYeF0+
         86SPRgqVvNK9uRD9yccJAhbuUtcEb74i0FKkOkZk5qm4fDJxdUWWNJsvrAWgknLzbgu5
         vt+K3ODiRl+nudWfvm6zbJVnZH/ezZrA9ds4KEetV+dtkxKXD8J1zqY5USD/1yvWI0ym
         GN3uo7r8T1MEw/iJWQJPTHtLhUDXbBGZpyXHJ00mQHZRO7TVDjz/dA75lYIW9Zm70S0q
         vSxG7rT2LR2cuB62RFKjjv82CXZkFbarY8B6rp1uAbSumQn70Tm9jbkH3jJEyKkMAT/k
         YR2w==
X-Gm-Message-State: AOAM531RfDdiAQVErj/nLYThyRQwNYUvDKt6N0BPWsrBsWphW3XQEXT/
        eZPx0lvTnyROWpMREWnvPXSReXlmqvY41vrgLBN5oQ==
X-Google-Smtp-Source: ABdhPJweyGcVWHbG+ZRb3nEK/m//+hAK2CbPENKG+Ihf6r3tV2OVc+9EMa1MWUtSLCY9CJ5B/KcILeuy8o6m/scSKaE=
X-Received: by 2002:a02:3c08:: with SMTP id m8mr1151969jaa.107.1592953907499;
 Tue, 23 Jun 2020 16:11:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200623230902.236511-1-zenczykowski@gmail.com>
In-Reply-To: <20200623230902.236511-1-zenczykowski@gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Tue, 23 Jun 2020 16:11:36 -0700
Message-ID: <CANP3RGfGE2PnaZUJ0Yz79sUf=zsQ1hjxHWhP8pEvQD+y2BWq5g@mail.gmail.com>
Subject: Re: [PATCH iptables] libxtables/xtables.c - compiler warning fixes
 for NO_SHARED_LIBS
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

>  void xtables_fini(void)
>  {
> +#ifndef NO_SHARED_LIBS
>         dlreg_free();
> +#endif
>  }

Note: I also considered just adding an empty 'void dlreg_free(void)
{}' function in the NO_SHARED_LIBS case, but that doesn't seem to be
the prevalent style...
