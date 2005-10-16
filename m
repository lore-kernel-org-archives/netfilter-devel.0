From: Harald Welte <laforge@netfilter.org>
Subject: Re: [IPTABLES] Symmetric NAT?
Date: Sun, 16 Oct 2005 16:33:52 +0200
Message-ID: <20051016143351.GC17257@rama.0sec>
References: <434FA046.8050708@neotip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Olivier GRALL <olivier.grall@neotip.com>
Content-Disposition: inline
In-Reply-To: <434FA046.8050708@neotip.com>
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

On Fri, Oct 14, 2005 at 02:10:46PM +0200, Olivier GRALL wrote:
> Hi,
>=20
> I was making some tests with STUN when I realize that my NAT box was a si=
mple Linux Box with an IPTABLES=20
> rule with a MASQ target. What seemed strange to me was that the STUN resu=
lt was "Port restricted cone ".
>=20
> I made a new with NATcheck.exe... same result.
> http://midcom-p2p.sourceforge.net/
>=20
> I was sure IPTABLES NAT was Symmetric and not Port restricted cone. What =
about it ?
> In the "Procceding of NetFilter Developer WorkShop 2004",  Harald Welte r=
eported "
>=20
> netfilter however implements (SNAT and MASQ) as ssymmetric.
> "

iptable_nat implements a fully symmetric port-overloading NAT.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie
