From: Harald Welte <laforge@netfilter.org>
Subject: Re: Problems determining the correct tcp header size
Date: Wed, 26 Mar 2003 16:35:02 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030326153502.GB21953@sunbeam.de.gnumonks.org>
References: <3E809133.4050400@pandora.be>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SvF6CGw9fzJC4Rcx"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: qber66 <tim.vandermeersch@pandora.be>
Content-Disposition: inline
In-Reply-To: <3E809133.4050400@pandora.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--SvF6CGw9fzJC4Rcx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 25, 2003 at 06:26:11PM +0100, qber66 wrote:
> Hi,
>=20
> I'm making a new target for iptables, but I'n having a problems with=20
> determining the correct tcp header lenght in the following function:
>=20
> static unsigned int ipt_mytarget_target(struct sk_buff **pskb, unsigned=
=20
> int hooknum,
>        const struct net_device *in, const struct net_device *out,
>        const void *targetinfo, void *userinfo)
> {
>    struct tcphdr *tcph =3D (struct tcphdr *) (*pskb)->h.th;

you cannot blindly assume that all packets are tcp.

> I get the following output:
>=20
> iphdr lenght: 20, tcphdr lenght: 0
> iphdr lenght: 20, tcphdr lenght: 16
> iphdr lenght: 20, tcphdr lenght: 4

> Can any one tell me what I'm doing wrong?

maybe it's non-tcp packets?

> Thanks in advance,
> Tim Vandermeersch.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--SvF6CGw9fzJC4Rcx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+gcimXaXGVTD0i/8RAoVHAJ4wprhw4VnffSdBVk8hxBZscU4vbgCfTNB1
BZyp+5M9T12tP73vA+fLC88=
=1d8X
-----END PGP SIGNATURE-----

--SvF6CGw9fzJC4Rcx--
