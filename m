From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net-next,RFC 00/13] New fast forwarding path
Date: Fri, 15 Jun 2018 08:27:35 +0200
Message-ID: <20180615062735.i6qwreidqvn5zs42@gauss3.secunet.de>
References: <20180614141947.3580-1-pablo@netfilter.org>
 <CALx6S345B2-sejH52beewdiHuGo5nAY0v0uFmNuiJ0hQ6Wu3xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
To: Tom Herbert <tom@herbertland.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALx6S345B2-sejH52beewdiHuGo5nAY0v0uFmNuiJ0hQ6Wu3xw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 14, 2018 at 01:52:03PM -0700, Tom Herbert wrote:
> On Thu, Jun 14, 2018 at 7:19 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Hi,
> >
> > This patchset proposes a new fast forwarding path infrastructure that
> > combines the GRO/GSO and the flowtable infrastructures. The idea is to
> > add a hook at the GRO layer that is invoked before the standard GRO
> > protocol offloads. This allows us to build custom packet chains that we
> > can quickly pass in one go to the neighbour layer to define fast
> > forwarding path for flows.
> >
> > For each packet that gets into the GRO layer, we first check if there is
> > an entry in the flowtable, if so, the packet is placed in a list until
> > the GRO infrastructure decides to send the batch from gro_complete to
> > the neighbour layer. The first packet in the list takes the route from
> > the flowtable entry, so we avoid reiterative routing lookups.
> >
> > In case no entry is found in the flowtable, the packet is passed up to
> > the classic GRO offload handlers. Thus, this packet follows the standard
> > forwarding path. Note that the initial packets of the flow always go
> > through the standard IPv4/IPv6 netfilter forward hook, that is used to
> > configure what flows are placed in the flowtable. Therefore, only a few
> > (initial) packets follow the standard forwarding path while most of the
> > follow up packets take this new fast forwarding path.
> >
> 
> IIRC, there was a similar proposal a while back that want to bundle
> packets of the same flow together (without doing GRO) so that they
> could be processed by various functions by looking at just one
> representative packet in the group. The concept had some promise, but
> in the end it created quite a bit of complexity since at some point
> the packet bundle needed to be undone to go back to processing the
> individual packets.

With the way we chain the packets it is not too complicated to
undo this chaining (nft_skb_segment in patch 5 implements this).
After that, this looks like a chain of usual segments, so we
trigger xmit_more with every packet chain.
