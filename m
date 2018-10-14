From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH RFC,net-next 0/3] ip_tunnel: specify tunnel type via template
Date: Sun, 14 Oct 2018 14:24:42 +0300
Message-ID: <CAJ3xEMi0ZqGXK4qMs-KYp0XH3vmKSbRmHfFnG22MK9FPqqfCGQ@mail.gmail.com>
References: <20181004000345.2380-1-pablo@netfilter.org> <20181004121357.3efa7275@cakuba.netronome.com>
 <20181004215805.wnpwrrgy2uzprtuv@salvia> <CAJ3xEMhu+the6+1a_r+2CAiYK1S-M1U37-TTyWBR41ORgYN=-g@mail.gmail.com>
 <20181014092438.rxvuc5yd27kkwrvh@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Amir Vadai <amir@vadai.me>, pravin shelar <pshelar@ovn.org>,
        u9012063@gmail.com, Jiri Pirko <jiri@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181014092438.rxvuc5yd27kkwrvh@salvia>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, Oct 14, 2018 at 12:24 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, Oct 14, 2018 at 09:42:42AM +0300, Or Gerlitz wrote:
> > On Fri, Oct 5, 2018 at 12:58 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> [...]
> > > On Thu, Oct 04, 2018 at 12:13:57PM -0700, Jakub Kicinski wrote:
> > > > On Thu,  4 Oct 2018 02:03:42 +0200, Pablo Neira Ayuso wrote:
> > > > > Hi,
> > > > >
> > > > > The following patchset adds a new field to the tunnel metadata template
> > > > > to restrict the configuration to a given tunnel driver. Currently, a
> > > > > misconfiguration may result in packets going to the wrong tunnel driver.
> > > > >
> > > > > Although we have the tunnel option flags, they are not mandatory for
> > > > > some tunnel drivers, eg. vxlan, which may use it or not; and gre which
> > > > > does not use them.
> > > >
> > > > Option flags are necessary because interpretation of option blob is
> > > > entirely protocol-specific.
> > > >
> > > > > This patch updates tc's tunnel action and netfilter's tunnel extension
> > > > > to use this new field. OVS netlink interface has been left unset, although they
> > > > > could be updated to use this.
> > > > >
> > > > > By extending the existing tc action to support the IP_TUNNEL_INFO_BRIDGE
> > > > > mode, I think it should be possible to expose IP_TUNNEL_TYPE_VLAN too,
> > > > > although this patchset doesn't address this scenario.
> >
> > not following... can you elaborate further please?
>
> It should be possible to extend act_key_tunnel to support the
> IP_TUNNEL_INFO_BRIDGE flag, but this is just a suggestion.
>
> > > > > The field is initialized to zero, which maps to IP_TUNNEL_TYPE_UNSPEC to
> > > > > retain the existing behaviour, so the existing flexibility is still in
> > > > > place while this new feature is added.
> > > > >
> > > > > Cc'ing people that git annotate show as dealing with these bits more
> > > > > recently.
> > > >
> > > > What practical scenario are you trying to address here?
> > >
> > > Incorrect configuration. The tunnel template defines an ID field, this
> > > ID means vni in vxlan, but it also means session in erspan. If a
> > > packet that should go to vxlan tunnel device (to be encapsulated using
> > > vni 5) ends up in a gre/erspan device, you will get an erspan packet
> > > with session 5. With this new tunnel type field, you can restrict
> > > the tunnel template to work _only_ for a given tunnel device driver.
> > > Hence, if the packet ends up in the wrong tunnel device driver due to
> > > incorrect configuration, packet gets dropped.
> > >
> > >> Have you seen
> > >> https://www.mail-archive.com/netdev@vger.kernel.org/msg250705.html ?
> >
> > > Hm, I remember to have seen some hw offload driver code that is making
> > > assumptions on the destination ports to pick the tunnel protocol,
> > > based on what the act_key_tunnel is passing.
> > [..]
> >
> > for udp based tunneling this is valid practice, b/c a driver can get the tunnel
> > type <--> udp dest port relation from the stack through the udp tunnel ndo.
> >
> > HW offloading wise, I think it would be better first pursue Januk and Co
> > proposal which deals with the problematic part of tc/tunnels -- ingress rules
> > set on tunnel devices (decap rules). The RFC looks very promising and
> > I understand this is going to be reposed as non-rfc early in the next cycle
>
> Sorry, I think there's a misunderstanding here.
>
> My patchset is of benefit for pure software/control plane approach:
> This allows users to narrow down tunnel configurations, existing
> approach is very flexible - probably a bit too much for people willing
> to validate things are correct - since it is allowing too loose
> configurations. This is leaving room to the user to make configuration
> mistakes that result in bad things, such as packets being tunneled
> through the wrong encapsulation type.

I see your point, but I think that the fact that effectively all or most
of the IP based tunnels in the kernel conform to struct ip_tunnel_info
is a plus and not a minus.. control planes can do their mistakes if they
don't read the man, this wrong tunneling that you mentioned is not going
to live far beyond the next networking hop or even dropped earlier, within the
stack of this node.

> through the wrong encapsulation type. With this patchset, packets
> going to the wrong tunnel devices will be simply dropped - and we
> could even do more specific validation from control plane after this.
> This patchset is backward compatible, so it doesn't restrict for the
> existing flexibility that users may want for this.
>
> This patchset _never_ meant to replace Jakub's work nor any HW offload
> infrastructure. After reading Jakub's email, I was just suggesting
> that this may (probably) still help drivers too, since this would
> provide more hints to the driver.

well, yes, more hints and sort of no (see next)

> provide more hints to the driver. Please, let me know if this is
> causing any interference with your ongoing HW driver development in
> some way, and if so, in what way.

for example, if newer controller wants to work over older kernel that doesn't
have the new flag, they have to write code that can go both ways, this is doable
-- but do we want to do that just for the sake of reacting to user
mis-configurations?

I am open  / will be happy to hear more opinions here.

Or.
