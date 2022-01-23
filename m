Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64B52C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Jan 2022 02:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbiAWCDo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 22 Jan 2022 21:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbiAWCDo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 22 Jan 2022 21:03:44 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DEDC06173B
        for <netfilter-devel@vger.kernel.org>; Sat, 22 Jan 2022 18:03:44 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id f8so11656231pgf.8
        for <netfilter-devel@vger.kernel.org>; Sat, 22 Jan 2022 18:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:date:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=yW99BXKbrW3jYCuhZbhELEpg61/Lmxo2WyLuXmu2f1c=;
        b=iC/xrinwZ2zCuvNKsLjuG8k9fJRo8X4mY+5lsxDghFXlKn7elnsy5ckitbyj1G6DTH
         LLkq1n6JNL6U0vpsfHSGFSAdD/vsIM3kn9b5YAm5ILQr8PxhzzVhF58o8hwD9yjG4W3Z
         7UUe/v049zQrPeY5MuxMHs4LQTtYYx9RTHcpLZ47inV5fiN2CCaMfHGb84H26ZRLohmH
         NxUyDIAcxy9hUOlI+t9KdnmQDMXQCzhFB0QG+LyEPqehUcopkkHNaBuQnZHGRd8ouyzp
         x75QsmcUsjE1+JogB5BMlqJnC9tuh4vy6++APJ2x1/Bs5jWnRp2T1qfkIqd+buSRoPHU
         /xSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :reply-to:mail-followup-to:references:mime-version
         :content-disposition:in-reply-to;
        bh=yW99BXKbrW3jYCuhZbhELEpg61/Lmxo2WyLuXmu2f1c=;
        b=pFGA1SOBipTXBBjA/yPG444NqQUMhVOSGuFyp+FvyxiebJ1L+qUZuhzJ+lXEFhclwq
         NCb2Le2quMoW/UmAXjfrbd44JRz8GkYY3R6f9+V7umxZrKs/oBBmO399f/Sz6WPM41xM
         eJUkcvXgUtRrTXNl/MXpJ+VIJbKyzMYBUjiDPM9MO1sj3USXjQuXgCwVD8M0tRHosY+z
         +XUkN3J5jZDyEKkT2ii4SMS+Bua3lsFF3FQCYgJxJJNsGqwH5sOpUwXbY8+QjV2k3Frg
         ac2ntVqD9nYM0dCo3tnPHBwbyzVEy+VEsJB3/vYU0AMqAEy09QU/44mbNvSWpzE14eA8
         J8PQ==
X-Gm-Message-State: AOAM531GAbM9gNg/QM2jwbLw5UwHvAdzqWCzzj3ClMtHkG1cdxFgMG//
        2mXwA4ADIQzkRTsQKR1QN3jXsY1l+vU=
X-Google-Smtp-Source: ABdhPJzYykkShL7UKnomk2NzcO+fjfNt8qbROyadPiXQ2Zy+TVprPuI9Pg0jvtQBXQvc9UFRI3Fs8A==
X-Received: by 2002:a63:6906:: with SMTP id e6mr7463174pgc.170.1642903423652;
        Sat, 22 Jan 2022 18:03:43 -0800 (PST)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id 17sm11496275pfl.175.2022.01.22.18.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jan 2022 18:03:43 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Sun, 23 Jan 2022 13:03:38 +1100
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v3 1-5/5] src: Speed-up
Message-ID: <Yey3ejkO5RKz30LA@slk1.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20220109031653.23835-1-duncan_roe@optusnet.com.au>
 <20220109031653.23835-6-duncan_roe@optusnet.com.au>
 <YeYClrLxYGDeD8ua@slk1.local.net>
 <YeYTzwpxiqLz8ulb@salvia>
 <YejdVZaoUz+t1qRU@slk1.local.net>
 <20220120062725.GB31905@breakpoint.cc>
 <YeocMjUD45w2THPh@slk1.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeocMjUD45w2THPh@slk1.local.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jan 21, 2022 at 01:36:34PM +1100, Duncan Roe wrote:
> On Thu, Jan 20, 2022 at 07:27:25AM +0100, Florian Westphal wrote:
> > Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> > > On Tue, Jan 18, 2022 at 02:11:43AM +0100, Pablo Neira Ayuso wrote:
> > > >
> > > > This patch have a number of showstoppers such as exposing structure
> > > > layout on the header files.
> > > >
> > > That's only in patch 5. You could apply 1-4. There are actually no other
> > > showstoppers, right?
> >
> > Why does patch 3 exist? Shouldn't that just get squashed into patch 1?
>
> Didn't think of that. I have a squashed version now.
>
Also squashed patch 2 into patch 1
Cheers ... Duncan.
