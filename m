Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84BF6C4167E
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Feb 2022 11:30:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347097AbiBHLaK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Feb 2022 06:30:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343625AbiBHJ5s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Feb 2022 04:57:48 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13873C03FEC0
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Feb 2022 01:57:47 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nHNFo-0002ih-4t; Tue, 08 Feb 2022 10:57:44 +0100
Date:   Tue, 8 Feb 2022 10:57:44 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 1/2] nft: Use verbose flag to toggle debug output
Message-ID: <YgI+mJBFuYwHysfe@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220128203700.27071-1-phil@nwl.cc>
 <YgFevUBNBFagWjMx@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgFevUBNBFagWjMx@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Feb 07, 2022 at 07:02:37PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Jan 28, 2022 at 09:36:59PM +0100, Phil Sutter wrote:
[...]
> > -static void nft_chain_print_debug(struct nftnl_chain *c, struct nlmsghdr *nlh)
> > +static void nft_chain_print_debug(struct nft_handle *h,
> > +				  struct nftnl_chain *c, struct nlmsghdr *nlh)
> >  {
> > -#ifdef NLDEBUG
> > -	char tmp[1024];
> > -
> > -	nftnl_chain_snprintf(tmp, sizeof(tmp), c, 0, 0);
> > -	printf("DEBUG: chain: %s\n", tmp);
> > -	mnl_nlmsg_fprintf(stdout, nlh, nlh->nlmsg_len, sizeof(struct nfgenmsg));
> > -#endif
> > +	if (h->verbose > 1) {
> > +		nftnl_chain_fprintf(stdout, c, 0, 0);
> > +		fprintf(stdout, "\n");
> > +	}
> > +	if (h->verbose > 2)
> > +		mnl_nlmsg_fprintf(stdout, nlh, nlh->nlmsg_len,
> > +				  sizeof(struct nfgenmsg));
> 
> OK, so -v is netlink byte printing and -vv means print netlink message
> too. LGTM.

-v is "normal verbose output", -vv is also nftnl debug and -vvv is also
netlink message dump.

> I'd mention this in the commit description before applying.

Your comment is proof this needs better documentation! :D
Guess I'll describe the behaviour in iptables man page as well.

Thanks, Phil
