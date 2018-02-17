From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH RFC 0/4] net: add bpfilter
Date: Sat, 17 Feb 2018 20:18:59 +0100
Message-ID: <20180217191859.GC3776@breakpoint.cc>
References: <20180216134023.15536-1-daniel@iogearbox.net>
 <20180216145727.GC32618@breakpoint.cc>
 <20180216161408.GA3776@breakpoint.cc>
 <9182f7b2-da9c-765e-028f-8b9e5c5d4716@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        alexei.starovoitov@gmail.com
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56176 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751029AbeBQTWX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 17 Feb 2018 14:22:23 -0500
Content-Disposition: inline
In-Reply-To: <9182f7b2-da9c-765e-028f-8b9e5c5d4716@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Daniel Borkmann <daniel@iogearbox.net> wrote:
> Hi Florian,
> 
> On 02/16/2018 05:14 PM, Florian Westphal wrote:
> > Florian Westphal <fw@strlen.de> wrote:
> >> Daniel Borkmann <daniel@iogearbox.net> wrote:
> >> Several questions spinning at the moment, I will probably come up with
> >> more:
> > 
> > ... and here there are some more ...
> > 
> > One of the many pain points of xtables design is the assumption of 'used
> > only by sysadmin'.
> > 
> > This has not been true for a very long time, so by now iptables has
> > this userspace lock (yes, its fugly workaround) to serialize concurrent
> > iptables invocations in userspace.
> > 
> > AFAIU the translate-in-userspace design now brings back the old problem
> > of different tools overwriting each others iptables rules.
> 
> Right, so the behavior would need to be adapted to be exactly the same,
> given all the requests go into kernel space first via the usual uapis,
> I don't think there would be anything in the way of keeping that as is.

Uff.  This isn't solveable.  At least thats what I tried to say here.
This is a limitation of the xtables setsockopt interface design.

If $docker (or anything else) adds a new rule using plain iptables other
daemons are not aware of it.

If some deletes a rule added by $software it won't learn that either.

The "solutions" in place now (periodic reloads/'is my rule still in
place' etc. are not desirable long-term.

You'll also need 4 decoders for arp/ip/ip6/ebtables plus translations
for all matches and targets xtables currently has. (almost 100 i would
guess from quick glance).

Some of the more crazy ones also have external user visible interfaces
outside setsockopt (proc files, ipset).

> > One of the nftables advantages is that (since rule representation in
> > kernel is black-box from userspace point of view) is that the kernel
> > can announce add/delete of rules or elements from nftables sets.
> > 
> > Any particular reason why translating iptables rather than nftables
> > (it should be possible to monitor the nftables changes that are
> >  announced by kernel and act on those)?
> 
> Yeah, correct, this should be possible as well. We started out with the
> iptables part in the demo as the majority of bigger infrastructure projects
> all still rely heavily on it (e.g. docker, k8s to just name two big ones).

Yes, which is why we have translation tools in place.

Just for the fun of it I tried to delete ip/ip6tables binaries on my
fedora27 laptop and replaced them with symlinks to
'xtables-compat-multi'.

Aside from two issues (SELinux denying 'iptables' to use netlink) and
one translation issue (-m rpfilter, which can be translated in current
upstream version) this works out of the box, the translator uses
nftables api to kernel (so kernel doesn't even know which program is
talking...), 'nft monitor' displays the rules being added, and
'nft list ruleset' shows the default firewalld ruleset.

Obviously there are a few limitations, for instance ip6tables-save will
stop working once you add nft-based rules that use features that cannot
be expressed in xtables syntax (it will throw an error message similar
to 'you are using nftables featues not available in xtables, please use
nft'), for intance verdict maps, sets and the like.

> Usually they have their requests to iptables baked into their code directly
> which probably won't change any time soon, so thought was that they could
> benefit initially from it once there would be sufficient coverage.

See above, the translator covers most basic use cases nowadays.
The more extreme cases are not covered because we were reluctant to
provide equivalent in nftables (-m time comes to mind which was always a
PITA because kernel has no notion of timezone or DST transitions,
leading to 'magic' mismatches when timezone changes...

I could explain on more problem cases but none of them are too
important I think.

If you'd like to have more ebpf users in the kernel, then there is at
least one use case where ebpf could be very attractive for nftables
(matching dynamic headers and the like).  This would be a new
feature and would need changes on nftables userspace side
as well (we don't have syntax/grammar to represent this in either
nft or iptables).

In most basic form, it would be nftables replacement for '-m string'
(and perhaps also -m bpf to some degree, depends on how it would be
 realized).

We can discuss more if there is interest, but I think it
would be more suitable for conference/face to face discussion.
