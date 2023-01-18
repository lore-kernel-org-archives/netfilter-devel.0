Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03F6DC004D4
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Jan 2023 07:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjARHye (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Jan 2023 02:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjARHx1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2023 02:53:27 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3C830E96
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Jan 2023 23:27:33 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id g68so22760812pgc.11
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Jan 2023 23:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UTAvd/AJkXw0be3T9s4e3ZtaEscrnkZ3OkJ6VbTKIW8=;
        b=VhfoCthSR+G2Miw/q6lCVlVQQcLPw59eh82qq3p2NiJBuwCLOAxLCkIG5lp1Bbansv
         7UxBEWJLyhU32VATung6FBqkIOnuPi95Owz3+BnxaqLt0CNxiLG49gwn2EPuLvnVqcDK
         nr3u0OR0gHy0ihRQr4KTDb8B1wfSQBfRb94PcEBiK1JCCAmUrXhdi0+xssTcaRecwCj3
         ycfs3idJh14hEvO2mzGH6rGtecn46jTCWhC6X6RqWMHy/OzF2mBqtTG2x7XkQHEF/gI0
         ih3TuZAqcSET3oEQZ/sG0bot+Ds0SUDRgAL58980Vq6OglTO0jlZqP1U4yz17GngP7LM
         obKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UTAvd/AJkXw0be3T9s4e3ZtaEscrnkZ3OkJ6VbTKIW8=;
        b=j/XNmGlCX6wVWxzv1NW9pophC7A85VFWCFeyqzykZc2Ha79/0/z8lOw4td0iOJW5Ri
         aEj2IPTAIYHnGsPDqFYeGU7fvcyTXXP6fZKT71ezTkmZUbU7iVNE5NUFp7jlJKEPkceM
         c5cEm4ZhloixL8xqgr/XQ3lGbxKRH0h61RT9F2Z76mdaPv0AZ1gA7yxA94rZPe6V4G/5
         /3mGYg3hjYO/rKN3JCdqWGkC/I1dcwEAqC1fDOZwbNuEVY9y1RqofODD7Qjdl6FS/edb
         u8EgbtrjoJAsbptTe2zzxGtkwAanE6iYvUa6cEx2bcD87T08Tmkk90/lJuhBKdmbM61d
         yFmg==
X-Gm-Message-State: AFqh2koGUSMBgerxkopbWV5Wi8ElaULhkg8YsVeu3GmNGRklH4uQEjVj
        HBRbcKlox7ALNZlQ5codaL/bTxoktOc=
X-Google-Smtp-Source: AMrXdXsOXQQJayCxb5m/lun3MSHaNpOVvdRnY3gjci7c2gdzgDg4mUCX6B8NynRr6qegesGt0BieWA==
X-Received: by 2002:a62:4e8e:0:b0:580:fb8e:3044 with SMTP id c136-20020a624e8e000000b00580fb8e3044mr7298318pfb.22.1674026853144;
        Tue, 17 Jan 2023 23:27:33 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id y206-20020a6264d7000000b0058659177fb8sm19863654pfb.86.2023.01.17.23.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 23:27:32 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date:   Wed, 18 Jan 2023 18:27:28 +1100
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Cc:     Phil Sutter <phil@nwl.cc>, Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] build: put xtables.conf in EXTRA_DIST
Message-ID: <Y8efYM09VTX6L5Yh@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Netfilter Development <netfilter-devel@vger.kernel.org>,
        Phil Sutter <phil@nwl.cc>, Jan Engelhardt <jengelh@inai.de>
References: <20230112225517.31560-1-jengelh@inai.de>
 <Y8FE0vEvtZhY6LCv@orbyte.nwl.cc>
 <Y8U7wlJxOvWK7Vpw@salvia>
 <r841n676-q68o-son2-s819-8p95s57rn8@vanv.qr>
 <Y8bDw54jNb6c/CaO@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8bDw54jNb6c/CaO@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jan 17, 2023 at 04:50:27PM +0100, Phil Sutter wrote:
> On Mon, Jan 16, 2023 at 06:18:34PM +0100, Jan Engelhardt wrote:
> >
> > On Monday 2023-01-16 12:57, Pablo Neira Ayuso wrote:
> > >On Fri, Jan 13, 2023 at 12:47:30PM +0100, Phil Sutter wrote:
> > >
> > >IIRC ebtables is using a custom ethertype file, because definitions
> > >are different there.
> > >
> > >But is this installed file used in any way these days?
> >
> > Probably not; the version I have has this to say:
> >
> > # This list could be found on:
> > #         http://www.iana.org/assignments/ethernet-numbers
> > #         http://www.iana.org/assignments/ieee-802-numbers
> >
> > With such official-ness, ebtables's ethertypes has a rather low priority.
>
> This header statement exists even in legacy ebtables repo' version. I
> fear the opposite is the case and everyone's rather copying from ebtables
> or iptables just to provide /etc/ethertypes without depending on the
> tools.
>
> My local Gentoo install at least has /etc/ethertypes exactly as in
> ebtables repo and the package source states "File extracted from the
> iptables tarball".
>
> Maybe we're the original source?
>
> Cheers, Phil

Slackware distributes /etc/ethertypes from iptables *and* ebtables

Cheers ... Duncan.
