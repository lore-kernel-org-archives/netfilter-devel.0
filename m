From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 00/52] Netfilter/IPVS updates for net-next
Date: Tue, 9 Jan 2018 16:43:10 +0100
Message-ID: <20180109154310.i4jf443ycet3yzdd@salvia>
References: <20180108202000.12989-1-pablo@netfilter.org>
 <20180108.205558.1708801479944961795.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180108.205558.1708801479944961795.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jan 08, 2018 at 08:55:58PM -0500, David Miller wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> Date: Mon,  8 Jan 2018 21:19:08 +0100
> 
> > The following patchset contains Netfilter/IPVS updates for your
> > net-next tree:
>  ...
> > 4) Add generic flow table offload infrastructure for nf_tables, this
> >    includes the netlink control plane and support for IPv4, IPv6 and
> >    mixed IPv4/IPv6 dataplanes. This comes with NAT support too. This
> >    patchset adds the IPS_OFFLOAD conntrack status bit to indicate that
> >    this flow has been offloaded.
> 
> Have driver maintainers signed off on your offload design and driver
> interfaces?
> 
> I've pulled, but the above is really important to indicate when a new
> offload feature is added.

Patch that adds driver interfaces have been kept back:

http://patchwork.ozlabs.org/patch/852537/

until there's an initial driver that uses the net_device hooks, as
notes in the cover letter [1].

So far, this is a generic software flow table representation, that
matches basic flow table hardware semantics but that also provides a
software faster path. So you can use it to purely forward packets
between two nics even if they come with no hardware offload support.
Numbers are available in my last NetDev 2.2 presentation

Regarding the design, feedback from vendors has been positive.

Thanks !

[1] https://lwn.net/Articles/742164/
[2] https://www.netdevconf.org/2.2/slides/ayuso-netfilter-workshop.pdf
(slide number 19).
