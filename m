From: Eric Leblond <eric@regit.org>
Subject: Re: A humble proposal
Date: Thu, 02 Oct 2003 23:26:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1065129971.561.24.camel@porky>
References: <7C9884991ADAE0479C14F10C858BCDF5122E46@alderaan.smgtec.com>
	 <20031002195132.GA5758@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8Etbbipn0g2PJTIRVAVy"
Cc: Daniel Chemko <dchemko@smgtec.com>, netfilter@lists.netfilter.org,  netfilter-devel@lists.netfilter.org, nufw-devel@nongnu.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031002195132.GA5758@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-8Etbbipn0g2PJTIRVAVy
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le jeu 02/10/2003 =C3=A0 21:51, Harald Welte a =C3=A9crit :
> On Tue, Sep 23, 2003 at 09:13:21AM -0700, Daniel Chemko wrote:
> > I have seen some of this functionality in Checkpoint, and I think that
> > it would be immensely useful in the iptables community if it is adopted=
.
>=20
> Just because a particular proprietary vendor offers a 'feature', it
> doesn't necessarrily mean that we need to do a blind copy of that
> feature.

I agree with you in the sense that we can do a better work. As I said
earlier in this thread and in this mailling list, the current tools
provided by Netfilter are great enough to build a good user
authentication system.

The NuFW project (http://www.nufw.org) has managed to build a user
authentication of packet, by (only) using libipq. We (the NuFW team)
think that in the current state of the project, we have managed to prove
the viability of the concept.

But, it's just the beginning ! With a slight modification of libipq and
of the corresponding module conbined with the use of CONNMARK, we should
be able to provide a user based marking of the connection.
If we're able to do so, the path to a user based ,QOS, bandwith sharing,
or even routing will be wide open.

We think that it's not a 'feature' but that it could really bring
something to the iptables community.

BR,
--=20
Eric Leblond
Nufw, Now User Filtering Works (http://www.nufw.org)

--=-8Etbbipn0g2PJTIRVAVy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e=2E?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQA/fJfznxA7CdMWjzIRAsA7AJ443QTCMCqGsbfTqliHz0dVqF9RdgCgk1/0
rvy/cayHdtP0+NoYrnr8+Pc=
=tfZv
-----END PGP SIGNATURE-----

--=-8Etbbipn0g2PJTIRVAVy--
