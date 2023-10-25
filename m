Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EED5C0032E
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Oct 2023 22:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjJYWaP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 18:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjJYWaO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 18:30:14 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701BF8F
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Oct 2023 15:30:12 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-6b2018a11efso247820b3a.0
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Oct 2023 15:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698273012; x=1698877812; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QDCEHX6E+g8J5jRvogBPZQjlR4vNfnI1PKKQEUnEgm8=;
        b=SNQdLovoZqMEtxkMI3TJffrHm0TfoHeDUmdVId1WuhAwjdNV8J3CxMB6EFhrzNf6fB
         IVWhRcVKhIkfHGAXAu0ydL2bn3gGra5cJg0DQs5xoUTwhM5exPdkYuI80Z9EwTxj89uR
         7BnPSVc/whl4kEamxOrVmv/d32gnD4JqCPKVyAiil6mE3QfLWHEROurQIKNLeep9qEHa
         FUXLmDehLt5WaDuSXVTc+FEUzMsqz4zg5z4NiJWVd4lAeYFWbUzz77zYGQYi21A2TYFU
         203qL4IFN6FU6IYHLTnQlk36G9B6QrjRKogpeIXb15KsicPjwwtBswBlWyw7pWgzi4wB
         s7JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698273012; x=1698877812;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QDCEHX6E+g8J5jRvogBPZQjlR4vNfnI1PKKQEUnEgm8=;
        b=gqEhI+OeWUPxdyjXr8EV020aU4sjs0uYFWrA21SP1hTTFyQy9a0w3NIFEj8fz7YQ9f
         edcDtuQdN7XjRYwZjfk7vyT03kjNMxgxWxZ21rb92OQLaJjrccdBiSc4XoVj1o9EpGW8
         4mGNlARnqMQoou4nd1m1YtKsXOgS1IxYkQqgm+gNXywOIEmk38kEzrKyCUGIAH+Qz/It
         RRDEmdN/kiVu4u0dvWbNJsVKaT9P/zxpZeuIFIS68Arfj7+Gu9iFe5vPSlavFnOtsxVL
         46frGzRTRXKvRGwFGp0NGWZ0lianEyo7onl/k5UAiz+rgngSyuK7wL4BMb27Bx3bUjc6
         CoJg==
X-Gm-Message-State: AOJu0Yyj4GNbIOUdhvSJT5aPdaPy7c5yyg+Etx+CKvQTIkIfO1FiW0JI
        El/FXYAspZUIAk2Dl9SSJGM=
X-Google-Smtp-Source: AGHT+IEBVon6/xM67fLCTbFDUM+TwLVIJADnXVVOqMFI9q17w8Q3fAYtKxZlS9QRavQ252NFLg35wQ==
X-Received: by 2002:a05:6a00:230a:b0:68f:dfea:9100 with SMTP id h10-20020a056a00230a00b0068fdfea9100mr19349764pfh.21.1698273011890;
        Wed, 25 Oct 2023 15:30:11 -0700 (PDT)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id y5-20020aa793c5000000b006926506de1csm9799362pff.28.2023.10.25.15.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 15:30:11 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date:   Thu, 26 Oct 2023 09:30:06 +1100
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue 1/1] Retire 2 libnfnetlink-specific
 functions
Message-ID: <ZTmW7nRuMLyfKMr0@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20231024005110.19686-1-duncan_roe@optusnet.com.au>
 <20231024005110.19686-2-duncan_roe@optusnet.com.au>
 <ZTeG5IdKHwuoDIuj@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTeG5IdKHwuoDIuj@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 24, 2023 at 10:57:08AM +0200, Pablo Neira Ayuso wrote:
> On Tue, Oct 24, 2023 at 11:51:10AM +1100, Duncan Roe wrote:
> > Remove nfq_nfnlh() and nfq_open_nfnl() from public access.
> >
> > As outlined near the foot of
> > https://www.spinics.net/lists/netfilter-devel/msg82762.html,
> > nfq_open_nfnl() and nfq_nfnlh() are "problematic" to move to libmnl.
> >
> > These functions are only of use to users writing libnfnetlink programs,
> > and libnfnetlink is going away.
>
> This is the last thing, first this API needs to be adapted to use
> libmnl.

Yes, you can apply the patch any time - I just wanted to make sure it was
acceptable.

Could you in the meantime please apply
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20231023022555.18740-1-duncan_roe@optusnet.com.au/
(canonical whitespace in headers) before it gets forgottten?

Cheers ... Duncan.
