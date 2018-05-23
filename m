From: Jonathan Morton <chromatix99@gmail.com>
Subject: Re: [Cake] [PATCH net-next v15 4/7] sch_cake: Add NAT awareness to
 packet classifier
Date: Wed, 23 May 2018 23:33:04 +0300
Message-ID: <370B23D9-E929-4A73-BB7C-C1BE4A01C7E6@gmail.com>
References: <152699745846.21931.4558451708304709296.stgit@alrua-kau>
 <20180523.144442.864194409238516747.davem@davemloft.net>
 <91739F64-20B7-4C56-A7A3-AB8C71B9437C@gmail.com>
 <20180523.160403.20551254565100734.davem@davemloft.net>
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Cc: toke@toke.dk, cake@lists.bufferbloat.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180523.160403.20551254565100734.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

> On 23 May, 2018, at 11:04 pm, David Miller <davem@davemloft.net> =
wrote:
>=20
> Who said anything about using an ingress qdisc to record/remember
> this information?

Now I'm *really* confused.

Are you saying that the user has to set up their own conntrack mechanism =
using extra userspace commands?  Because complicating the setup process =
that way runs directly counter to Cake's design philosophy.

 - Jonathan Morton
