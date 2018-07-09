From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: conntrack: add weak IPV6 dependency
Date: Mon, 9 Jul 2018 18:50:50 +0200
Message-ID: <20180709165050.uuglk24ctiezhnye@salvia>
References: <20180706130005.3640993-1-arnd@arndb.de>
 <20180706135516.viz6pjtkdmcoqq2l@breakpoint.cc>
 <CAK8P3a1o6+dcZuW_iMGzwBBw_dcW41QAQ2Mu4A5Ru9ScnwaYDA@mail.gmail.com>
 <20180706150037.knqt736uq6uyh3bs@breakpoint.cc>
 <20180706183548.hk7jwobomkqdccs5@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arnd Bergmann <arnd@arndb.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        =?iso-8859-1?Q?M=E1t=E9?= Eckl <ecklm94@gmail.com>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        "Pablo M. Bermudo Garay" <pablombg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180706183548.hk7jwobomkqdccs5@breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jul 06, 2018 at 08:35:48PM +0200, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > Arnd Bergmann <arnd@arndb.de> wrote:
> > > and that resulted in a new build failure:
> > > 
> > > net/netfilter/nf_conntrack_proto.o:(.rodata+0x788): undefined
> > > reference to `nf_conntrack_l4proto_icmpv6'
> > > net/ipv6/netfilter/nf_conntrack_reasm.o: In function `nf_ct_frag6_expire':
> > > nf_conntrack_reasm.c:(.text+0x2320): undefined reference to
> > > `ip6_expire_frag_queue'
> > > net/ipv6/netfilter/nf_conntrack_reasm.o: In function `nf_ct_frag6_init':
> > > nf_conntrack_reasm.c:(.text+0x2384): undefined reference to `ip6_frag_init'
> > > nf_conntrack_reasm.c:(.text+0x2394): undefined reference to `ip6_frag_init'
> > > nf_conntrack_reasm.c:(.text+0x2398): undefined reference to `ip6_rhash_params'
> > > net/ipv6/netfilter/nf_conntrack_reasm.o: In function `nf_ct_frag6_expire':
> > > nf_conntrack_reasm.c:(.text+0x10bc): undefined reference to
> > > `ip6_expire_frag_queue'
> > > 
> > > I don't think we can get CONFIG_NF_DEFRAG_IPV6=y to work with IPV6=m.
> > 
> > Yes, not with current implementation, but I still don't think this
> > is unavoidable.
> > 
> > In case this is urgent I'm fine with the patch that adds the dependency,
> > otherwise I'd like to try and disentangle nf_conntrack_reasm and ipv6.
> 
> This links fine for me with IPV6=m:
> 
> Pablo, do you think this is too ugly?

Well, yes...

> It requires some copypastry from ipv6 defrag into nfct ipv6 defrag
> to avoid the link errors outlined above.

This is a bit of a regression I think.

While I think a bit of demodularization is fine, if things like this
start to kick in, it's probably good if we go make a step back...

Let me know, thanks.
