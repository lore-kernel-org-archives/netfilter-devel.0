From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC nf-next 0/5] netfilter: add ebpf translation infrastructure
Date: Wed, 13 Jun 2018 22:59:49 +0200
Message-ID: <20180613205949.tndbq3x6miwmli4w@breakpoint.cc>
References: <20180601153216.10901-1-fw@strlen.de>
 <20180611221257.qzip3iqh45kqqkpy@ast-mbp.dhcp.thefacebook.com>
 <20180612092812.vptmhuekmpb4pn5z@breakpoint.cc>
 <20180613004324.x2xdyj2qlbkkpccy@ast-mbp.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, ecree@solarflare.com
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180613004324.x2xdyj2qlbkkpccy@ast-mbp.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> On Tue, Jun 12, 2018 at 11:28:12AM +0200, Florian Westphal wrote:
> > I think its important user(space) can see which rules are jitted, and
> > which ebpf prog corresponds to which rule(s), using an expression as
> > container allows to re-use existing nft config plane code to serialze
> > this via netlink attributes.
> 
> In my mind it would be all or nothing. I don't think it helps
> to convert some rules and not all.

Ok.  Still, even in that case I think it would be good if we'd be able to tell
userspace the ebpf program id that corresponds to the ruleset.

> > Step 1: 1:1 mapping, an nft rule has at most one ebpf prog.
> > Step 2: figure out how to handle maps, sets, and how to cope with
> >         not-yet-translateable expressions
> > Step 3: m:n mapping: kernel provides adjacent rules to the UMH for
> >         jitting.  Example: user appends rules a, b, c.  UMH creates
> > 	single ebpf prog from a/b/c.
> >       	nft-pseudo-expression replaces a/b/c in the
> > 	packet path, original rules a/b/c are linked from the pseudo
> > 	expression for tracking.  If user deletes rule b, we provide
> > 	a/c to UMH to create new epbf prog that replaces new
> > 	sequence a/c.
> > Step 4: always provide entire future base chain and all reachable chains
> >         to the umh.  Ideally all of it is replaced by single program.

[..]

> > Does that make sense to you?
> > 
> > If you see this as flawed, please let me know, but as I have no idea
> > how to resolve these issues going from 0 to 4 makes no sense to me.
>
> I think the challenge is how to implement 4 without doing step 1, right?

Yes.

> imo doing such 1:1 (single rule to single bpf prog) translation does not
> help to break hard problem into smaller pieces. Such 1:1 is great
> for prototype, but not to land upstream.
> For the same reasons in bpfilter we did single iptable rule to single
> bpf prog translation, but such code doesn't belong in upstream tree,
> since it's not a scalable approach.
[..]

> > Okay, but without any idea how to consider existing expressions,
> > sets, maps etc. I'm not sure it makes sense to work on that at this
> > point.
> 
> I think sets and ipset (in case of iptables) fit well into trie model.

Yes, but thats going to be a lot of effort to handle properly
without breaking (or replacing) userland plumbing.

For nft we could aim for full-translation for the ingress hook
initially as that takes stateful filering out of the picture (ingress
occurs before conntrack).

We could also ignore sets for now and only deal with anonymous sets (they
are immutable and data stored in such sets can be made available to
UMH).

I can rework the RFC to emit "future table" to UMH instead of
individual rules, but I don't know yet when i will have time to work on
it again.

Thanks,
Florian
