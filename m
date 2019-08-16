Return-Path: <SRS0=Eqja=WM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99FCAC3A59F
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Aug 2019 17:56:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7375020665
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Aug 2019 17:56:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="pQZR2TNW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbfHPR4o (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Aug 2019 13:56:44 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33915 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbfHPR4o (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Aug 2019 13:56:44 -0400
Received: by mail-qk1-f196.google.com with SMTP id m10so5476168qkk.1
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Aug 2019 10:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=mMaTuiPyKLM9tfCLZcB7Dek/W9Zw2QriOJBDcXfSjQ8=;
        b=pQZR2TNWrG26Y9jB/x9XjzoHpYgaG3BQIGAKjPUdsW3Ge1vrxVxyC3XbjpAHTlpUz3
         4HC7CraQcupeHBpge9VZHxM2vkVLVawnhiIxbYkDdd5lP2RszB1OISk96/UjsbIBlY8s
         Ah3FqiTn609CtBUAdj7VnSK1tr/9oP5use5bjDCn7Tlja1sBRxP3RmfTAa0qkJMva2K9
         dEbBckXSZjWRJUNGCK3yQP/D4HjGIH0Fpha05C5x6+wV8QUkJq0gTI+lo7HEePFpQyNP
         zJWwZfLxCpzAhKftwcKAPN6bn8RXT0AIaRKJYG9+v+9cbr89ZQByRdmy7eDkR8Hq5giS
         pdcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=mMaTuiPyKLM9tfCLZcB7Dek/W9Zw2QriOJBDcXfSjQ8=;
        b=PxOF2TNhwFN8VQrcCqazAZj2Y0YGmEmHYWi/Kt3dvaimJZAZGTdpcW2dQmX09CdZaa
         5Cek6s6Y8I33Dn53Ehhi36HFd86ofxnRv0YnHX4oLPVlQhGz4vSiStBHTGEIVY215tRB
         FvE9FuOSqEQqyB5TusuJnJ5ZmR+zXP/fVf5nn5yytg/upWUF3De1i6Uo1Pi2iAslHqfs
         bfteFsz914Nrf3h/NQG7+8qwklPx+y94BfArLGFzQ3pEC/0reiQVA5aRDdYdx8WY2Gde
         2oGkxOhEhKLFO9LLCGMxqVhPFOgBgWYEnHI+di7ZMMwC9SdNoxPOTTskkAyQNC8r+jR2
         wAaA==
X-Gm-Message-State: APjAAAUnD0Ap3y3nvAIfM2QGMwr9u1TSGAIo0gwyMlXInKDe6O8hvUHG
        6OWGHI6GGmwSHcXRFeYgNSy0xQ==
X-Google-Smtp-Source: APXvYqxgxMUn0Os7xzdLYkAtyUoCCk2KkYV1Lt1eDu/B49D4i+/3ZDwkfGjrtjynjQckySTiPVSNCw==
X-Received: by 2002:a37:ef0c:: with SMTP id j12mr8969221qkk.345.1565978203530;
        Fri, 16 Aug 2019 10:56:43 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z5sm3011473qti.80.2019.08.16.10.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 10:56:43 -0700 (PDT)
Date:   Fri, 16 Aug 2019 10:56:27 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     wenxu <wenxu@ucloud.cn>, David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v7 5/6] flow_offload: support get
 multi-subsystem block
Message-ID: <20190816105627.57c1c2aa@cakuba.netronome.com>
In-Reply-To: <vbfpnl55eyg.fsf@mellanox.com>
References: <1565140434-8109-1-git-send-email-wenxu@ucloud.cn>
        <1565140434-8109-6-git-send-email-wenxu@ucloud.cn>
        <vbfimr2o4ly.fsf@mellanox.com>
        <f28ddefe-a7d8-e5ad-e03e-08cfee4db147@ucloud.cn>
        <vbfpnl55eyg.fsf@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 16 Aug 2019 15:04:44 +0000, Vlad Buslov wrote:
> >> [  401.511871] RSP: 002b:00007ffca2a9fad8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> >> [  401.511875] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fad892d30f8
> >> [  401.511878] RDX: 0000000000000002 RSI: 000055afeb072a90 RDI: 0000000000000001
> >> [  401.511881] RBP: 000055afeb072a90 R08: 00000000ffffffff R09: 000000000000000a
> >> [  401.511884] R10: 000055afeb058710 R11: 0000000000000246 R12: 0000000000000002
> >> [  401.511887] R13: 00007fad893a8780 R14: 0000000000000002 R15: 00007fad893a3740
> >>
> >> I don't think it is correct approach to try to call these callbacks with
> >> rcu protection because:
> >>
> >> - Cls API uses sleeping locks that cannot be used in rcu read section
> >>   (hence the included trace).
> >>
> >> - It assumes that all implementation of classifier ops reoffload() don't
> >>   sleep.
> >>
> >> - And that all driver offload callbacks (both block and classifier
> >>   setup) don't sleep, which is not the case.
> >>
> >> I don't see any straightforward way to fix this, besides using some
> >> other locking mechanism to protect block_ing_cb_list.
> >>
> >> Regards,
> >> Vlad  
> >
> > Maybe get the  mutex flow_indr_block_ing_cb_lock for both lookup, add, delete? 
> >
> > the callbacks_lists. the add and delete is work only on modules init case. So the
> >
> > lookup is also not frequently(ony [un]register) and can protect with the locks.  
> 
> That should do the job. I'll send the patch.

Hi Vlad! 

While looking into this, would you mind also add the missing
flow_block_cb_is_busy() calls in the indirect handlers in the drivers?

LMK if you're too busy, I don't want this to get forgotten :)
