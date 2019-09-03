Return-Path: <SRS0=xNQb=W6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D701C3A5A2
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Sep 2019 19:48:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18A912073F
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Sep 2019 19:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfICTsQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Sep 2019 15:48:16 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:43564 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725962AbfICTsQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Sep 2019 15:48:16 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i5Emf-0004Va-9c; Tue, 03 Sep 2019 21:48:09 +0200
Date:   Tue, 3 Sep 2019 21:48:09 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Leonardo Bras <leonardo@linux.ibm.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 1/2] netfilter: Terminate rule eval if protocol=IPv6
 and ipv6 module is disabled
Message-ID: <20190903194809.GD13660@breakpoint.cc>
References: <20190830181354.26279-1-leonardo@linux.ibm.com>
 <20190830181354.26279-2-leonardo@linux.ibm.com>
 <20190830205802.GS20113@breakpoint.cc>
 <99e3ef9c5ead1c95df697d49ab9cc83a95b0ac7c.camel@linux.ibm.com>
 <20190903164948.kuvtpy7viqhcmp77@salvia>
 <20190903170550.GA13660@breakpoint.cc>
 <20190903193155.v74ws47zcn6zrwpr@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903193155.v74ws47zcn6zrwpr@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > I was expecting we could find a way to handle this from br_netfilter
> > > alone itself.
> > 
> > We can't because we support ipv6 fib lookups from the netdev family
> > as well.
> > 
> > Alternative is to auto-accept ipv6 packets from the nf_tables eval loop,
> > but I think its worse.
> 
> Could we add a restriction for nf_tables + br_netfilter + !ipv6. I
> mean, if this is an IPv6 packet, nf_tables is on and IPv6 module if
> off, then drop this packet?

We could do that from nft_do_chain_netdev().
