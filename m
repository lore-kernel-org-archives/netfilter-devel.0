From: Alexander Samad <alex@samad.com.au>
Subject: Re: [RFC, PATCH 5/5]: netfilter+ipsec - policy checks
Date: Sat, 20 Mar 2004 16:58:11 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040320055811.GG29442@samad.com.au>
References: <20040308110331.GA20719@gondor.apana.org.au> <404C874D.4000907@trash.net> <20040308115858.75cdddca.davem@redhat.com> <4059CF27.4030803@trash.net> <20040318221904.45011167.davem@redhat.com> <20040319063143.GC29442@samad.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NyVXgNZ34wipDCDo"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20040319063143.GC29442@samad.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--NyVXgNZ34wipDCDo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 19, 2004 at 05:31:43PM +1100, Alexander Samad wrote:
> I have applied these to 2.6.4 (debian source) and compiles okay and
> seems to work okay, ie the NAT + IPSEC
>=20
> my 2c

Done some more testing and there seems to be a problem with the NAT
table=20


Chain PREROUTING (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source
destination
   12   720            all  --  *      *       0.0.0.0/0 192.168.5.2
    0     0 DROP       all  --  *      *       169.254.0.0/16 0.0.0.0/0
54378 5744K ACCEPT     all  --  *      *       0.0.0.0/0 0.0.0.0/0         =
  state NEW

Chain POSTROUTING (policy ACCEPT 6 packets, 240 bytes)
 pkts bytes target     prot opt in     out     source destination
    0     0            all  --  *      *       0.0.0.0/0 192.168.5.2
 2872  537K MASQUERADE  all  --  *      eth0    192.168.8.0/22 0.0.0.0/0
    0     0 MASQUERADE  all  --  *      ppp+    192.168.8.0/22 0.0.0.0/0
 165K   25M ACCEPT     all  --  *      *       0.0.0.0/0 0.0.0.0/0         =
  state NEW

Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source destination
    0     0            all  --  *      *       0.0.0.0/0 192.168.5.2
 169K   25M ACCEPT     all  --  *      *       0.0.0.0/0 0.0.0.0/0         =
  state NEW


There is an ipsec tunnel out of eth0 setup like

conn abcd
	leftsubnet 192.168.8.0/22
	rightsubnet 192.168.5.0/24

when I ping from 192.168.10.244 through to 192.168.5.2 it doesn't seem
to it through to POSTROUTING, the counter in PREROUTING increase.

My initial search for this was why I did not need a rule to stop the
MASQ from happening

This is using the 2.6 stack (2.6.4 debain)

Alex

>=20
> On Thu, Mar 18, 2004 at 10:19:04PM -0800, David S. Miller wrote:
> > On Thu, 18 Mar 2004 17:32:39 +0100
> > Patrick McHardy <kaber@trash.net> wrote:
> >=20
> > > This patch makes xfrm_policy_check locate the correct policy after NA=
T.
> > > For protocols which do policy checks in their receive routines the
> > > reference to nfct has to be kept until policy checks are done, the
> > > other ones still drop it in ip_local_deliver_finish.
> >=20
> > This patch looks fine to me.
> >=20
> > Other than the minor comments I've made the most unhappy I am
> > with the input patch, and you agree it's grotty too.  Let's look
> > for a better solution, perhaps with new top-level SKB state,
> > and then we can put all of your work in after you're made the other
> > minor fixes I've asked for as well.
> >=20
> > Thanks Patrick.
> >=20
> >=20
> >=20



--NyVXgNZ34wipDCDo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAW91zkZz88chpJ2MRAmhiAKDJmNPR2D41yhpDnZyyHVVe/9fiwwCg2ttg
YdicRg4redWKLrDn11NWeKE=
=+cfW
-----END PGP SIGNATURE-----

--NyVXgNZ34wipDCDo--
