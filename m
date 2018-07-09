From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: conntrack: add weak IPV6 dependency
Date: Mon, 9 Jul 2018 22:27:25 +0200
Message-ID: <20180709202725.d2fgn5p26whfrvfn@breakpoint.cc>
References: <20180706130005.3640993-1-arnd@arndb.de>
 <20180706135516.viz6pjtkdmcoqq2l@breakpoint.cc>
 <CAK8P3a1o6+dcZuW_iMGzwBBw_dcW41QAQ2Mu4A5Ru9ScnwaYDA@mail.gmail.com>
 <20180706150037.knqt736uq6uyh3bs@breakpoint.cc>
 <20180706183548.hk7jwobomkqdccs5@breakpoint.cc>
 <20180709165050.uuglk24ctiezhnye@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Arnd Bergmann <arnd@arndb.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        =?iso-8859-15?Q?M=E1t=E9?= Eckl <ecklm94@gmail.com>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        "Pablo M. Bermudo Garay" <pablombg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180709165050.uuglk24ctiezhnye@salvia>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Jul 06, 2018 at 08:35:48PM +0200, Florian Westphal wrote:
> > Florian Westphal <fw@strlen.de> wrote:
> > > Arnd Bergmann <arnd@arndb.de> wrote:
> > > > and that resulted in a new build failure:
> > > > 
> > > > net/netfilter/nf_conntrack_proto.o:(.rodata+0x788): undefined
> > > > reference to `nf_conntrack_l4proto_icmpv6'
> > > > net/ipv6/netfilter/nf_conntrack_reasm.o: In function `nf_ct_frag6_expire':
> > > > nf_conntrack_reasm.c:(.text+0x2320): undefined reference to
> > > > `ip6_expire_frag_queue'
> > > > net/ipv6/netfilter/nf_conntrack_reasm.o: In function `nf_ct_frag6_init':
> > > > nf_conntrack_reasm.c:(.text+0x2384): undefined reference to `ip6_frag_init'
> > > > nf_conntrack_reasm.c:(.text+0x2394): undefined reference to `ip6_frag_init'
> > > > nf_conntrack_reasm.c:(.text+0x2398): undefined reference to `ip6_rhash_params'
> > > > net/ipv6/netfilter/nf_conntrack_reasm.o: In function `nf_ct_frag6_expire':
> > > > nf_conntrack_reasm.c:(.text+0x10bc): undefined reference to
> > > > `ip6_expire_frag_queue'
> > > > 
> > > > I don't think we can get CONFIG_NF_DEFRAG_IPV6=y to work with IPV6=m.
> > > 
> > > Yes, not with current implementation, but I still don't think this
> > > is unavoidable.
> > > 
> > > In case this is urgent I'm fine with the patch that adds the dependency,
> > > otherwise I'd like to try and disentangle nf_conntrack_reasm and ipv6.
> > 
> > This links fine for me with IPV6=m:
> > 
> > Pablo, do you think this is too ugly?
> 
> Well, yes...
> 
> > It requires some copypastry from ipv6 defrag into nfct ipv6 defrag
> > to avoid the link errors outlined above.
> 
> This is a bit of a regression I think.

nf_defrag_ipv6 has always depended on ipv6.

Previously dependency chain is

nf_conntrack_ipv6 -> ipv6
             +-----> nf_defrag_ipv6 > ipv6
	     +-----> nf_conntrack

new dependency chain is:
nf_conntrack --> nf_defrag_ipv6 --> ipv6

The alternate fix is the one from Arnd to disallow
NF_CONNTRACK=y
IPV6=m

> While I think a bit of demodularization is fine, if things like this
> start to kick in, it's probably good if we go make a step back...

If you want to revert, ok.  It will prevent all l4 unification patches
plus any attempt to get rid of the nf_hook for defrag too however so I
do not like it.

> Let me know, thanks.

Yet another alternative would be to remove the

nf_conntrack -> nf_defrag_ipv6

dependency, e.g. by adding a new rcu-protected function pointer.

nf_conntrack, when ipv6 conntrack is requested, would check if its null,
and, if so, issue request_module() for ipv6 defrag before failing the
request.

However, I find it even more ugly than my patch.
