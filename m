Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E17FC432BE
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 09:43:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35D8060EE9
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 09:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbhH1JoH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 28 Aug 2021 05:44:07 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49668 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233554AbhH1JoB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 28 Aug 2021 05:44:01 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id E485060049
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Aug 2021 11:42:12 +0200 (CEST)
Date:   Sat, 28 Aug 2021 11:43:05 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v2] build: doc: Fix NAME entry in man
 pages
Message-ID: <20210828094305.GA14556@salvia>
References: <20210810024001.12361-1-duncan_roe@optusnet.com.au>
 <20210815121509.GA9606@salvia>
 <YSROzjG3oyIYS6oN@slk1.local.net>
 <YSlEqAnybDgl5FaF@slk1.local.net>
 <20210828092303.GA14065@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210828092303.GA14065@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Aug 28, 2021 at 11:23:03AM +0200, Pablo Neira Ayuso wrote:
> On Sat, Aug 28, 2021 at 06:01:44AM +1000, Duncan Roe wrote:
> > On Tue, Aug 24, 2021 at 11:43:42AM +1000, Duncan Roe wrote:
> > > On Sun, Aug 15, 2021 at 02:15:09PM +0200, Pablo Neira Ayuso wrote:
> > > > On Tue, Aug 10, 2021 at 12:40:01PM +1000, Duncan Roe wrote:
> > > > > Make the NAME line list the functions defined, like other man pages do.
> > > > > Also:
> > > > > - If there is a "Modules" section, delete it
> > > > > - If "Detailed Description" is empty, delete "Detailed Description" line
> > > > > - Reposition SYNOPSIS (with headers that we inserted) to start of page,
> > > > >   integrating with defined functions to look like other man pages
> > > > > - Delete all "Definition at line nnn" lines
> > > > > - Delete lines that make older versions of man o/p an unwanted blank line
> > > > > - Insert spacers and comments so Makefile.am is more readable
> > > > >
> > > > > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> > > > > ---
> > > > > v2: Delete lines that make older versions of man o/p an unwanted blank line
> > > > >  doxygen/Makefile.am | 172 ++++++++++++++++++++++++++++++++++++++++++++
> > > >
> > > > Time to add this to an independent fixup shell script for
> > > > doxygen-based manpages that Makefile.am could call instead?
> > >
> > > There is an independent fixup shell script at v4
> > > >
> > > > This script could be imported by other libraries too, so it only needs to
> > > > be downloaded from somewhere to be refreshed to keep it in sync with
> > > > latest.
> > >
> > > Please do not wait for this to happen. As I gain familiarity with autotools,
> > > there will be more and more incremental updates.
> > >
> > > So you can review them easily, I'll try to keep each patch doing just one thing.
> > > But that means more patches, so can you just apply one of the patch series so we
> > > don't get too far behind?
> > > >
> > > > The git tree could cache a copy of this script.
> > >
> > > Here's a possible mechanism, but it needs there to be a new netfilter git
> > > project: how would you be with that?
> > >
> > >  - autogen.sh does `git clone libnetfilter_doc`
> > >  - autogen.sh distributes the files(*) in libnetfilter_doc to wherever they go
> > >    in the current source tree
> > >  - autogen.sh deletes libnetfilter_doc/
> > >
> > > This approach has the advantage that `make distcheck` tarballs are complete,
> > > i.e. don't require a working network to build.
> > >
> > > For best results, update doxygen comments in the source to contain SYNOPSIS
> > > sections.
> > >
> > > (*) as well as build_man.sh, most of configure.ac is boilerplate and could be
> > > encapsulated in 1 or more m4 macros to reside in libnetfilter_doc. Also most of
> > > doxygen.cfg.in could go there, with local variations in doxygen.cfg.local (at
> > > least EXCLUDE_SYMBOLS, maybe nothing else).
> > 
> > 
> > No need for a new git project. curl can fetch files from libnfq. E.g.
> > > curl https://git.netfilter.org/libnetfilter_queue/plain/doxygen/Makefile.am
> > fetches Makefile.am.
> > 
> > Same for doxygen/build_man.sh, once the patches are applied. autogen.sh would
> > run the curl commands.
> 
> autogen.sh to resync this script should be fine.
> 
> Did you consider to send some feedback to doxygen developers? Probably
> enhancing \manonly including sections (ie. \manonly{synopsis}) would
> be the way to go? I guess that would be more work upstream, but
> everyone would benefit from this.
> 
> Anyway, your build_man.sh script is starting to look nicer, thanks.

I mean: the output of the man pages is looking better than the ones
that doxygen is autogenerating, is it that doxygen manpage support is
"basic" as it look without your script?
