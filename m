Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C59ACC432BE
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Aug 2021 20:01:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F69960F92
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Aug 2021 20:01:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbhH0UCk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Aug 2021 16:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbhH0UCk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Aug 2021 16:02:40 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C146C0613D9
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Aug 2021 13:01:51 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id z24-20020a17090acb1800b0018e87a24300so5604828pjt.0
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Aug 2021 13:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=jHOql/xL4RFZXXnzQpmSC6RDlJhkGTh2psqM48nO9Ko=;
        b=TCVAT4QeQ3lNjkUa42YQ/D+HbwqccLSc/3IWplyEgDBdYhRweZsp71zDqMv/GEHteb
         CN39NdW4DTfEFiiw9ZSIY4t202za1rswii4Vth28Sa1aGs6bn9ZKwHUsFwz7xrLpfl9l
         9ZxCASOmM14IpNlC9hXQWS+ahA9IyJ4btSoqv0XxFIZnKbdwJ1Lsm9I7RH7iOZZEAzsw
         1fOzet3nGoVBq6uN4rOZpvE+y+X5P3GjETVrTaI0YU5f91VuPG+Cjq6CXe3FsccqreQd
         itM3X2zNlmnCaXb0ZDhvXp8qwvoalJNmDBUO3gmgNDKACxovwxrXkzRbBKYBJk7PNuY4
         BHGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=jHOql/xL4RFZXXnzQpmSC6RDlJhkGTh2psqM48nO9Ko=;
        b=CiS/IwbLTrgpNs2pjxKHu3OqdDzt+/UmVgY8u9LDFa8dftyD9O5N3vSbK8IClnXuOe
         U3cAWLGUqcQrvDvPyT+Y/wEXMgmbb1ESV4updzyn+Y7MZ7sOA703QU2ctK3rSw6W3vq0
         dFNnBYcJL3ykV/HXFTYT25QjBe9T2jgosuvIFDaFL1UyzxfwNwkLV3DhEA1c/R+tJN5I
         79CJhEapWviFPPCVbW4+blXvrItgB4l3WX43f11Zj5hOjYYl7gwj1quPP+KmRZ/wgVIJ
         fsFB79e/d2/N8Epvj5hzAZsEUeul4Dg4nHCGrC6srtyekL72XkEQFKPnsz0bFqhBffhD
         A9jw==
X-Gm-Message-State: AOAM5331ihHhpYuuC3cVccClvAmJPTJmUaZ4UugPWCDI4reMKG7NDLBS
        lOSWS1BQNa6rgvw2FiXs0shd0pdmgDs=
X-Google-Smtp-Source: ABdhPJwtyWLYdKnqPTHIzwG/5ULZcUBmzPGlz3dj+T70vxhfU/eKWKEoAfx/NRexGk7ofd5JwyCZmQ==
X-Received: by 2002:a17:902:8346:b0:131:bb78:7a9e with SMTP id z6-20020a170902834600b00131bb787a9emr10171325pln.28.1630094510631;
        Fri, 27 Aug 2021 13:01:50 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id u62sm7128492pfc.68.2021.08.27.13.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 13:01:49 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Sat, 28 Aug 2021 06:01:44 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v2] build: doc: Fix NAME entry in man
 pages
Message-ID: <YSlEqAnybDgl5FaF@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210810024001.12361-1-duncan_roe@optusnet.com.au>
 <20210815121509.GA9606@salvia>
 <YSROzjG3oyIYS6oN@slk1.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSROzjG3oyIYS6oN@slk1.local.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 24, 2021 at 11:43:42AM +1000, Duncan Roe wrote:
> On Sun, Aug 15, 2021 at 02:15:09PM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Aug 10, 2021 at 12:40:01PM +1000, Duncan Roe wrote:
> > > Make the NAME line list the functions defined, like other man pages do.
> > > Also:
> > > - If there is a "Modules" section, delete it
> > > - If "Detailed Description" is empty, delete "Detailed Description" line
> > > - Reposition SYNOPSIS (with headers that we inserted) to start of page,
> > >   integrating with defined functions to look like other man pages
> > > - Delete all "Definition at line nnn" lines
> > > - Delete lines that make older versions of man o/p an unwanted blank line
> > > - Insert spacers and comments so Makefile.am is more readable
> > >
> > > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> > > ---
> > > v2: Delete lines that make older versions of man o/p an unwanted blank line
> > >  doxygen/Makefile.am | 172 ++++++++++++++++++++++++++++++++++++++++++++
> >
> > Time to add this to an independent fixup shell script for
> > doxygen-based manpages that Makefile.am could call instead?
>
> There is an independent fixup shell script at v4
> >
> > This script could be imported by other libraries too, so it only needs to
> > be downloaded from somewhere to be refreshed to keep it in sync with
> > latest.
>
> Please do not wait for this to happen. As I gain familiarity with autotools,
> there will be more and more incremental updates.
>
> So you can review them easily, I'll try to keep each patch doing just one thing.
> But that means more patches, so can you just apply one of the patch series so we
> don't get too far behind?
> >
> > The git tree could cache a copy of this script.
>
> Here's a possible mechanism, but it needs there to be a new netfilter git
> project: how would you be with that?
>
>  - autogen.sh does `git clone libnetfilter_doc`
>  - autogen.sh distributes the files(*) in libnetfilter_doc to wherever they go
>    in the current source tree
>  - autogen.sh deletes libnetfilter_doc/
>
> This approach has the advantage that `make distcheck` tarballs are complete,
> i.e. don't require a working network to build.
>
> For best results, update doxygen comments in the source to contain SYNOPSIS
> sections.
>
> (*) as well as build_man.sh, most of configure.ac is boilerplate and could be
> encapsulated in 1 or more m4 macros to reside in libnetfilter_doc. Also most of
> doxygen.cfg.in could go there, with local variations in doxygen.cfg.local (at
> least EXCLUDE_SYMBOLS, maybe nothing else).


No need for a new git project. curl can fetch files from libnfq. E.g.
> curl https://git.netfilter.org/libnetfilter_queue/plain/doxygen/Makefile.am
fetches Makefile.am.

Same for doxygen/build_man.sh, once the patches are applied. autogen.sh would
run the curl commands.

Cheers ... Duncan.
