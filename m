From: Alexander Samad <alex@samad.com.au>
Subject: MARK-Operations problems
Date: Wed, 7 Jul 2004 21:57:53 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040707115753.GA22265@samad.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Cc: Fabrice MARIE <fabrice@netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi

I seem to be having some problem with the MARK-operations patch from
pom-ng.

I have applied a few patches together on a debian 2.6.7

nf_reset
policy
MARK-operations
REJECT
proc-no-internal-targets init_conntrack-optimize ipt_helper-invert-fix nf-l=
og connlimit dstlimit mport nth raw
TARPIT CLASSIFY CLASSIFY_more-hooks comment dstlimit=20
iprange
dropped-table
pool
osf

I build a static linked iptables for testing but when I attempt to run
this command=20

iptables -t mangle -I PREROUTING 1  -j MARK  --or-mark 0x1
I get iptables: Target problem
and this is dmesg MARK: targinfosize 8 !=3D 4


interesting is when i run this command against the static link iptables
iptables -t mangle -I PREROUTING 1  -j MARK  --set-mark 0x1
I get the same error, but it works okay when I use the orginial (unpatch
iptables command)

any suggestions on how to track down the error or where might be the
best place to look

Thanks
Alex

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA6+VBkZz88chpJ2MRArDQAKCxQ04blNU+EU43wtfi3fBLkg4NuACgwtla
c9Ha+1rtrm5sO8m6S89Uwt8=
=35SZ
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
