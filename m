From: Alexander Samad <alex@samad.com.au>
Subject: Re: Netfilter+IPsec patches in pom-ng now
Date: Wed, 21 Apr 2004 10:21:10 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040421002110.GP19221@samad.com.au>
References: <407CA248.3000302@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JrJW0wW5qTeyr+Y"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	mludvig@suse.cz, guillaume@morinfr.org, herbert@gondor.apana.org.au,
	JMChandonia@lbl.gov
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <407CA248.3000302@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--7JrJW0wW5qTeyr+Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 14, 2004 at 04:30:32AM +0200, Patrick McHardy wrote:
> I've just commited the netfilter+ipsec patches to pom-ng.
>=20
> The input patch is replaced with a new version which just
> posts packets which are done with ipsec into the stack again
> and lets them traverse the hooks at the usual places. The
> advantage is the simplicity and transparency for netfilter,
> the disadvantage is an extra pass through the stack.
>=20
> Some bugs have been fixed since the last set of patches:
>=20
> - IPIP packets decapsulated from IPsec missed the input hooks
> - multiple other problems related to the old input patch
> - compiles without CONFIG_NETFILTER
> - icmp/igmp didn't traverse POST_ROUTING before encapsulation
> - possible NULL-ptr dereference fixed
>=20
> They still need some work but mostly cleanup, nothing critical.
>=20
> The patches are split into four parts, but pom-ng does not handle
> recursive dependencies when dependant patches change the same
> piece of code and --dry-run fails, so the patches need to be
> applied manually in the right order. The patches are named in
> a way that they will appear in the correct order during "runme".

Work out my problem with 2.6.5, need to apply nf_reset patch first.



>=20
> Regards
> Patrick
>=20
> PS: I've CCed some people who showed interest, but who I think
> are not subscribed to the list. Please tell me in private if
> you want don't want these mails.
>=20

--7JrJW0wW5qTeyr+Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAhb52kZz88chpJ2MRApKlAKDo6ooyhVnOWyKQFTPQpC0fXEECjACgu4+7
ud9Gf67t0jfxSvKOLsfxKXw=
=/Hsm
-----END PGP SIGNATURE-----

--7JrJW0wW5qTeyr+Y--
