From: Florian Westphal <fw@strlen.de>
Subject: Re: Overlapping IP networks no longer allowed?
Date: Wed, 14 Feb 2018 23:32:18 +0100
Message-ID: <20180214223218.GG2810@breakpoint.cc>
References: <CAPWNY8W5euS6+LrEppdKp81k-Uz48w2WZP8kzu5=cVyhObnVMg@mail.gmail.com>
 <20180214182249.nnccha2bg5j4htrv@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity@gmail.com>,
        netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44736 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1031527AbeBNWff (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Feb 2018 17:35:35 -0500
Content-Disposition: inline
In-Reply-To: <20180214182249.nnccha2bg5j4htrv@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Feb 14, 2018 at 07:02:32PM +0200, Mantas Mikulėnas wrote:
> > Hello,
> > 
> > As of nftables 0.8.1, it seems I can no longer write anonymous sets
> > which contain overlapping networks (CIDR masks).
> > 
> > For example, I want to write the following ruleset:
> > 
> > #!/usr/bin/nft -f
> > define users = { 10.0.0.0/8, 193.219.181.192/26 }
> > define admins = { 10.123.0.0/24, 31.220.42.129 }
> > define allowed = { $users, $admins }
> > table inet filter {
> >         chain foobar {
> >                 ip saddr $allowed accept
> >         }
> > }
> > 
> > results in an error message:
> > 
> >     Error: interval overlaps with previous one
> > 
> > I noticed a few nftables.git commits related to disabling auto-merge
> > for interval sets... but mine don't have the 'interval' flag, and
> > there doesn't seem to be any way to specify 'auto-merge' for anonymous
> > sets, either.
> 
> I would like not to enable this by default since typo in rulesets
> could go through unnoticed.

nft add rule filter input ip protocol '{6 ,tcp }'
works just fine, eliminating duplicate set elements.
So I don't see how that is different from removing the redundant parts
of an anon set.

Especially with 'define' things I believe that automerge by default
is desireable.

> So the two alternatives I see are:
> 
> 1) add per-table configuration options, this would allow us to
>    enable auto-merge explicitly for all anonymous sets. This is also
>    required if we want to allow user to select "policy memory;" for
>    anonymous sets. Only problem with this approach is that this needs
>    a kernel patch, so it will take a while to restore the behaviour you
>    want since we need a new NFTA_TABLE_USERDATA attribute to store user
>    preferences on this.

Right.

> 2) We add a -m option that we can combine with -f for this, which
>    globally enables auto-merge for every set, including anonymous and
>    named sets.

What about doing automerge by default again for anon sets?

I know you don't like it but it restores old behaviour.
We could have a debug option that tells users which addresse(s) were
autoremoved.

The typo argument -- not sure its a valid:
Consider '10.0.0.01' (instead of .10), we don't try to be 'smart'
and thats a good thing.

For named sets, the no automerge makes sense because it seems like
we can't make any reasonable default choice when users try to delete
a no-longer existing (i.e. merged) element.

But that problem doesn't exist with constant (anon or not) sets.
