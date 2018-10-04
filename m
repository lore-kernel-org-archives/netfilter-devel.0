From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC,net-next 0/3] ip_tunnel: specify tunnel type via
 template
Date: Thu, 4 Oct 2018 23:58:05 +0200
Message-ID: <20181004215805.wnpwrrgy2uzprtuv@salvia>
References: <20181004000345.2380-1-pablo@netfilter.org>
 <20181004121357.3efa7275@cakuba.netronome.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        roopa@cumulusnetworks.com, amir@vadai.me, pshelar@ovn.org,
        u9012063@gmail.com
To: Jakub Kicinski <jakub.kicinski@netronome.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181004121357.3efa7275@cakuba.netronome.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Jakub,

On Thu, Oct 04, 2018 at 12:13:57PM -0700, Jakub Kicinski wrote:
> On Thu,  4 Oct 2018 02:03:42 +0200, Pablo Neira Ayuso wrote:
> > Hi,
> > 
> > The following patchset adds a new field to the tunnel metadata template
> > to restrict the configuration to a given tunnel driver. Currently, a
> > misconfiguration may result in packets going to the wrong tunnel driver.
> > 
> > Although we have the tunnel option flags, they are not mandatory for
> > some tunnel drivers, eg. vxlan, which may use it or not; and gre which
> > does not use them.
> 
> Option flags are necessary because interpretation of option blob is
> entirely protocol-specific.
> 
> > This patch updates tc's tunnel action and netfilter's tunnel extension
> > to use this new field. OVS netlink interface has been left unset, although they
> > could be updated to use this.
> > 
> > By extending the existing tc action to support the IP_TUNNEL_INFO_BRIDGE
> > mode, I think it should be possible to expose IP_TUNNEL_TYPE_VLAN too,
> > although this patchset doesn't address this scenario.
> > 
> > The field is initialized to zero, which maps to IP_TUNNEL_TYPE_UNSPEC to
> > retain the existing behaviour, so the existing flexibility is still in
> > place while this new feature is added.
> > 
> > Cc'ing people that git annotate show as dealing with these bits more
> > recently.
> 
> What practical scenario are you trying to address here?

Incorrect configuration. The tunnel template defines an ID field, this
ID means vni in vxlan, but it also means session in erspan. If a
packet that should go to vxlan tunnel device (to be encapsulated using
vni 5) ends up in a gre/erspan device, you will get an erspan packet
with session 5. With this new tunnel type field, you can restrict
the tunnel template to work _only_ for a given tunnel device driver.
Hence, if the packet ends up in the wrong tunnel device driver due to
incorrect configuration, packet gets dropped.

> Have you seen
> https://www.mail-archive.com/netdev@vger.kernel.org/msg250705.html
> ?

Hm, I remember to have seen some hw offload driver code that is making
assumptions on the destination ports to pick the tunnel protocol,
based on what the act_key_tunnel is passing.

This patchset may probably help there too since act_key_tunnel will
convey the tunnel type, given this can now be made explicit. The tc
action parsing from the driver can annotate the tunnel type that has
been set in this rule via act_tunnel_key, then validate that follow up
mirred action points to a tunnel device of the same type.

Thanks.
