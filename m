From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC,net-next 0/3] ip_tunnel: specify tunnel type via
 template
Date: Sun, 14 Oct 2018 19:59:56 +0200
Message-ID: <20181014175956.2aitspm2jslg44ky@salvia>
References: <20181004000345.2380-1-pablo@netfilter.org>
 <20181004121357.3efa7275@cakuba.netronome.com>
 <20181004215805.wnpwrrgy2uzprtuv@salvia>
 <CAJ3xEMhu+the6+1a_r+2CAiYK1S-M1U37-TTyWBR41ORgYN=-g@mail.gmail.com>
 <20181014092438.rxvuc5yd27kkwrvh@salvia>
 <CAJ3xEMi0ZqGXK4qMs-KYp0XH3vmKSbRmHfFnG22MK9FPqqfCGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Amir Vadai <amir@vadai.me>, pravin shelar <pshelar@ovn.org>,
        u9012063@gmail.com, Jiri Pirko <jiri@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>
To: Or Gerlitz <gerlitz.or@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMi0ZqGXK4qMs-KYp0XH3vmKSbRmHfFnG22MK9FPqqfCGQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Or,

On Sun, Oct 14, 2018 at 02:24:42PM +0300, Or Gerlitz wrote:
> On Sun, Oct 14, 2018 at 12:24 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Sun, Oct 14, 2018 at 09:42:42AM +0300, Or Gerlitz wrote:
[...]
> > > for udp based tunneling this is valid practice, b/c a driver can get the tunnel
> > > type <--> udp dest port relation from the stack through the udp tunnel ndo.
> > >
> > > HW offloading wise, I think it would be better first pursue Januk and Co
> > > proposal which deals with the problematic part of tc/tunnels -- ingress rules
> > > set on tunnel devices (decap rules). The RFC looks very promising and
> > > I understand this is going to be reposed as non-rfc early in the next cycle
> >
> > Sorry, I think there's a misunderstanding here.
> >
> > My patchset is of benefit for pure software/control plane approach:
> > This allows users to narrow down tunnel configurations, existing
> > approach is very flexible - probably a bit too much for people willing
> > to validate things are correct - since it is allowing too loose
> > configurations. This is leaving room to the user to make configuration
> > mistakes that result in bad things, such as packets being tunneled
> > through the wrong encapsulation type.
> 
> I see your point, but I think that the fact that effectively all or most
> of the IP based tunnels in the kernel conform to struct ip_tunnel_info
> is a plus and not a minus.. control planes can do their mistakes if they
> don't read the man, this wrong tunneling that you mentioned is not going
> to live far beyond the next networking hop or even dropped earlier, within the
> stack of this node.

I think it is worse that just 'please read the manpage', look:

The tunnel ID field is 64 bits, but it is trimmed down to 32 bits for
VxLAN, and then it is 8 bits in case of ERSPAN for the session field.
Semantics depend on the tunnel protocol. Depending on the tunneling
protocol, the ID have different tunnel header field length. The
control plane cannot reject a 0xff00ffff in ERSPAN because the
ip_tunnel_info structure has no tunnel type semantics. I think it
would be good if users get some sort of 'sorry, you cannot specify
tunnel ID larger that 8 bits in ERSPAN'.

Another example, you can also specify via tc/ingress a rule like:

        act_tunnel_key id 50 src-addr 192.168.2.1

with no fwd/mirred action in a bridge setup. The tunnel device is part
of the bridge in this case, and the template passes the configuration
to the tunnel device that is part of the bridge. So we cannot assume
the fwd/mirred action always follow act_tunnel_key in software.
Probably in HW offload it makes sense to always follow it up with
fwd/mirred to keep things simple, but we already have scenarios in
software where this is not the case.

> > through the wrong encapsulation type. With this patchset, packets
> > going to the wrong tunnel devices will be simply dropped - and we
> > could even do more specific validation from control plane after this.
> > This patchset is backward compatible, so it doesn't restrict for the
> > existing flexibility that users may want for this.
> >
> > This patchset _never_ meant to replace Jakub's work nor any HW offload
> > infrastructure. After reading Jakub's email, I was just suggesting
> > that this may (probably) still help drivers too, since this would
> > provide more hints to the driver.
> 
> well, yes, more hints and sort of no (see next)
> 
> > provide more hints to the driver. Please, let me know if this is
> > causing any interference with your ongoing HW driver development in
> > some way, and if so, in what way.
> 
> for example, if newer controller wants to work over older kernel that doesn't
> have the new flag, they have to write code that can go both ways

This is backward compatible, your controller can keep using the
existing approach forever.

Anyway, I think the problem you're refering about older kernel and new
controller is an interesting one but a different problem: This is an
existing limitation in netlink. Currently, there is not way to know
what the API supports other than doing probing, and probing is
something may not even help. I already proposed something to address
this problem in case you're interested [1].

> , this is doable
> -- but do we want to do that just for the sake of reacting to user
> mis-configurations?
> 
> I am open  / will be happy to hear more opinions here.

Please note that this new feature is optional, for people willing to
have an interface/control plane that can validate what they are
configuring can be good. Users tend to make mistakes, manpage is last
resort, well if control plane can help / provide hints on what is
wrong, things become easier for users.

Thanks for your feedback!

[1] https://lwn.net/Articles/746776/
