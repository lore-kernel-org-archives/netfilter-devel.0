From: Phil Sutter <phil@nwl.cc>
Subject: Re: [iptables PATCH] extensions: libxt_conntrack: Fix 'state'
 translation to nft
Date: Tue, 7 Mar 2017 17:54:09 +0100
Message-ID: <20170307165409.GB19869@orbyte.nwl.cc>
References: <20170307153507.14640-1-phil@nwl.cc>
 <20170307161729.GA2233@salvia>
 <20170307162055.GA4753@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:58515 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752573AbdCGQzK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2017 11:55:10 -0500
Content-Disposition: inline
In-Reply-To: <20170307162055.GA4753@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 07, 2017 at 05:20:55PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Mar 07, 2017 at 05:17:29PM +0100, Pablo Neira Ayuso wrote:
> > On Tue, Mar 07, 2017 at 04:35:07PM +0100, Phil Sutter wrote:
> > > While translating a conntrack state match in old syntax, matches are
> > > looked up by name, only. This returned the revision 0 entry since
> > > matches are registered in reverse order of appearance in the array
> > > passed to xtables_register_matches(). The problem is that revision 0
> > > doesn't define an xlate callback.
> > > 
> > > Fix this by reordering the matches in conntrack_mt_reg so that the
> > > highest revision one is found first.
> > 
> > Applied, thanks Phil.
> 
> Wait.
> 
> Do you mean this case?
> 
> # iptables-translate -I INPUT -m state --state NEW
> nft insert rule ip filter INPUT ct state new  counter
> 
> Hm, this works here.

Yes, that's it. And it working for you just emphasizes something's fishy
here. I just reverted my patch, then it's like this:

| $ ./configure --prefix=$PWD/install && make && make install
| [...]
| $ ./install/sbin/iptables-translate -I INPUT -m state --state NEW
| nft # -I INPUT -m state --state NEW

Using 'strace -eopen' I see that libxt_state.so from the install
destination is used, not the system one.

Also, I did this change for debugging:

| --- a/iptables/xtables-translate.c
| +++ b/iptables/xtables-translate.c
| @@ -100,6 +100,10 @@ int xlate_matches(const struct iptables_command_state *cs, struct xt_xlate *xl)
|                         .escape_quotes  = !cs->restore,
|                 };
|  
| +               printf("found match %s, rev %u, xlate is %p\n",
| +                               matchp->match->name,
| +                               matchp->match->revision,
| +                               matchp->match->xlate);
|                 if (!matchp->match->xlate)
|                         return 0;

The output is then:

| $ ./install/sbin/iptables-translate -I INPUT -m state --state NEW
| nft found match state, rev 0, xlate is (nil)
| # -I INPUT -m state --state NEW

Am I missing something??

Thanks, Phil
