From: Cedric de Launois <delaunois@info.ucl.ac.be>
Subject: Re: [PATCH] ROUTE target fixes for --iif
Date: Wed, 05 May 2004 14:04:19 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1083758659.2743.8.camel@descartes.info.ucl.ac.be>
References: <20040504200151.GA30514@ti64.telemetry-investments.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
In-Reply-To: <20040504200151.GA30514@ti64.telemetry-investments.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Le mar 04/05/2004 =E0 22:01, Bill Rugolsky Jr. a =E9crit :
> I mailed several ROUTE target fixes to C=E9dric de Launois about two
> weeks ago, but they weren't ACK'd, so I'm posting a combined patch agai=
nst
> patch-o-matic-ng here.

Yes, apologies for that. I'm quite busy these days...

> Fixes:
>   o Insert missing dev_put() following dev_get_by_name().
>   o Don't decrement TTL on packets re-injected with route_iif().
>   o Fix cut-n-paste error in route_iif() debug message().
>   o Dead code removal and a few cleanups.

Thanks for your patch. Now I can drop this from my to-do list ;)

Concerning the TTL, what happens if you re-inject the packet
on the same interface ? If you don't decrement the TTL, you
might introduce a loop, no ? Could you check this ?

> I'm using the ROUTE target --iif functionality, in combination with the
> teql round-robin packet scheduler, to remap incoming packets on multipl=
e
> interfaces (in this case hdlc[0-3]) to teql0.  [teql only schedules out=
going
> packets; incoming packets appear on the underlying interfaces.]

Great, maybe could you detail this example so that it can be
added in the netfilter pom documentation ?

Cedric
