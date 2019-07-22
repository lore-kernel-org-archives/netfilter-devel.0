Return-Path: <SRS0=3WFO=VT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16F96C76188
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 12:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E77662084D
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 12:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbfGVM4f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jul 2019 08:56:35 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:53304 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727164AbfGVM4f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jul 2019 08:56:35 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hpXrl-0002gk-BS; Mon, 22 Jul 2019 14:56:33 +0200
Date:   Mon, 22 Jul 2019 14:56:33 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] doc: fib: explain example in more detail
Message-ID: <20190722125633.7pgm3glloutr4esj@breakpoint.cc>
References: <20190721104305.29594-1-fw@strlen.de>
 <20190721184212.2fxviqkcil27wzqp@salvia>
 <20190721185432.o2wke7wecfdbyzfr@breakpoint.cc>
 <20190722115756.GH22661@orbyte.nwl.cc>
 <20190722121747.32ve2o3e7luxtwnq@breakpoint.cc>
 <20190722125246.GJ22661@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722125246.GJ22661@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> On Mon, Jul 22, 2019 at 02:17:47PM +0200, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > > use for "no data available" situations. This whole attempt feels a bit
> > > futile. Maybe we should introduce something to signal "no value" so that
> > > cmp expression will never match for '==' and always for '!='? Not sure
> > > how to realize this via registers. Also undecided about '<' and '>' ops.
> > 
> > Whats the point?
> 
> IIRC, Pablo's demand for not aborting in nft_meta in case of
> insufficient data was to insert a value into dreg which will never
> match. I think the idea was to avoid accidental matching in situations
> where a match doesn't make sense.

I think the only contraint is that it must not overlap with a
legitimate ifindex.

But 0 cannot occur, so 'meta iif 0' will only match in case no input
interface existed -- I think thats fine and might even be desired.

> For ifindex or ifname I can't come up with a good example, but let's
> assume we set dreg to 0 for 'meta l4proto' if pkt->tprot is not
> initialized (i.e., pkt->tprot_set is false for whatever reason). A rule
> 'meta l4proto == 0' would start to match even if l4proto of the packet
> is not 0.

Thats my point, we can't use a value that can occur normally.

> Remember, the original problem was that with iptables-legacy, I can do
> '! -i foobar' in POSTROUTING chain and it will always match. With
> iptables-nft, the same rule will never match.

O know.

> Maybe we should just go with fixing for iifname/oifname only and leave
> the rest as-is?

I would propose to go with '0' dreg for ifindex, "" for name and leave
rest as-is.
