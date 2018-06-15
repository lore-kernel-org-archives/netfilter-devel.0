From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net-next,RFC 00/13] New fast forwarding path
Date: Fri, 15 Jun 2018 08:17:41 +0200
Message-ID: <20180615061740.eqgr2iv722oydheb@gauss3.secunet.de>
References: <20180614141947.3580-1-pablo@netfilter.org>
 <20180614.101831.465275975690050595.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: <pablo@netfilter.org>, <netfilter-devel@vger.kernel.org>,
        <netdev@vger.kernel.org>
To: David Miller <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180614.101831.465275975690050595.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 14, 2018 at 10:18:31AM -0700, David Miller wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> Date: Thu, 14 Jun 2018 16:19:34 +0200
> 
> > This patchset proposes a new fast forwarding path infrastructure
> > that combines the GRO/GSO and the flowtable infrastructures. The
> > idea is to add a hook at the GRO layer that is invoked before the
> > standard GRO protocol offloads. This allows us to build custom
> > packet chains that we can quickly pass in one go to the neighbour
> > layer to define fast forwarding path for flows.
> 
> We have full, complete, customizability of the packet path via XDP
> and eBPF.
> 
> XDP and eBPF supports everything necessary to accomplish that,
> there are implementations of forwarding implementations in
> the tree and elsewhere.
> 
> And most importantly, XDP and eBPF are optimized in drivers and
> offloaded to hardware.
> 
> There really is no need for something like what you are proposing.

I started with this last year because I wanted to improve
the IPsec (and UDP) forwarding path. Batching packets
at layer2  and send them directly to the output path
seemed to be a good method to improve this.

In particular, we need to do only one IPsec lookup
for the whole packet chain. So it relaxes the pain
from reomoving the IPsec flowcache a bit. It can be
only a first step, but we need some improvements here
as people start to complain about that.
