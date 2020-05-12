Return-Path: <SRS0=em6Q=62=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABA5BC54E4A
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 May 2020 13:34:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86E3B206D3
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 May 2020 13:34:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729408AbgELNe7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 May 2020 09:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727783AbgELNe7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 May 2020 09:34:59 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83FDC061A0C
        for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2020 06:34:58 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jYV3h-0007Tq-0g; Tue, 12 May 2020 15:34:57 +0200
Date:   Tue, 12 May 2020 15:34:57 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 2/2] nfnl_osf: Improve error handling
Message-ID: <20200512133456.GJ17795@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200509115200.19480-1-phil@nwl.cc>
 <20200509115200.19480-3-phil@nwl.cc>
 <20200509172807.GA12265@salvia>
 <20200511113112.GC17795@orbyte.nwl.cc>
 <20200512124949.GA23943@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512124949.GA23943@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Tue, May 12, 2020 at 02:49:49PM +0200, Pablo Neira Ayuso wrote:
> On Mon, May 11, 2020 at 01:31:12PM +0200, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Sat, May 09, 2020 at 07:28:07PM +0200, Pablo Neira Ayuso wrote:
> > > On Sat, May 09, 2020 at 01:52:00PM +0200, Phil Sutter wrote:
> > > > For some error cases, no log message was created - hence apart from the
> > > > return code there was no indication of failing execution.
> > > > 
> > > > When loading a line fails, don't abort but continue with the remaining
> > > > file contents. The current pf.os file in this repository serves as
> > > > proof-of-concept: Loading all entries succeeds, but when deleting, lines
> > > > 700, 701 and 704 return ENOENT. Not continuing means the remaining
> > > > entries are not cleared.
> > > 
> > > Did you look at why are these lines returning ENOENT?
> > 
> > If I understand the code right, line 700 is a duplicate of line 698, 701
> > of 699 and 704 of 702. This is because 'W*' parses identical to 'W0' and
> > in right-hand side only the first three text fields (genre, version and
> > subtype) are relevant - the rest is ignored.
> 
> I see, in the userspace parser, W0 and W* are being handled as
> OSF_WSS_PLAIN.
> 
> > When adding, this doesn't become visible because flag NLM_F_EXCL is not
> > specified. If it is, kernel returns EEXISTS for those lines.
> 
> In the kernel, the struct nf_osf_user_finger is used as key to
> identify each line, given they are identical.
> 
> So it looks like this EEXIST has been there since the beginning.
> 
> This patchset LGTM, it's just that the user might get confused if it
> see errors when using this tool, probably turning this into a warning
> is fine.

Yes, at least it's unfortunate that the default fingerprint file
triggers them. We could drop the offending lines, but then again re-sync
with OpenBSD won't be trivial anymore.

From my PoV we may also just ignore the error conditions. Most important
bit here is to not stop on error, at least not when deleting.

> Or at least, include this information in the commit message so this
> does not get lost :-)

Yes, I'll extend the commit message. Thanks for the reminder.

Cheers, Phil
