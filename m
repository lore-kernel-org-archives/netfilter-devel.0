Return-Path: <SRS0=hqFW=WY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB31C3A5A4
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Aug 2019 10:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0A8C2189D
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Aug 2019 10:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfH1KR1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Aug 2019 06:17:27 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:43672 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727055AbfH1KRU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 06:17:20 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i2v0q-0001sT-6P; Wed, 28 Aug 2019 12:17:12 +0200
Date:   Wed, 28 Aug 2019 12:17:12 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        David Miller <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] netfilter: nf_tables: fib: Drop IPV6 packages if
 IPv6 is disabled on boot
Message-ID: <20190828101712.GF20113@breakpoint.cc>
References: <20190827.141950.540994003351676048.davem@davemloft.net>
 <20190827215836.GA10942@strlen.de>
 <20190828081942.isdjcdvcqok2a6zz@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828081942.isdjcdvcqok2a6zz@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Aug 27, 2019 at 11:58:36PM +0200, Florian Westphal wrote:
> > David Miller <davemdavemloft!net> wrote:
> > > From: Leonardo Bras <leonardo@linux.ibm.com>
> > > Date: Tue, 27 Aug 2019 14:34:14 -0300
> > > 
> > > > I could reproduce this bug on a host ('ipv6.disable=1') starting a
> > > > guest with a virtio-net interface with 'filterref' over a virtual
> > > > bridge. It crashes the host during guest boot (just before login).
> > > > 
> > > > By that I could understand that a guest IPv6 network traffic
> > > > (viavirtio-net) may cause this kernel panic.
> > > 
> > > Really this is bad and I suspected bridging to be involved somehow.
> > 
> > Thats a good point -- Leonardo, is the
> > "net.bridge.bridge-nf-call-ip6tables" sysctl on?
> > 
> > As much as i'd like to send a patch to remove br_netfilter, I fear
> > we can't even stop passing ipv6 packets up to netfilter if
> > ipv6.disable=1 is set because users might be using ip6tables for
> > bridged traffic.
> 
> If the br_netfilter module is in placed, then it's probably better to
> perform this check from there.

ipt6tables won't work for filtering anymore, so I don't think this is
something we can do.  Anyway, lets wait for Leonardo to confirm, else
this is pointless speculation :-)
