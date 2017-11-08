From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: linux-next: build warning after merge of the netfilter-next tree
Date: Thu, 9 Nov 2017 00:40:14 +0100
Message-ID: <20171108234014.GA1788@salvia>
References: <20171107110248.7f1924a7@canb.auug.org.au>
 <20171108190052.63dfd8ce@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171108190052.63dfd8ce@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Nov 08, 2017 at 07:00:52PM +1100, Stephen Rothwell wrote:
> Hi Dave,
> 
> On Tue, 7 Nov 2017 11:02:48 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Hi all,
> > 
> > After merging the netfilter-next tree, today's linux-next build (powerpc
> > ppc64_defconfig) produced this warning:
> > 
> > net/netfilter/nf_conntrack_netlink.c:536:15: warning: 'ctnetlink_proto_size' defined but not used [-Wunused-function]
> >  static size_t ctnetlink_proto_size(const struct nf_conn *ct)
> >                ^
> > 
> > Introduced by commit
> > 
> >   5caaed151a68 ("netfilter: conntrack: don't cache nlattr_tuple_size result in nla_size")
> 
> I assume that this warning will now be in the net-next tree ...

It's my fault, I'll fix this in my next batch, sorry for the inconvenience.
