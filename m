From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 1/2] iptables: support match info fixup after tc_init
Date: Mon, 18 Sep 2017 19:23:53 +0200
Message-ID: <20170918172353.GA8982@salvia>
References: <20170917112031.8644-1-shmulik@nsof.io>
 <20170917112031.8644-2-shmulik@nsof.io>
 <20170918162811.GA6091@salvia>
 <20170918200042.3189aa0f@pixies>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>, rbk@nsof.io,
        Rafael Buchbinder <rafi@rbk.ms>
To: Shmulik Ladkani <shmulik@nsof.io>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:36852 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754824AbdIRRX6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2017 13:23:58 -0400
Content-Disposition: inline
In-Reply-To: <20170918200042.3189aa0f@pixies>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 18, 2017 at 08:00:42PM +0300, Shmulik Ladkani wrote:
> Hi Pablo,
> 
> On Mon, 18 Sep 2017 18:28:11 +0200 Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> > >  
> > > +	/* Fixes the match info after init. */
> > > +	void (*tc_init_fixup)(struct xt_entry_match *match);  
> > 
> > If this is only broken from tc ipt actions, could you fix this from
> > iproute2/tc instead?
> 
> No, this is not iproute2/tc specfic.

OK.

> We named it 'tc_init_fixup' as it occurs just after the TC_INIT
> (iptc_init/ip6tc_init) call.
> If this is confusing, we can rename to 'init_fixup' or 'post_init_fixup'
> or 'iptc_init_fixup'.
> 
> This must occur after every load of entries, as the xt_bpf match needs
> a fixup once read from kernel.
> 
> The problem lies in the xt_bpf_info_v1 ABI.
> See:
> https://marc.info/?l=netfilter-devel&m=150530909630143&w=2

I see, can we get a v2 ABI that fixes this? Given this was included
not long time ago, we can quickly deprecate this without this custom
hook to address this.

We can include this in the next iptables release in the next weeks.
