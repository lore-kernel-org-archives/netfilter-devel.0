Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF453C433ED
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Apr 2021 06:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C59F61104
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Apr 2021 06:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhDBGri (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Apr 2021 02:47:38 -0400
Received: from mail.netfilter.org ([217.70.188.207]:54490 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhDBGrh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Apr 2021 02:47:37 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 929B363E3E;
        Fri,  2 Apr 2021 08:47:19 +0200 (CEST)
Date:   Fri, 2 Apr 2021 08:47:32 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] nft: Increase BATCH_PAGE_SIZE to support huge
 rulesets
Message-ID: <20210402064732.GA25286@salvia>
References: <20210401145307.29927-1-phil@nwl.cc>
 <20210402053810.GI13699@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210402053810.GI13699@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Apr 02, 2021 at 07:38:10AM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > In order to support the same ruleset sizes as legacy iptables, the
> > kernel's limit of 1024 iovecs has to be overcome. Therefore increase
> > each iovec's size from 256KB to 4MB.
> > 
> > While being at it, add a log message for failing sendmsg() call. This is
> > not supposed to happen, even if the transaction fails. Yet if it does,
> > users are left with only a "line XXX failed" message (with line number
> > being the COMMIT line).
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  iptables/nft.c | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/iptables/nft.c b/iptables/nft.c
> > index bd840e75f83f4..e19c88ece6c2a 100644
> > --- a/iptables/nft.c
> > +++ b/iptables/nft.c
> > @@ -88,11 +88,11 @@ int mnl_talk(struct nft_handle *h, struct nlmsghdr *nlh,
> >  
> >  #define NFT_NLMSG_MAXSIZE (UINT16_MAX + getpagesize())
> >  
> > -/* selected batch page is 256 Kbytes long to load ruleset of
> > - * half a million rules without hitting -EMSGSIZE due to large
> > - * iovec.
> > +/* Selected batch page is 4 Mbytes long to support loading a ruleset of 3.5M
> > + * rules matching on source and destination address as well as input and output
> > + * interfaces. This is what legacy iptables supports.
> >   */
> > -#define BATCH_PAGE_SIZE getpagesize() * 32
> > +#define BATCH_PAGE_SIZE getpagesize() * 512
> 
> Why not remove getpagesize() altogether?
> 
> The comment assumes getpagesize returns 4096 so might as well just use
> "#define BATCH_PAGE_SIZE  (4 * 1024 * 1024)" or similar?

Agreed.

> On my system getpagesize() * 512 yields 2097152 ...
>
> >  static struct nftnl_batch *mnl_batch_init(void)
> >  {
> > @@ -220,8 +220,10 @@ static int mnl_batch_talk(struct nft_handle *h, int numcmds)
> >  	int err = 0;
> >  
> >  	ret = mnl_nft_socket_sendmsg(h, numcmds);
> > -	if (ret == -1)
> > +	if (ret == -1) {
> > +		fprintf(stderr, "sendmsg() failed: %s\n", strerror(errno));
> >  		return -1;
> > +	}
> 
> Isn't that library code?  At the very least this should use
> nft_print().

I'm not sure this update is required. EMSGSIZE should only come from
sendmsg() in the mnl_batch_talk() path.
