From: Jonathan Morton <chromatix99@gmail.com>
Subject: Re: [Cake] [PATCH net-next v15 4/7] sch_cake: Add NAT awareness to
 packet classifier
Date: Wed, 23 May 2018 22:31:53 +0300
Message-ID: <91739F64-20B7-4C56-A7A3-AB8C71B9437C@gmail.com>
References: <152699741881.21931.11656377745581563912.stgit@alrua-kau>
 <152699745846.21931.4558451708304709296.stgit@alrua-kau>
 <20180523.144442.864194409238516747.davem@davemloft.net>
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Cc: toke@toke.dk, cake@lists.bufferbloat.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180523.144442.864194409238516747.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

> On 23 May, 2018, at 9:44 pm, David Miller <davem@davemloft.net> wrote:
>=20
> I'd much rather you do something NAT method agnostic, like save
> or compute the necessary information on ingress and then later
> use it on egress.

We were under the impression that conntrack was the cleanest and most =
correct way to convey this information between qdiscs.  Frankly it's =
difficult to see how else we could do it without major complications.

Remember that it takes two different qdiscs to implement ingress and =
egress on the same physical interface, and there's no obvious logical =
link between them - especially since the ingress one has to be attached =
to an ifb, not to the actual interface, because there's no native =
support for ingress qdiscs.

What's more, there's no information (besides conntrack) at ingress about =
the "inside" address of NATted traffic. There might be some residual =
information for egress traffic, but communicating that to the ingress =
side feels very much like we need to reimplement something very like =
conntrack.

If not supporting "alternative" NAT mechanisms that don't register their =
data in conntrack is the penalty, it's one I personally can live with.

 - Jonathan Morton
