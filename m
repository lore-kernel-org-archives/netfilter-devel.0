Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 221A9C433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Jan 2021 07:35:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2AC96024A
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Jan 2021 07:35:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbhA1Hel (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Jan 2021 02:34:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56237 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231615AbhA1HcN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Jan 2021 02:32:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611819047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KmFwH+NTWnm+HaRi53zxgWEDYYKpNRwcitotzbjxLYM=;
        b=JxmrN0k0T+DzjrAnA7iPRLDHP3qbo5wsRIv8sI4Cp+8TuanloOhiIXn6f8/XBYuRL9iU4Z
        0jHN2lDjTvSPEqNZgLwBksCmOxZZP6Gl1elhfww+VEnm/IHV9grQLx3HOEF7J7IYlB/YbE
        zN3ABm+VEOzMIaUBpu4jUOGDfBJ5Orw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352--mCpE1T8NsOP2AUhWmNP_w-1; Thu, 28 Jan 2021 02:30:45 -0500
X-MC-Unique: -mCpE1T8NsOP2AUhWmNP_w-1
Received: by mail-ed1-f71.google.com with SMTP id dg17so2762417edb.11
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Jan 2021 23:30:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :user-agent:date:message-id:mime-version:content-transfer-encoding;
        bh=KmFwH+NTWnm+HaRi53zxgWEDYYKpNRwcitotzbjxLYM=;
        b=ehzjIqJo/cT9XNt2Bsph7x49InB7v2XJmNuokV7Kj0aXQNZ99V90torrP8WLgoZnlV
         fIkb14N5czJ+GbRv20vG+xC11+AYzoicwlbiidxXt1fbX82rpemsZyINtVXMCJ1IunML
         Bw1I0WZKoz97BotTPGoEPvOaF2wKudl3r1F3wVDvN5hs2TXgDGQpB2rZbLAv8EKVDQiT
         LZt7Upyec/3qHl3CTIGBahxCh25MHIKPtb6GoIGh+H2sHmfpJWeMsPxX9/VwtX3H4ZHJ
         u0+X2vxeLVgI10zp68ZMHDDV6nynrpdAMaa+sd/SkirXfB8EBJ0vfC819+Sxhz31+7Aw
         DNXw==
X-Gm-Message-State: AOAM5336KbPiH3d77ozfRHc5STEOKDxUfC55KLdeaaVKVEQ6R6Iq2p5i
        QrIdnGVB1uys7l+velXYVn4EwgL8vPwjrClgRkSFlBv3gB2IDIWZs4CcVcsoRQ9FNre/afiJs2i
        y0E7FQwLz7jrmrwuHObEzSZZv4pDU
X-Received: by 2002:a17:906:8046:: with SMTP id x6mr9957072ejw.351.1611819044177;
        Wed, 27 Jan 2021 23:30:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzyHPC2nZ+vqIWlKaHL1+SVOihaQA3UThbDNe9fwlc50NNAlC+cTPoIYMnUeifDdRSLgyfZLA==
X-Received: by 2002:a17:906:8046:: with SMTP id x6mr9957065ejw.351.1611819044084;
        Wed, 27 Jan 2021 23:30:44 -0800 (PST)
Received: from localhost ([185.112.167.35])
        by smtp.gmail.com with ESMTPSA id k27sm1852810eje.67.2021.01.27.23.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 23:30:43 -0800 (PST)
From:   =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        =?utf-8?B?VG9tw6HFoSBEb2xlxb5hbA==?= <todoleza@redhat.com>
Subject: Re: [PATCH] tests: monitor: use correct $nft value in EXIT trap
In-Reply-To: <20210127225134.GU3158@orbyte.nwl.cc>
References: <20210127140203.2099010-1-snemec@redhat.com>
 <20210127225134.GU3158@orbyte.nwl.cc>
User-Agent: Notmuch/0.31.3 (https://notmuchmail.org) Emacs/28.0.50
 (x86_64-pc-linux-gnu)
Date:   Thu, 28 Jan 2021 08:30:42 +0100
Message-ID: <87o8h91pst.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 27 Jan 2021 23:51:34 +0100
Phil Sutter wrote:

> Applied, thanks!

Thank you, and I apologize to everyone involved for the lack of proper
tag prefix in the Subject; I only realized too late I should have added
the "nft".

--=20
=C5=A0t=C4=9Bp=C3=A1n

