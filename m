Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49CE9C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jan 2022 23:58:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236081AbiAQX6U (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jan 2022 18:58:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbiAQX6U (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 18:58:20 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9142AC061574
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jan 2022 15:58:19 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id f144so10761832pfa.6
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jan 2022 15:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=7i1JUYKIrqg0zyNB5SlK2tK6AU+TQz92bV79TulMs2Q=;
        b=VQDlF38gpQhNS/fV8PuNioy/sFQroHaR+oviC0DTnQ3HMTis+PgbwjoADp6IVVwp6s
         RczTJaB9tlTuXD4EeaTep+KKTjFrpXJ4/ZaocHb4ssNRnXitWBHamCjiLE6oLIbeeCu1
         J9BZA6JNj0xHaVfslrBckNPLvgPSwfM8j+1t9agRNSpH50cxv4bctAUVZPce56yuDeTO
         gJFUuseOXR73YRYmV7o1yQR/z/PTesmfLLZAmoXw5biGgOFOyllu58N4vhHA7XzJ5yGE
         j0TPAAkHzmht0CJazLJC/lOdsGh9GQSOWuxxbgcrjUb/0ciPULgZMsO1m3i0FZVZ/+ut
         IzWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=7i1JUYKIrqg0zyNB5SlK2tK6AU+TQz92bV79TulMs2Q=;
        b=EB18/8YaSjd5RbIi7XJJGC5cVRDuO3Iwm65XBdorKLaKGE34jBK9urCkDEJ16J7zzk
         NcrRwf9f88Qbw0IR8XTzDn0k9lHuxwIZSH2uolzJdTYl8x9eCyWtnrC9+qG6NtBI/Vcr
         OyFQS93e/HYa9zjhP2SRStQHsMYRM8MPhGxjptLC9RavlE9IjOu5/ubh/4rdxZ44VfPQ
         XAGGhLc/SVBV0GxLsiN843rFHBzJ6sk8v8Xc78zxm91LXd6F7CbAJUoaD13LjGtk6F/1
         1u38K9AYOLgghgDUA9+nBAKIl74asfAfinJBArHKHVfIpI67LQVL7ycyC1mL8dywLaqP
         6O4w==
X-Gm-Message-State: AOAM533nhpRXjiS/hEi4VvZTGbj31zFlQW21y+BvMvPMafCGRlf61SQu
        d5WLtEQ+W+3M7DEsJXdxIJiL8S1E2Ho=
X-Google-Smtp-Source: ABdhPJzw9YPfR5/SBH1enN+ZLdioQvOhzY5VxCzSAtXF4/mZS0efJXkO6JQdyZbcpDQH6p6MA7fthQ==
X-Received: by 2002:a63:a10a:: with SMTP id b10mr21085176pgf.539.1642463899175;
        Mon, 17 Jan 2022 15:58:19 -0800 (PST)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id kb2sm428413pjb.14.2022.01.17.15.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 15:58:18 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Tue, 18 Jan 2022 10:58:14 +1100
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v3 1-5/5] src: Speed-up
Message-ID: <YeYClrLxYGDeD8ua@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20220109031653.23835-1-duncan_roe@optusnet.com.au>
 <20220109031653.23835-6-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220109031653.23835-6-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Guys,

Withot this patchset it remains an embarassing fact that any nfq program that
uses the deprecated libnfnetlink interface and examines packet data will use
more CPU if rewritten to use the libmnl interface.

Please apply the set or give feedback on it as a matter of urgency.

Cheers ... Duncan.
