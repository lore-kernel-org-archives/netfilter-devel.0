Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7348C07548
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Nov 2023 11:44:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234938AbjKOLoC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Nov 2023 06:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234861AbjKOLoB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Nov 2023 06:44:01 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F64101
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Nov 2023 03:43:57 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id 41be03b00d2f7-5be30d543c4so3267030a12.2
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Nov 2023 03:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700048636; x=1700653436; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n4mz8agYi5TxIiECfU6Wvglwxw6LChIrv6qNiABj85o=;
        b=NTzDsWGt9wBI0owpZF43G4B6tyu4HVE6w5hM+vBnYTdff0x1PJLVyghYRvtaBJf1Ai
         K6+samgJRwVhAn22DuWoYUhFSvovuIAdrosutV2gQrPl9Sac49bBDILRKUgg4JkXYyEM
         mv+WwFNEo3zgq/PO+E/4tUtT6olX1OfiIdorbwtnw2z3c+9O0vitWFHlUa2TCpXPuemU
         s8TNs0hPFOpCRKqLE0j365/esF2I+ouzrESWp0eyQ0KttmylG2TLzcPrIWWfxo0XF4+/
         j6WFKzB82S6Jfn42c2WjO84BBU4qkxZY7e/xYSF6vNtGlZUEStcI3L7nUmANke2BbEpx
         nksw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700048636; x=1700653436;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n4mz8agYi5TxIiECfU6Wvglwxw6LChIrv6qNiABj85o=;
        b=MVOPJeBnxSiAfRYHWvyYXBcWk397HEI4coM7ip19PH9PvqA0f1EwfsiuNA6beYbFU1
         Aynkudjh97/5hEE0A0AIbIV68irl/0jEeAmQ5fj5l7tJSRPj2Lev6vWjPU/TUStpX13z
         x95VJJgyYsKVz0qoyghVveT9aAccn9Bj4/bdSBUEHmZGHb1VvhaCckDJaMbWG5Auj7JE
         RNZQZm0PwJQnGm/yW+4mCnFBJt8Wqt8kF6USUWSv53dx4CTKdAV+nPUO31lhXvPesVOm
         Lu5saYhoyfj6N8ZjXbin9LmTHdp+rpsQwOBwKnOdGra2M7+WnH/lDizku09BeQTwe1Ll
         gp9g==
X-Gm-Message-State: AOJu0Yx5RInJuAvwSJ4jKZBAL812Ur0SPzOstEEoK6MZsq0OqGRrJY/l
        7Xd34BT4sBwDiZ5SVKsTxwU=
X-Google-Smtp-Source: AGHT+IECUs/DNtomOlYD2yHJD7eG6t+4741au793Z3uRxkuuefsRmizxpOXRk4Nrjq/2b48xXNfCFQ==
X-Received: by 2002:a05:6a20:8408:b0:14d:e075:fc5d with SMTP id c8-20020a056a20840800b0014de075fc5dmr11165881pzd.40.1700048636457;
        Wed, 15 Nov 2023 03:43:56 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id ij22-20020a170902ab5600b001c9d011581dsm7428021plb.164.2023.11.15.03.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 03:43:56 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date:   Wed, 15 Nov 2023 22:43:52 +1100
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: libnfnetlink dependency elimination (doc)
Message-ID: <ZVSu+NTsJKP6YgQ1@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20231112065922.3414-1-duncan_roe@optusnet.com.au>
 <ZVORGxjxolo3vnz1@calendula>
 <ZVP9D9KPgMkxLiB/@slk15.local.net>
 <ZVSPBsJOILgw3c0m@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZVSPBsJOILgw3c0m@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 15, 2023 at 10:27:34AM +0100, Pablo Neira Ayuso wrote:
> On Wed, Nov 15, 2023 at 10:04:47AM +1100, Duncan Roe wrote:
> > Hi Pablo,
> >
> > On Tue, Nov 14, 2023 at 04:24:11PM +0100, Pablo Neira Ayuso wrote:
> > > On Sun, Nov 12, 2023 at 05:59:21PM +1100, Duncan Roe wrote:
> > > > Some of these documented changes haven't happened yet.
> > >
> > > Then we have to start by changes first, not the other way around.
> >
> > Yes I know that, obviously:)
> >
> > The point here is that nfnl_rcvbufsiz() has been advertised in the main page of
> > libnetfilter_queue HTML for a long time and there are likely a number of systems
> > out there that use it. When libnfnetlink is removed, libnetfilter_queue will
> > have to provide nfnl_rcvbufsiz() or those systems will start failing.
>
> There is nfq_fd() and setsockopt() that you can use:
>
>         setsockopt(fd, SOL_SOCKET, SO_RCVBUFFORCE, &size, socklen);
>         setsockopt(fd, SOL_SOCKET, SO_RCVBUF, &size, socklen);

Yes
>
> libnfnetlink is **deprecated** and it will be removed at some point,
> the git log shows that it has less and less users.

Good to know
>
> main libnfnetlink users are the libnetfilter_* libraries.

Yes
>
> No new application should be using libnfnetlink in 2023.

Yes

But please see thread starting
> [PATCH libnetfilter_queue] utils: Add example of setting socket buffer size
I meant to send my reply to that email, not this one.

Again sorry for the confusion I've caused.

Cheers ... Duncan.
