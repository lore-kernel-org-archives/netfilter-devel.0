From: Cedric de Launois <delaunois@info.ucl.ac.be>
Subject: Re: [PATCH] info file for ROUTE target
Date: Fri, 10 Dec 2004 09:37:44 +0100
Message-ID: <1102667864.11255.2.camel@descartes.info.ucl.ac.be>
References: <1102603380.7528.98.camel@descartes.info.ucl.ac.be>
	<20041209195706.GA4121@oknodo.bof.de>
	<20041209212420.GD591@ti64.telemetry-investments.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: "netfilter-devel@lists.netfilter.org"
	<netfilter-devel@lists.netfilter.org>, Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
In-Reply-To: <20041209212420.GD591@ti64.telemetry-investments.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Le jeu 09/12/2004 =E0 22:24, Bill Rugolsky Jr. a =E9crit :
> ip6t_ROUTE.c doesn't build properly as a module, because it
> invokes the inline function ndisc_get_neigh(), which in turn depends on=
 the
> symbol (un-exported) symbol nd_tbl:

Indeed, the ipv6 ROUTE target doesn't compile for the reason explained
above.

> Presumably ip6t_ROUTE.c requires an out-of-line version of ndisc_get_ne=
igh()
> to be exported.

Agree.

Regards,

Cedric
