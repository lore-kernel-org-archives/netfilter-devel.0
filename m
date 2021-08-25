Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3023C4338F
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Aug 2021 04:15:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7F676128A
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Aug 2021 04:15:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbhHYEP4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Aug 2021 00:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbhHYEP4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 00:15:56 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F7EC061757
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Aug 2021 21:15:10 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id w8so21831421pgf.5
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Aug 2021 21:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=LG2Mbl5uGwROh+E6eebLmrF4CfIqKafSj8IuIPmOILY=;
        b=qj9MZNmLyHXECI7PthkaynWw/Y7KEfjoqB31HgOAGYKeNb6bq75aQEQ4UM3KJUoYeb
         gX8bw6QR/Sg1q6ktJY/U1+lqRZ0NhUhGCJOLzGqGNmrMwBNkTNunlCwFXF8FXUb6hv9i
         rhbeNk56/DFLaxn9Nn2RDwkBBfoaQm7qP+xlWQcH/KtS+mhAgp6MbCMK/bDx3Mkv95dS
         PtSZYt5St833KwFNm4G2L6P3jDi8XFCHgIXpc+t8hhZewquTJVamlHQTJltVmsF1pidx
         SnK+HLkA9JfKf/Vovpd6xIO2C10JEE6Qi7NFvDzj0FVaNTCY8PQnvPQkhrJfOBcVIa5A
         8Pug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=LG2Mbl5uGwROh+E6eebLmrF4CfIqKafSj8IuIPmOILY=;
        b=DBYyxZPPlULwQFMLHGbwrLm1jb6z5wXx0qs9FiigX3t7/FRxytpjuivjX8INQ8T9Ds
         to3yyfMaAFMDOQmG6fPQEuIXt+kVVE+Y0RvuwFPMxB4nmenZvuVfCrwpeyTePMz8jMzE
         +gi3ONEezINncO3wQddcSL1QbdwFa8ITKK0MIeVXyV07HAysvbm6pyCykD54zBssQzMh
         4qQ9B4efM/GfTd1ndFRor0ziX5wzeqIAJPpteJ3fa7ImuKTOJDc/L12u3H0YXrbt9+1v
         kgtShXoPzlSI/f0wwX+z4UaqeMIrLTpaEloxZBivl++95oVeZ+rohxjIqpqquEum46ks
         SlTw==
X-Gm-Message-State: AOAM531D7YwR1GL0pIwAyBdaM6rDsfVc9Lj3+Qn7Dikcrn7WgtAQuhB1
        Nz/cUasfPY2yWjTMZTKrd2U=
X-Google-Smtp-Source: ABdhPJzaob03Xrkjyr+vI5GIJUMlDr/AfasbveHrV/cKJeYNKJq+fBKQCB/vja+juwr1WoOw84eNvw==
X-Received: by 2002:a05:6a00:ac8:b029:320:a6bb:880d with SMTP id c8-20020a056a000ac8b0290320a6bb880dmr42690013pfl.41.1629864910252;
        Tue, 24 Aug 2021 21:15:10 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id r14sm20555108pff.106.2021.08.24.21.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 21:15:09 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Wed, 25 Aug 2021 14:15:05 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v4 4/4] build: doc: split off shell
 script from within doxygen/Makefile.am
Message-ID: <YSXDyR2RIKf675l6@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210822041442.8394-1-duncan_roe@optusnet.com.au>
 <20210822041442.8394-4-duncan_roe@optusnet.com.au>
 <20210824103052.GC30322@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824103052.GC30322@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 24, 2021 at 12:30:52PM +0200, Pablo Neira Ayuso wrote:
> On Sun, Aug 22, 2021 at 02:14:42PM +1000, Duncan Roe wrote:
> > This time, Makefile obeys the script via its absolute source pathname rather
> > than trying to force a copy into the build dir as we did previously.
>
> Could you make this in first place? As coming 1/x coming in this
> series.
>
> Thanks.

Time to wrap up the whole lot in a single patch.

v5 was going to remove the make distcheck cruft in doxygen/Makefile.am, which is
adjacent to the now-removed embedded script. So now there is juat 1 big block of
red.

I reverted some non-essential changes in configure.ac to reduce the diff.

The new patch will be titled "Fix man pages".

I hope you like it,

Cheers ... Duncan.
