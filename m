From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: conntrack: add support for flextuples
Date: Mon, 4 May 2015 12:34:51 +0200
Message-ID: <20150504103451.GA12200@salvia>
References: <776b8819c85c83088478b933a35691133055347a.1430733932.git.daniel@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Thomas Graf <tgraf@suug.ch>,
	Madhu Challa <challa@noironetworks.com>
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52544 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbbEDKaN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 May 2015 06:30:13 -0400
Content-Disposition: inline
In-Reply-To: <776b8819c85c83088478b933a35691133055347a.1430733932.git.daniel@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 04, 2015 at 12:23:41PM +0200, Daniel Borkmann wrote:
> This patch adds support for the possibility of doing NAT with
> conflicting IP address/ports tuples from multiple, isolated
> tenants, represented as network namespaces and netfilter zones.
> For such internal VRFs, traffic is directed to a single or shared
> pool of public IP address/port range for the external/public VRF.
> 
> Or in other words, this allows for doing NAT *between* VRFs
> instead of *inside* VRFs without requiring each tenant to NAT
> twice or to use its own dedicated IP address to SNAT to, also
> with the side effect to not requiring to expose a unique marker
> per tenant in the data center to the public.
> 
> Simplified example scheme:
> 
>   +--- VRF A ---+  +--- CT Zone 1 --------+
>   | 10.1.1.1/8  +--+ 10.1.1.1 ESTABLISHED |
>   +-------------+  +--+-------------------+
>                       |
>                    +--+--+
>                    | L3  +-SNAT-[20.1.1.1:20000-40000]--eth0
>                    +--+--+
>                       |
>   +-- VRF B ----+  +--- CT Zone 2 --------+
>   | 10.1.1.1/8  +--+ 10.1.1.1 ESTABLISHED |
>   +-------------+  +----------------------+

So, it's the skb->mark that survives between the containers.  I'm not
sure it makes sense to keep a zone 0 from the container that performs
SNAT. Instead, we can probably restore the zone based on the
skb->mark. The problem is that the existing zone is u16. In nftables,
Patrick already mentioned about supporting casting so we can do
something like:

        ct zone set (u16)meta mark

So you can reserve a part of the skb->mark to map it to the zone. I'm
not very convinced about this.
