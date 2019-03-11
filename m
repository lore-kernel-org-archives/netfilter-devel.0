Return-Path: <SRS0=8PdD=RO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E1FC10F06
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 11:08:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 362522075C
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 11:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfCKLIj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 07:08:39 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34491 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbfCKLIj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 07:08:39 -0400
Received: from cpe-2606-a000-111b-405a-9816-2c85-c514-8f7a.dyn6.twc.com ([2606:a000:111b:405a:9816:2c85:c514:8f7a] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1h3In7-0006ei-GH; Mon, 11 Mar 2019 07:08:33 -0400
Date:   Mon, 11 Mar 2019 07:07:52 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Xin Long <lucien.xin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH net] netfilter: set skb transport_header before calling
 sctp_compute_cksum
Message-ID: <20190311110752.GA30241@hmswarspite.think-freely.org>
References: <740683890e28e93c1b2e940a28089ca10f006b7f.1551601041.git.lucien.xin@gmail.com>
 <20190308155049.by7f4uzjxqnf3xu7@salvia>
 <CADvbK_djd5ckv3nTROsmHNdr0Z5ULt7MF3MXtNYAO58mo+po7Q@mail.gmail.com>
 <20190309092434.oflik6j57yrhpkh5@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190309092434.oflik6j57yrhpkh5@breakpoint.cc>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Mar 09, 2019 at 10:24:34AM +0100, Florian Westphal wrote:
> Xin Long <lucien.xin@gmail.com> wrote:
> >   https://marc.info/?l=linux-netdev&m=155109395226858&w=2
> > But from sctp side, Neil preferred sctp_hdr().
> > 
> > We need to either add skb_set_transport_header() in sctp_s/dnat_handler()
> > and sctp_manip_pkt(), or bring that patch back?
> > 
> > Now it seems not good to set skb->transport_header in netfilter code.
> 
> I think its fine, but I wonder why we need to do it.
> 
> Since 21d1196a35f5686c4323e42a62fdb4b23b0ab4a3 ipv4 input path sets
> transport header before netfilter.  The only problem is that linear
> access is illegal without may_pull checks, but in this case the
> make_writable call takes care of this already.
> 
Yes, this.  It seems to me we should be setting the transport header prior to
ever getting into the netfilter code, which does imply that we need the may_pull
check to linearize enough of the packet to do so, just like tcp and udp do.

> So, why was this patch needed?
> If we need it, do we also need to add it in other locations that
> deal with sctp csum (e.g. in ipvs?).
> 
This is a fair question, and I'm not yet sure of the answer.

> Thanks,
> Florian
> 
