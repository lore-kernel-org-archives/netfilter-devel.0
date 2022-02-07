Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 372E7C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Feb 2022 00:24:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbiBGAYY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 6 Feb 2022 19:24:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbiBGAYX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 6 Feb 2022 19:24:23 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824E5C06173B
        for <netfilter-devel@vger.kernel.org>; Sun,  6 Feb 2022 16:24:21 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id q132so10105707pgq.7
        for <netfilter-devel@vger.kernel.org>; Sun, 06 Feb 2022 16:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:date:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=fJV319Sj2L/QUyXh+tN4h2zELoD/D0mtDaboconfLBk=;
        b=fmq8Jn38/Z13KBknZWuUv006obLDn8oKdgmQMUsFJwsDrNcFF9RBEA6x+TQgQ5KSro
         GKLGPh1SG25REF3oqLjVFe7itzz2n4cAYapFn02/Jtp20Ur/ve4sCKgXLBBEQ7w99X0k
         Frla+xbuvkFEnz3XJoGMScxG3mRH/i9A2R2BZPwsCNaytXl8dkgy7FfdD9TQKIly1FIS
         DcFB0Oqqq2zWXH7zSdgFsgQl/Le3OJhjTgM7macVD0wcb30UAEcfaNDnUggwxPi5h5L3
         wxfMLWM2HevOKMkZNZ/AQwS4+6doXNVrXJ83t2q37iCJYo9+mN9McQDJV9ishYgc494J
         EUJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :reply-to:mail-followup-to:references:mime-version
         :content-disposition:in-reply-to;
        bh=fJV319Sj2L/QUyXh+tN4h2zELoD/D0mtDaboconfLBk=;
        b=3Eva7HriRIbM9kvL0BIof2NbGtmxawA+usgCd9PCBVIDi5PLtkOQWD35zMlPO45D0Z
         uJpOy48lQ5XLApW2oaj2NyX+VtSY813N1X3INoof+PvznQSaohoJm8lIkVH5ATinZc2E
         /C4LovnhgjItrqrMcH5GxMRyBQE+lfrrh9lV88EHRhhvBl6bvO2h4ONuC2JVn63D9Hex
         ms28P6DoF3LFanrn4470MJpQiobl2IW65+4U4tRorP/3PidG0E9uizL4wjOl/ZOug2si
         7dh4pbQJPINzDK6/rGj/KyeTxuzMd5vocwCIyUuEVGHq4pkAf7Ttj2L4D9pDwfpuJqXr
         RYiA==
X-Gm-Message-State: AOAM533O4l+Q+Skbx91i1fZpngmDcTe4q73HpNrbIezJqFxmFUj0TgkT
        4XZOT8YYTgLEBoN4rNPgpBE+nru8ap3czQ==
X-Google-Smtp-Source: ABdhPJxRkK+AtE7R7Zljurr3T3a7Vy5ZKfzqB6g0uXDu0Er22Pb+F6yZzHB1wBY3w9NptR1SOHBv6Q==
X-Received: by 2002:a63:512:: with SMTP id 18mr7470502pgf.432.1644193459946;
        Sun, 06 Feb 2022 16:24:19 -0800 (PST)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id j19sm8894404pfd.125.2022.02.06.16.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Feb 2022 16:24:19 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Mon, 7 Feb 2022 11:24:15 +1100
To:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v3 1-5/5] src: Speed-up
Message-ID: <YgBmr3+IqGXQ4M6E@slk1.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20220109031653.23835-1-duncan_roe@optusnet.com.au>
 <20220109031653.23835-6-duncan_roe@optusnet.com.au>
 <YeYClrLxYGDeD8ua@slk1.local.net>
 <YeYTzwpxiqLz8ulb@salvia>
 <YejdVZaoUz+t1qRU@slk1.local.net>
 <20220120120458.GF31905@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120120458.GF31905@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jan 20, 2022 at 01:04:58PM +0100, Florian Westphal wrote:
> Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> > On Tue, Jan 18, 2022 at 02:11:43AM +0100, Pablo Neira Ayuso wrote:
> > >
> > > This patch have a number of showstoppers such as exposing structure
> > > layout on the header files.
> > >
> > That's only in patch 5. You could apply 1-4. There are actually no other
> > showstoppers, right?
>
> Regarding patch 5, I think its ok except the pkt_buff layout freeze.
>
> From a quick glance, there is no assumption that the data area resides
> after the pktbuff head, so it should be possible to keep pkt_buff
> private, allocate an empty packet and then associate a new buffer with
> it.
>
> I agree the memcpy needs to go, nfqueue uses should use F_GSO feature
> flag and memcpy'ing 60k big packets isn't ideal.

There is no pkt_buff layout freeze. If we want to change it in future, we bump
the major version of libnetfilter_queue.so, same as we would do if changing the
signature of an existing function.

Or am I missing something?

Cheers ... Duncan.
