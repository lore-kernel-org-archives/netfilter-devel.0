From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] ROUTE target fixes for --iif
Date: Wed, 5 May 2004 12:25:00 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0405051224311.29939-100000@blackhole.kfki.hu>
References: <20040504200151.GA30514@ti64.telemetry-investments.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <netfilter-devel@lists.netfilter.org>,
	=?iso-8859-1?Q?C=E9dric?= de Launois <delaunois@info.ucl.ac.be>
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

Hi Bill,

On Tue, 4 May 2004, Bill Rugolsky Jr. wrote:

> I mailed several ROUTE target fixes to C=E9dric de Launois about two
> weeks ago, but they weren't ACK'd, so I'm posting a combined patch agains=
t
> patch-o-matic-ng here.
>
> Fixes:
>
>   o Insert missing dev_put() following dev_get_by_name().
>
>   o Don't decrement TTL on packets re-injected with route_iif().
>
>   o Fix cut-n-paste error in route_iif() debug message().
>
>   o Dead code removal and a few cleanups.

Thanks, patch is applied.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
