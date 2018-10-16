From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next 0/3] ip_tunnel: specify tunnel type via template
Date: Tue, 16 Oct 2018 10:03:39 +0200
Message-ID: <20181016080339.cq2osydjbrfbl7ja@salvia>
References: <20181009222439.29399-1-pablo@netfilter.org>
 <20181015.214320.807689629924469586.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        roopa@cumulusnetworks.com, amir@vadai.me, pshelar@ovn.org,
        u9012063@gmail.com, daniel@iogearbox.net,
        jakub.kicinski@netronome.com
To: David Miller <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181015.214320.807689629924469586.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Oct 15, 2018 at 09:43:20PM -0700, David Miller wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> Date: Wed, 10 Oct 2018 00:24:36 +0200
> 
> > The following patchset adds a new field to the tunnel metadata template.
> > This new field allows us to restrict the configuration to a given tunnel
> > driver in order to catch incorrect configuration that may result in
> > packets going to the wrong tunnel driver.
> > 
> > Changes with regards to initial RFC [1] are:
> > 
> > 1) Explicit tunnel type initialization to TUNNEL_TYPE_UNSPEC in existing
> >    clients for this code, as requested by Daniel.
> > 
> > 2) Add TUNNEL_TYPE_* definition through enum tunnel_type in
> >    uapi/linux/if_tunnel.h, so we don't need to redefine this in every
> >    client of this infrastructure.
> > 
> > 3) Add TUNNEL_TYPE_IPIP, TUNNEL_TYPE_IPIP6 and TUNNEL_TYPE_IP6IP6, which
> >    were missing in the original RFC.
> > 
> > Let me know if you any more comments, thanks.
> > 
> > [1] https://marc.info/?l=netfilter-devel&m=153861145204094&w=2
> 
> People don't need to update a core common UAPI header to add a new
> ethernet driver.
> 
> They shouldn't have to do so to add a new tunneling driver either.
> 
> But that requirement is created by this patch set.

No, you can keep using TUNNEL_TYPE_UNSPEC in such scenario.

It is entirely optional and backward compatible.
