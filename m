Return-Path: <SRS0=3WFO=VT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E77C2C76188
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 13:06:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDED0216C8
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 13:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbfGVNG0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jul 2019 09:06:26 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:53364 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727360AbfGVNG0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jul 2019 09:06:26 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hpY1I-0002jf-GG; Mon, 22 Jul 2019 15:06:24 +0200
Date:   Mon, 22 Jul 2019 15:06:24 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] doc: fib: explain example in more detail
Message-ID: <20190722130624.lbyjngxcxho6znpw@breakpoint.cc>
References: <20190721104305.29594-1-fw@strlen.de>
 <20190721184212.2fxviqkcil27wzqp@salvia>
 <20190721185432.o2wke7wecfdbyzfr@breakpoint.cc>
 <20190722115756.GH22661@orbyte.nwl.cc>
 <20190722121747.32ve2o3e7luxtwnq@breakpoint.cc>
 <20190722125246.GJ22661@orbyte.nwl.cc>
 <20190722125633.7pgm3glloutr4esj@breakpoint.cc>
 <20190722130259.GK22661@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722130259.GK22661@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> On Mon, Jul 22, 2019 at 02:56:33PM +0200, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > > On Mon, Jul 22, 2019 at 02:17:47PM +0200, Florian Westphal wrote:
> > > > Phil Sutter <phil@nwl.cc> wrote:
> > > > > use for "no data available" situations. This whole attempt feels a bit
> > > > > futile. Maybe we should introduce something to signal "no value" so that
> > > > > cmp expression will never match for '==' and always for '!='? Not sure
> > > > > how to realize this via registers. Also undecided about '<' and '>' ops.
> > > > 
> > > > Whats the point?
> > > 
> > > IIRC, Pablo's demand for not aborting in nft_meta in case of
> > > insufficient data was to insert a value into dreg which will never
> > > match. I think the idea was to avoid accidental matching in situations
> > > where a match doesn't make sense.
> > 
> > I think the only contraint is that it must not overlap with a
> > legitimate ifindex.
> > 
> > But 0 cannot occur, so 'meta iif 0' will only match in case no input
> > interface existed -- I think thats fine and might even be desired.
> 
> OK, so we just drop my patch to reject ifindex 0 from userspace to keep
> fib working?
> 
> [...]
> > I would propose to go with '0' dreg for ifindex, "" for name and leave
> > rest as-is.
> 
> My kernel patch also changes iftype to set ARPHRD_VOID and ifkind to set
> an empty string as well.

I would keep both with current semantics, i.e. 'break'/no match until we
get more evidence that we need this ARPHDR_VOID store.

For iifkind, I am not sure.  Perhaps leave it as-is?

Kernel doesn't allow "" iifname (so we can reuse it for 'no interface'),
but what about ifkind?

> For iftype, I also sent a userspace patch to disallow ARPHRD_VOID. Do
> you think it should be dropped as well?

I think we should leave userspace alone.
