Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9545CC4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Sep 2021 08:17:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7527C61247
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Sep 2021 08:17:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbhIVISm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Sep 2021 04:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233427AbhIVISh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Sep 2021 04:18:37 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5460C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Sep 2021 01:17:07 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 203so2008653pfy.13
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Sep 2021 01:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=562oYaolIC8vBA8fP40tH7WxWG3apWRI/TE8QkooB70=;
        b=DW8W8FnynUr/v1st6KURxhPi5JpNu6Yor8Ur0akWJTfbdOMmBHVM1wlX6o6sedMWAP
         Y4jXjLsso3h/igRvV6hVIc0a1E0gST4baN0dnAXneu6ikZSSzOvPojR9zacfiTJEMRUb
         PXD0zkN+TFVMxfCLH7ia0B6BwegUG0FAbd35SeAaoH+xnxiM0selt2eiiEkHXuz/x5oN
         j9+f3bya7LT4CUEuOszeBdoMtxaZO92Ajrb2mr76g7z3BbxqHW/54RFw0b1ncDVThNNh
         faOFsTX12lADKAHX8KCXjn09wKPyq/A3DMYv4SjlIJLI1u2ZEqqJ1SG/T7inWL5TrFLm
         U2aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=562oYaolIC8vBA8fP40tH7WxWG3apWRI/TE8QkooB70=;
        b=5V13aCkJ6L6JN0ndFMAJZ5b6jxUmDaJYKDKre6njBwFW0+XoOutccl1uX7zKOrm361
         LZFPvAS6l3YEZxQVhB5Fv2iAM19XQ1ElxwGVijhEWs5cyigqg9aeJv81x7HCpUrO2uXr
         pUMuvEHYJPuMGltK/KqEOdVabdw4KkCuy5qK+O3EJ0rRtfLuwpl+4I+QG2kHYg2lDLfm
         Qn5HWlUwW/+zsDYtJAQG/MuH57ZuyDTq4HsiQGhnZOgQLW8XJvbJ30UTw+5ZRtC0W7wp
         556DbmfIevQhIrx/lmvO1vKeGV6JOK5eq0H89UuTHY5XTVjNdF3Vq5m0FGEnlxP1cXmr
         44+g==
X-Gm-Message-State: AOAM530zJCdE22APmhUrJqqzMmV4Mllwyx40yIn1AbpnFP6r+JVFzJmk
        x/Up8M/98KHZB2+xV6bU0STorI1l5Ns=
X-Google-Smtp-Source: ABdhPJxH+5WjNB33zKX8G/uuOfXMnY/JDD1Cb08qpDZDJ34Mrwl50H3ZeB2G2WgyRNYpkeNHl8WPcQ==
X-Received: by 2002:a05:6a00:1a87:b0:448:7376:20c3 with SMTP id e7-20020a056a001a8700b00448737620c3mr5837709pfv.24.1632298627370;
        Wed, 22 Sep 2021 01:17:07 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id m18sm1471820pjq.32.2021.09.22.01.17.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 01:17:06 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Wed, 22 Sep 2021 18:17:02 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_log] src: doc: revise doxygen for all other
 modules
Message-ID: <YUrmftCkIj6gbrKb@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210916035236.14327-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916035236.14327-1-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

I sent a v2. No need to v1 in patchwork is there?

Cheers ... Duncan.
