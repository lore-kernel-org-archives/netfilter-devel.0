From: Cedric de Launois <delaunois@info.ucl.ac.be>
Subject: Re: ipt_ROUTE bug
Date: Wed, 09 Mar 2005 13:27:40 +0100
Message-ID: <1110371260.11906.80.camel@descartes.info.ucl.ac.be>
References: <1110370278.7508.13.camel@lion>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
To: John Leach <john@johnleach.co.uk>
In-Reply-To: <1110370278.7508.13.camel@lion>
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

Le mercredi 09 mars 2005 =E0 12:11 +0000, John Leach a =E9crit :
> on compiling 2.6.11 with the ROUTE target patched in from patch-o-matic
> snapshot 20050307, I get the following compile error:
>=20
>   CC      net/ipv4/netfilter/ipt_ROUTE.o
> net/ipv4/netfilter/ipt_ROUTE.c: In function `init':
> net/ipv4/netfilter/ipt_ROUTE.c:452: error: structure has no member name=
d
> `initialized'
> make[4]: *** [net/ipv4/netfilter/ipt_ROUTE.o] Error 1
> make[3]: *** [net/ipv4/netfilter] Error 2
> make[2]: *** [net/ipv4] Error 2
> make[1]: *** [net] Error 2

This bug has already been fixed. See bugzilla #284.
The patch from Phil Oester has been committed to the
http://svn.netfilter.org/cgi-bin/viewcvs.cgi/branches/patch-o-matic-ng/li=
nux-2.6.11 tree (Rev 3691)

Cedric

> the lines causing the problem are in the init() function:
>=20
>         /* Initialize fake conntrack so that NAT will skip it */
>         route_tee_track.nat.info.initialized |=3D
>                 (1 << IP_NAT_MANIP_SRC) | (1 << IP_NAT_MANIP_DST);
>=20
> looking at ip_nat_init() in ip_nat_core.c my guess would be this should
> be replaced with:
>=20
>         route_tee_track.status |=3D IPS_NAT_DONE_MASK;
>=20
> any comments?  I'm not at all familiar with the netfilter code, or even
> kernel programming :S
>=20
> John.
