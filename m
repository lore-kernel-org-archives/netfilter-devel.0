Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08007C4338F
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Aug 2021 01:43:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D497C6120A
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Aug 2021 01:43:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbhHXBob (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Aug 2021 21:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232186AbhHXBob (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Aug 2021 21:44:31 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54553C061575
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Aug 2021 18:43:48 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id a21so16941447pfh.5
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Aug 2021 18:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=1uksIB/qLdY1YOaoCJGZ+9Xaq+OJvGpEM5lAxxJpsfI=;
        b=mbPjMZgS/r884p2Ei7l11i/6I+YXxFtBRMgw+47D3/6dh7C2jsm0fkCUenZSIzzxay
         a1puGcJ7srEy89gLt7LEqgU9iO4PoGncR9FYtpPkVBwjeLUB5Kg3wzvLOjVNhFHkNLL0
         ERyDkG69pbHu0IZiOJvsg/GKiUD3f2SMVoH9cpTh4hectS2UENS8rNaGwY9GDFwW5Apt
         6NUXJOvyDxNZf86CYPn/w2sya4wrWz/+jnOjwjdm5K0BAcEKwXyHpqlS8w6rWJZ3aFB1
         8u1p1bGXI6iru6LOojRgx9yg6zOEXPkIviaivC/YdJBQCtU3EYfY4mLFkIpwAvLT7Eav
         1JDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=1uksIB/qLdY1YOaoCJGZ+9Xaq+OJvGpEM5lAxxJpsfI=;
        b=ZTBcZFDYDyy79RGEJmoTBu4/+4Hia7hV4C2MHCkZ6Yi8Gqr4M/D5/Wx4xaDMwPFw04
         RU6TTdNxY1hfbwVApxLrjBLLo7wQbjeGPCECWNUmSqy8HTw/miOg49+912ki85F432fd
         XMkLETujTKRUEqmtfus6mbyd3IosPTjJ4rRqZjQCTKqNzaNYgqrMBTgdE5XQxfjrY9W9
         YJazoxLcF0SoIVswhRSdmkHMU3u5a6kDHsQqJFf4Mjb3KahLGT3BHKMbHoeys4izqwmn
         J1oxli/F2r04I7F3+96a2M0uVtCBmH3cdJl9g9XaFXnZSdDoEYZnxOWv7g3DEwpoX8PX
         EZUQ==
X-Gm-Message-State: AOAM531bCFR4hx97O4R9vUiyrh2UTXXiCH1FkG1QPKC0ljLM2fNcJc0I
        wzcA559SD+VOAUA8/BXanaA/5xjPyxCQQw==
X-Google-Smtp-Source: ABdhPJwkOBsrVSwcyRQAFoVN5BukJWf60EPuWiNdEbys/bBOlmPO43Cnl4PUpmdUQPZ1NjzonvrPgg==
X-Received: by 2002:a62:778e:0:b0:3ea:e8fe:d0c7 with SMTP id s136-20020a62778e000000b003eae8fed0c7mr21066673pfc.21.1629769427782;
        Mon, 23 Aug 2021 18:43:47 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id p9sm17238088pfn.97.2021.08.23.18.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 18:43:46 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Tue, 24 Aug 2021 11:43:42 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v2] build: doc: Fix NAME entry in man
 pages
Message-ID: <YSROzjG3oyIYS6oN@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210810024001.12361-1-duncan_roe@optusnet.com.au>
 <20210815121509.GA9606@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210815121509.GA9606@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Aug 15, 2021 at 02:15:09PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Aug 10, 2021 at 12:40:01PM +1000, Duncan Roe wrote:
> > Make the NAME line list the functions defined, like other man pages do.
> > Also:
> > - If there is a "Modules" section, delete it
> > - If "Detailed Description" is empty, delete "Detailed Description" line
> > - Reposition SYNOPSIS (with headers that we inserted) to start of page,
> >   integrating with defined functions to look like other man pages
> > - Delete all "Definition at line nnn" lines
> > - Delete lines that make older versions of man o/p an unwanted blank line
> > - Insert spacers and comments so Makefile.am is more readable
> >
> > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> > ---
> > v2: Delete lines that make older versions of man o/p an unwanted blank line
> >  doxygen/Makefile.am | 172 ++++++++++++++++++++++++++++++++++++++++++++
>
> Time to add this to an independent fixup shell script for
> doxygen-based manpages that Makefile.am could call instead?

There is an independent fixup shell script at v4
>
> This script could be imported by other libraries too, so it only needs to
> be downloaded from somewhere to be refreshed to keep it in sync with
> latest.

Please do not wait for this to happen. As I gain familiarity with autotools,
there will be more and more incremental updates.

So you can review them easily, I'll try to keep each patch doing just one thing.
But that means more patches, so can you just apply one of the patch series so we
don't get too far behind?
>
> The git tree could cache a copy of this script.

Here's a possible mechanism, but it needs there to be a new netfilter git
project: how would you be with that?

 - autogen.sh does `git clone libnetfilter_doc`
 - autogen.sh distributes the files(*) in libnetfilter_doc to wherever they go
   in the current source tree
 - autogen.sh deletes libnetfilter_doc/

This approach has the advantage that `make distcheck` tarballs are complete,
i.e. don't require a working network to build.

For best results, update doxygen comments in the source to contain SYNOPSIS
sections.

(*) as well as build_man.sh, most of configure.ac is boilerplate and could be
encapsulated in 1 or more m4 macros to reside in libnetfilter_doc. Also most of
doxygen.cfg.in could go there, with local variations in doxygen.cfg.local (at
least EXCLUDE_SYMBOLS, maybe nothing else).

Cheers ... Duncan.
