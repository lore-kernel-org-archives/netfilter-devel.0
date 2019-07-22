Return-Path: <SRS0=3WFO=VT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65E7BC76188
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 12:52:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46330218F0
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 12:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbfGVMws (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jul 2019 08:52:48 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45800 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbfGVMws (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jul 2019 08:52:48 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hpXo6-0002GC-DL; Mon, 22 Jul 2019 14:52:46 +0200
Date:   Mon, 22 Jul 2019 14:52:46 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] doc: fib: explain example in more detail
Message-ID: <20190722125246.GJ22661@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190721104305.29594-1-fw@strlen.de>
 <20190721184212.2fxviqkcil27wzqp@salvia>
 <20190721185432.o2wke7wecfdbyzfr@breakpoint.cc>
 <20190722115756.GH22661@orbyte.nwl.cc>
 <20190722121747.32ve2o3e7luxtwnq@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722121747.32ve2o3e7luxtwnq@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 22, 2019 at 02:17:47PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > use for "no data available" situations. This whole attempt feels a bit
> > futile. Maybe we should introduce something to signal "no value" so that
> > cmp expression will never match for '==' and always for '!='? Not sure
> > how to realize this via registers. Also undecided about '<' and '>' ops.
> 
> Whats the point?

IIRC, Pablo's demand for not aborting in nft_meta in case of
insufficient data was to insert a value into dreg which will never
match. I think the idea was to avoid accidental matching in situations
where a match doesn't make sense.

For ifindex or ifname I can't come up with a good example, but let's
assume we set dreg to 0 for 'meta l4proto' if pkt->tprot is not
initialized (i.e., pkt->tprot_set is false for whatever reason). A rule
'meta l4proto == 0' would start to match even if l4proto of the packet
is not 0.

Remember, the original problem was that with iptables-legacy, I can do
'! -i foobar' in POSTROUTING chain and it will always match. With
iptables-nft, the same rule will never match.

Maybe we should just go with fixing for iifname/oifname only and leave
the rest as-is?

Cheers, Phil
