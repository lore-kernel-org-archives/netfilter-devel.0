From: Phil Sutter <phil@nwl.cc>
Subject: Re: [iptables PATCH] extensions: libxt_conntrack: Fix 'state'
 translation to nft
Date: Wed, 8 Mar 2017 13:31:51 +0100
Message-ID: <20170308123151.GA6028@orbyte.nwl.cc>
References: <20170307153507.14640-1-phil@nwl.cc>
 <20170307161729.GA2233@salvia>
 <20170307162055.GA4753@salvia>
 <20170307165409.GB19869@orbyte.nwl.cc>
 <20170307193158.GA19663@salvia>
 <20170307200745.GC19869@orbyte.nwl.cc>
 <20170308103652.GA3800@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:36447 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752990AbdCHMbx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2017 07:31:53 -0500
Content-Disposition: inline
In-Reply-To: <20170308103652.GA3800@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 08, 2017 at 11:36:52AM +0100, Pablo Neira Ayuso wrote:
> On Tue, Mar 07, 2017 at 09:07:45PM +0100, Phil Sutter wrote:
> > On Tue, Mar 07, 2017 at 08:31:58PM +0100, Pablo Neira Ayuso wrote:
> > > On Tue, Mar 07, 2017 at 05:54:09PM +0100, Phil Sutter wrote:
> > > > On Tue, Mar 07, 2017 at 05:20:55PM +0100, Pablo Neira Ayuso wrote:
> > > > > On Tue, Mar 07, 2017 at 05:17:29PM +0100, Pablo Neira Ayuso wrote:
> > > > > > On Tue, Mar 07, 2017 at 04:35:07PM +0100, Phil Sutter wrote:
> > > > > > > While translating a conntrack state match in old syntax, matches are
> > > > > > > looked up by name, only. This returned the revision 0 entry since
> > > > > > > matches are registered in reverse order of appearance in the array
> > > > > > > passed to xtables_register_matches(). The problem is that revision 0
> > > > > > > doesn't define an xlate callback.
> > > > > > > 
> > > > > > > Fix this by reordering the matches in conntrack_mt_reg so that the
> > > > > > > highest revision one is found first.
> > > > > > 
> > > > > > Applied, thanks Phil.
> > > > > 
> > > > > Wait.
> > > > > 
> > > > > Do you mean this case?
> > > > > 
> > > > > # iptables-translate -I INPUT -m state --state NEW
> > > > > nft insert rule ip filter INPUT ct state new  counter
> > > > > 
> > > > > Hm, this works here.
> > > > 
> > > > Yes, that's it. And it working for you just emphasizes something's fishy
> > > > here. I just reverted my patch, then it's like this:
> > > > 
> > > > | $ ./configure --prefix=$PWD/install && make && make install
> > > > | [...]
> > > > | $ ./install/sbin/iptables-translate -I INPUT -m state --state NEW
> > > > | nft # -I INPUT -m state --state NEW
> > > > 
> > > > Using 'strace -eopen' I see that libxt_state.so from the install
> > > > destination is used, not the system one.
> > > > 
> > > > Also, I did this change for debugging:
> > > > 
> > > > | --- a/iptables/xtables-translate.c
> > > > | +++ b/iptables/xtables-translate.c
> > > > | @@ -100,6 +100,10 @@ int xlate_matches(const struct iptables_command_state *cs, struct xt_xlate *xl)
> > > > |                         .escape_quotes  = !cs->restore,
> > > > |                 };
> > > > |  
> > > > | +               printf("found match %s, rev %u, xlate is %p\n",
> > > > | +                               matchp->match->name,
> > > > | +                               matchp->match->revision,
> > > > | +                               matchp->match->xlate);
> > > > |                 if (!matchp->match->xlate)
> > > > |                         return 0;
> > > > 
> > > > The output is then:
> > > > 
> > > > | $ ./install/sbin/iptables-translate -I INPUT -m state --state NEW
> > > > | nft found match state, rev 0, xlate is (nil)
> > > > | # -I INPUT -m state --state NEW
> > > > 
> > > > Am I missing something??
> > > 
> > > Via nft_compatible_revision() I'm getting revision 3. Are you using
> > > latest kernel from git?
> > 
> > No, I'm running 4.9.10-gentoo here. But a quick test with nf-next kernel
> > from Feb 23rd in a VM shows the same result. I have libnftnl-1.0.6
> > installed, is that relevant?
> 
> I have a way to trigger this here, but not sure if that is the problem
> there. If the kernel comes with no nft_compat support, then
> nft_compatible_revision() fails, and
> xtables_fully_register_pending_match() ends up selecting revision 0.
> 
> In such case, I can reproduce your problem.
> 
> # iptables-translate -A INPUT -m state --state NEW
> nft # -A INPUT -m state --state NEW 

Ah! On my system, nft_compat is built as module and it didn't matter
whether I have it loaded or not, nft_compatible_revision() would never
succeed.

Oh man, I just found the cause: I was running iptables-translate as
unprivileged user. Calling it with sudo magically makes everything work.

I'll have a look whether it's possible to communicate the received
-EPERM back to the user.

Cheers, Phil
