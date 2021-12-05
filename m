Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CE36C433F5
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Dec 2021 01:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbhLEBhi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 4 Dec 2021 20:37:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbhLEBhh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 4 Dec 2021 20:37:37 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9BCC061751;
        Sat,  4 Dec 2021 17:34:11 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so8079327pjc.4;
        Sat, 04 Dec 2021 17:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:date:to:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=HSu5QIKy/jOkeLrHT2aR9NRCh5+6hFGsAB+C91G37kQ=;
        b=KMFRaG5eoacMOg6+WbBWa5z4WivDNCCCVei5nhKjl+7JD/2+5JXlSyr4iCNQqV9vA8
         QVUBmVilKXVYlHD6C0oFjE0y5L5BbKhkS7aLPSprvH0Z//Wyi78tq817W+g85vIUJL6t
         LNc+W5e8bj85uFlWw/Qcloptj3fEO4xWnnvcl+Bw4v1ijQnToqXKoEwzLg7GLatpfeVM
         zdlKz1x4zYB+xIsViP14Q2EVJ5aDFZmywvq9toNcPAAFvS/Ts1uztUqM5+9E/y2nRaH2
         RlpS/SDqtTmBedZzOnrtGp8PproCO6MsM9A2NuRL/Us+YF+V8W8mRtuRXUpIDB0EkQZ1
         YuHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:date:to:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=HSu5QIKy/jOkeLrHT2aR9NRCh5+6hFGsAB+C91G37kQ=;
        b=U/GZTprMccAQik8WK6fPNQqIhzdi66A5uG6nH/kMyjSWbHb5PGvlIitEb7pnetfoAG
         w7j3WtENJoFgRBs4WaMFgVGFOQURQIee3Re0Z+adlY1bNags1GDQim1CWz9wKQeDvHOX
         rkZJdosrCWS+gdzmsMJ0WOtPkayF0q/x3p2By3mjnwn0kXHkHTo91lNSmA2svYEEdZvQ
         EKPXy9XlFD8rlk5C8yWsAINVnzjr4nXWY6aahgwChZ0wW32DmWsxzpCG6iZ/HntMf9yS
         4o00K2MOzed4BjfpwGWpUqfXF4eJiwaA+eaTVFdkl3kAUM4WTy7o3iNRyEgKrUTXYoG6
         Yswg==
X-Gm-Message-State: AOAM5321E6UF2cdU14FxwAq0d0LyRyKSwqFNWnQBVuSTXW7p5vYgLm7v
        15BexSi9MGLPjrAzsPGjv+t//ncAWN4=
X-Google-Smtp-Source: ABdhPJzZMBpW9GLFa7NAynBu8WxVcWebApX2aaordBUjouhzxZ7WkcPkNldogwibQiQkIR0fV/ti6w==
X-Received: by 2002:a17:902:6905:b0:142:9e19:702e with SMTP id j5-20020a170902690500b001429e19702emr34525609plk.34.1638668050089;
        Sat, 04 Dec 2021 17:34:10 -0800 (PST)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id v1sm7340456pfg.169.2021.12.04.17.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 17:34:09 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Sun, 5 Dec 2021 12:34:04 +1100
To:     netfilter@vger.kernel.org,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: Meaning of "." (dot) in netfilter
Message-ID: <YawXDEt0yjUQadKC@slk1.local.net>
Mail-Followup-To: netfilter@vger.kernel.org,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <CAK3NTRAQE7UD9_0EuzyS0UGQ_s++Dg_hbZPXscHBrStnGJHGjw@mail.gmail.com>
 <YascpztWuzJgKRgq@slk1.local.net>
 <9d66247c-51c5-b2d9-584b-0422c99d08bd@average.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d66247c-51c5-b2d9-584b-0422c99d08bd@average.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Dec 04, 2021 at 01:05:21PM +0100, Eugene Crosser wrote:
> Hi Duncan,
>
> On 04/12/2021 08:45, Duncan Roe wrote:
>
> > "." is the symbol for concatenation. It's been missing from the man page
> > forever.
> >
> > I was going to submit a patch to add "." but wasn't really sure when you could
> > use it so I never did.
>
> It is my understanding that the only use for concatenation is to define
> composite value for the key in a `map` / `vmap` or the element in a `set`. Maybe
> someone more knowledgeable can correct me.
>
> Regards,
>
> Eugene

I thought it was set definition in general. Again, someone more knowledgeable
can correct me.

Cheers ... Duncan.
