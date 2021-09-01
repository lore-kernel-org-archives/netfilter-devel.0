Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5400FC432BE
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Sep 2021 03:23:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27B0161041
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Sep 2021 03:23:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbhIADYg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Aug 2021 23:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbhIADYg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Aug 2021 23:24:36 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430ACC061575
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Aug 2021 20:23:40 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id n18so1313131pgm.12
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Aug 2021 20:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=mMXplOozJKGAK3+itK/koabOFdfRezxsHqj/mkFfI8A=;
        b=Nq+Zu6s5DaPTgYCLvT00KT+b3eJL4Q2FdEo/YEBUGIGgzrfvaff26nCSbA/0hawrK0
         CGh68WDQc5ZBTL871tZ7NWUvJ6SXZyJ7rGGClh9XJUjYnCKjt86RSCWS0Cf+6owDy4a4
         fIe4O+KLM/h+c1S8nrx0CO+EtaG0dckWONT8N+feSxpEe1s6iv8Ql1ajwKEnNAhSsVSD
         jnpXP/DxPBbgVbmRtCxiSEcFJv1ylieDT05PxsLDsLGSmc6G3uzcX2qc7MoT7TYxDwJ0
         01yXtzHtpmleiIT7xWOc3bnRK4CBoT2sf2WKhkLheEd0OcHUS49pivAbfzK+VDJUPM5R
         vbjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=mMXplOozJKGAK3+itK/koabOFdfRezxsHqj/mkFfI8A=;
        b=OHn54hKLZHoHGnF1FfQR1p2z7T+aRWytF8UPBRoTTSOsOOHaVU6FSg61Sgw1TUREUG
         H3J0rwATmamISUSmQ1e/QEDYYEaJko2eETn6QuiOOxPAbF5T6AKnRIm72gHCRlNtXFhW
         aov0wHuQtYLhumAurOZWXYiCYT+zt3ko/8qGRv36utoLb/DRS2MEyqutosnFsX11gnXR
         +cYJN67IghTpCIj/MD4euMbarUYJFNWtdL3u4VFQmdRZ3/J0DhpCia2G+v0WBum1uQYZ
         arnrcOg6xL+7WPeTJkAzm5EOco3Z9xFLHY1pPONNAcYDMYcpAnY8KE60+HOOBLURY5Vi
         c8kw==
X-Gm-Message-State: AOAM533HIkFTAy6NgAiJIGlgJ14OC0EX/GxP2U/5UlDiDsFOhvWaKgiK
        CCQ000Ap3yT7KhGKJg4/vHZB5qS/cz4=
X-Google-Smtp-Source: ABdhPJzfoCxhWuLNjYrBsTNWYPlbwNSF8eZGMTexp52KmjShsUchRAVLwAcvDIOMFMcxJxM9WVyOkw==
X-Received: by 2002:a63:101c:: with SMTP id f28mr29943963pgl.330.1630466619863;
        Tue, 31 Aug 2021 20:23:39 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id e16sm6830852pfj.90.2021.08.31.20.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 20:23:39 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Wed, 1 Sep 2021 13:23:35 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v2] build: doc: Fix NAME entry in man
 pages
Message-ID: <YS7yN5uuAsd9KwZv@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210810024001.12361-1-duncan_roe@optusnet.com.au>
 <20210815121509.GA9606@salvia>
 <YSROzjG3oyIYS6oN@slk1.local.net>
 <YSlEqAnybDgl5FaF@slk1.local.net>
 <20210828092303.GA14065@salvia>
 <20210828094305.GA14556@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210828094305.GA14556@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Aug 28, 2021 at 11:43:05AM +0200, Pablo Neira Ayuso wrote:
>
> I mean: the output of the man pages is looking better than the ones
> that doxygen is autogenerating, is it that doxygen manpage support is
> "basic" as it look without your script?

Essentially ... yes.  Unix man pages are at the end of the list of generated
output formats. HTML and Latex are the headline formats.

Cheers ... Duncan.
