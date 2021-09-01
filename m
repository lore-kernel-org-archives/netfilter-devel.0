Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3057C4320A
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Sep 2021 03:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C075F61053
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Sep 2021 03:50:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241638AbhIADvP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Aug 2021 23:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241856AbhIADvP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Aug 2021 23:51:15 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE23C061575
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Aug 2021 20:50:18 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id n18so1364732pgm.12
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Aug 2021 20:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=pYtjHY2LFWTNl1YpHTW2N8bGNK2pYJY0/sG89ZRD9os=;
        b=XJuyN5PFvByvGnvgK+A6tuLuNzdViYw6GFmEN+GJ5wcqu7JuzGZLXAmxlPl/3hj4bb
         GGaURZIsoByTIt16Woav6PsPMWb4xCN6F8c/8F6KFt/wxTCIEWXnJIyLIOLxeCdu/1a1
         dMpSC4d3jyGpes89JY9hdSBXxxT0vJKww09ZhnlZ7jVWunWSxoCKo3fHkgSM/VecGKEc
         1xKkmPmJWEQxkBv71+CgNOLoefIdc068tTFpCfHZQYX9sDThegavJ7OAAGJlw2q/jPXk
         ZmIgyq9JxQy7x32poeFsm08A6Y9obmQYToWguXgjOlyx8+72wn9JQ3EmJIcxivML74HS
         PWQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=pYtjHY2LFWTNl1YpHTW2N8bGNK2pYJY0/sG89ZRD9os=;
        b=Q3nempc4YOu4uq+8FEITCzFeyLZUcKZWc3NrepQ/rHg5Wvt8Cpun9g873OYMCJz7ay
         qeA4xCS6kX0lXuzx+rN+EkUbNzIP0AtSrDV05WaAx+uIdhKZ5Z4B4O4o4HM7D6nkqEKV
         DFNM3gCTnySTxp3vxQMTFkT5pZHa0dvuGEGKkaZE+QeGZsbHpnr+8SPvC5TOcnjVw7/8
         PECO9BPvgrxTiVB/Fnoab7QuK+5IW1RY+mC40Xq7VPHCOvF0h15KJALuwsYh3aAZgILI
         0UzVTrK5mdSr1oLIWQGDZMo/QYzK6rzwyB3wD17Z4bnVccS1L11TElOt62YaRP4nOE1d
         TWnQ==
X-Gm-Message-State: AOAM531lz+br/GM5TOVZAFjgPey+6WblkNdWuGqlyrKhox3j/j1BynoJ
        PIEaYhvmP3FLHNiuW4b2LAYToOfGcck=
X-Google-Smtp-Source: ABdhPJyWVXD7p5nJHjyxTRAGoO7+vQJ2c+OtQqUG6KG4v/CQ3aT6gJzxnwUfQYkrv1IVnK5hmiQLfA==
X-Received: by 2002:a63:1d63:: with SMTP id d35mr30038576pgm.238.1630468217615;
        Tue, 31 Aug 2021 20:50:17 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id q7sm4167639pja.11.2021.08.31.20.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 20:50:16 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Wed, 1 Sep 2021 13:50:12 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v2] build: doc: Fix NAME entry in man
 pages
Message-ID: <YS74dGspexTdeI/H@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210810024001.12361-1-duncan_roe@optusnet.com.au>
 <20210815121509.GA9606@salvia>
 <YSROzjG3oyIYS6oN@slk1.local.net>
 <YSlEqAnybDgl5FaF@slk1.local.net>
 <20210828092303.GA14065@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210828092303.GA14065@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Aug 28, 2021 at 11:23:03AM +0200, Pablo Neira Ayuso wrote: [...]
>
> Did you consider to send some feedback to doxygen developers? Probably
> enhancing \manonly including sections (ie. \manonly{synopsis}) would
> be the way to go? I guess that would be more work upstream, but
> everyone would benefit from this.

\manonly is defined as
> Starts a block of text that only will be verbatim included in the generated
> MAN documentation
and as such looks kind-of frozen.

I have found that putting the right headers in the synopsis is very much a
manual task. I write a nonsense application that calls all the functions in a
man page and see what headers it takes for a clean compile. I see no way to
automate this process.

My contact with developers in the past has been bug reports with (rejected)
patches (the rejects are not surprising - they know their sysem way better than
I do). But the bugs have been fixed.

I have posted a couple of comments to Chris Miceli's blog titled "Integrating
Doxygen with Autotools". The posts talk about fixmanpages.sh and how it was
integrated into Makefile.am so are a bit old already.

Looking at the main website https://www.doxygen.nl/index.html, there is a
doxygen-projects mailing list that might be appropriate. I think one post
regarding Autotools integration and another post regarding man page enhancement
would be appropriate. How does that sound?

Cheers ... Duncan.
