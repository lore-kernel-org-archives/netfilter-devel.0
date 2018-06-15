From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net-next,RFC 00/13] New fast forwarding path
Date: Fri, 15 Jun 2018 07:23:09 +0200
Message-ID: <20180615052309.brad7wtaselcs6wq@gauss3.secunet.de>
References: <20180614141947.3580-1-pablo@netfilter.org>
 <CAF=yD-+fJ_isaGtfLFVgMQ4_7K-v7b+Kyo6iOB-5kUbbPJXT7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAF=yD-+fJ_isaGtfLFVgMQ4_7K-v7b+Kyo6iOB-5kUbbPJXT7Q@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 14, 2018 at 11:50:49AM -0400, Willem de Bruijn wrote:
> > This patchset supports both layer 3 IPv4 and IPv6, and layer 4 TCP and
> > UDP protocols. This fastpath also integrates with the IPSec
> > infrastructure and the ESP protocol.
> >
> > We have collected performance numbers:
> >
> >         TCP TSO         TCP Fast Forward
> >         32.5 Gbps       35.6 Gbps
> >
> >         UDP             UDP Fast Forward
> >         17.6 Gbps       35.6 Gbps
> >
> >         ESP             ESP Fast Forward
> >         6 Gbps          7.5 Gbps
> >
> > For UDP, this is doubling performance, and we almost achieve line rate
> > with one single CPU using the Intel i40e NIC. We got similar numbers
> > with the Mellanox ConnectX-4. For TCP, this is slightly improving things
> > even if TSO is being defeated given that we need to segment the packet
> > chain in software.
> 
> The difference between TCP and UDP stems from lack of GRO for UDP.

Right.

> We
> recently added UDP GSO to allow for batch traversal of the UDP stack on
> transmission. Adding a UDP GRO handler can probably extend batching to
> the forwarding path in a similar way without the need for a new infrastructure.

That's more or less what we did. The batching method ist just
optimized for the forwarding path. We are generating skb chains
by chaning at the frag_list pointer of the first skb. With that,
we don't need to mange packet. We keep the packets in the native
form, so the 'segmentation' is rather easy.

The rest is just to be able to configure this and to make
sure that we handle only flows that are going to be (fast)
forwarded, as the upper stack can not (yet) handle such
skb chains.
