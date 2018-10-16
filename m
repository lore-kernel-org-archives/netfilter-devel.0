From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next 0/3] ip_tunnel: specify tunnel type via
 template
Date: Mon, 15 Oct 2018 21:43:20 -0700 (PDT)
Message-ID: <20181015.214320.807689629924469586.davem@davemloft.net>
References: <20181009222439.29399-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        roopa@cumulusnetworks.com, amir@vadai.me, pshelar@ovn.org,
        u9012063@gmail.com, daniel@iogearbox.net,
        jakub.kicinski@netronome.com
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181009222439.29399-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed, 10 Oct 2018 00:24:36 +0200

> The following patchset adds a new field to the tunnel metadata template.
> This new field allows us to restrict the configuration to a given tunnel
> driver in order to catch incorrect configuration that may result in
> packets going to the wrong tunnel driver.
> 
> Changes with regards to initial RFC [1] are:
> 
> 1) Explicit tunnel type initialization to TUNNEL_TYPE_UNSPEC in existing
>    clients for this code, as requested by Daniel.
> 
> 2) Add TUNNEL_TYPE_* definition through enum tunnel_type in
>    uapi/linux/if_tunnel.h, so we don't need to redefine this in every
>    client of this infrastructure.
> 
> 3) Add TUNNEL_TYPE_IPIP, TUNNEL_TYPE_IPIP6 and TUNNEL_TYPE_IP6IP6, which
>    were missing in the original RFC.
> 
> Let me know if you any more comments, thanks.
> 
> [1] https://marc.info/?l=netfilter-devel&m=153861145204094&w=2

People don't need to update a core common UAPI header to add a new
ethernet driver.

They shouldn't have to do so to add a new tunneling driver either.

But that requirement is created by this patch set.
