Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAAAFC433B4
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Apr 2021 10:23:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B32816121E
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Apr 2021 10:23:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236214AbhDCKXn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 3 Apr 2021 06:23:43 -0400
Received: from mail.netfilter.org ([217.70.188.207]:56522 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236484AbhDCKXm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 3 Apr 2021 06:23:42 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8F46763E4A;
        Sat,  3 Apr 2021 12:23:22 +0200 (CEST)
Date:   Sat, 3 Apr 2021 12:23:36 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] nft: Increase BATCH_PAGE_SIZE to support huge
 rulesets
Message-ID: <20210403102336.GA30107@salvia>
References: <20210401145307.29927-1-phil@nwl.cc>
 <20210402053810.GI13699@breakpoint.cc>
 <20210403084940.GA3158@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210403084940.GA3158@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Apr 03, 2021 at 10:49:40AM +0200, Phil Sutter wrote:
> Hi,
> 
> On Fri, Apr 02, 2021 at 07:38:10AM +0200, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > > In order to support the same ruleset sizes as legacy iptables, the
> > > kernel's limit of 1024 iovecs has to be overcome. Therefore increase
> > > each iovec's size from 256KB to 4MB.
> > > 
> > > While being at it, add a log message for failing sendmsg() call. This is
> > > not supposed to happen, even if the transaction fails. Yet if it does,
> > > users are left with only a "line XXX failed" message (with line number
> > > being the COMMIT line).
> > > 
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > ---
> > >  iptables/nft.c | 12 +++++++-----
> > >  1 file changed, 7 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/iptables/nft.c b/iptables/nft.c
> > > index bd840e75f83f4..e19c88ece6c2a 100644
> > > --- a/iptables/nft.c
> > > +++ b/iptables/nft.c
> > > @@ -88,11 +88,11 @@ int mnl_talk(struct nft_handle *h, struct nlmsghdr *nlh,
> > >  
> > >  #define NFT_NLMSG_MAXSIZE (UINT16_MAX + getpagesize())
> > >  
> > > -/* selected batch page is 256 Kbytes long to load ruleset of
> > > - * half a million rules without hitting -EMSGSIZE due to large
> > > - * iovec.
> > > +/* Selected batch page is 4 Mbytes long to support loading a ruleset of 3.5M
> > > + * rules matching on source and destination address as well as input and output
> > > + * interfaces. This is what legacy iptables supports.
> > >   */
> > > -#define BATCH_PAGE_SIZE getpagesize() * 32
> > > +#define BATCH_PAGE_SIZE getpagesize() * 512
> > 
> > Why not remove getpagesize() altogether?
> 
> Yes, why not. At least I couldn't find a reason in git log why it's
> there in the first place.
> 
> > The comment assumes getpagesize returns 4096 so might as well just use
> > "#define BATCH_PAGE_SIZE  (4 * 1024 * 1024)" or similar?
> > 
> > On my system getpagesize() * 512 yields 2097152 ...
> 
> Thanks for digging deeper, my comment was wrong. I believed the old
> comment and assumed getpagesize() would return 256k / 32 = 8k but indeed
> it returns 4k.

NLMSG_GOODSIZE is not exposed to userspace, I was using it as
reference. NLMSG_GOODSIZE is PAGE_SIZE.
