From: Tom Marshall <tommy@home.tig-grr.com>
Subject: Re: [NEW TARGET] target for modifying conntrack timeout value
Date: Sun, 2 Jan 2005 11:35:59 -0800
Message-ID: <20050102193559.GA2558@home.tig-grr.com>
References: <41D7F3E7.2070002@eurodev.net>
	<EINSTEINyiGh05YFRcm0000077b@einstein.systemmetrics.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Cc: 'Netfilter Development Mailinglist' <netfilter-devel@lists.netfilter.org>,
	'Pablo Neira' <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Richard <richard@o-matrix.org>
Content-Disposition: inline
In-Reply-To: <EINSTEINyiGh05YFRcm0000077b@einstein.systemmetrics.com>
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


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > I forgot to tell you,  ip_ct_refresh was renamed to ip_ct_refresh_acct
> > in 2.6.9. Ick, the API is kinda broken now :(. Since I work with lastest
> > 2.6 bk snapshot, I needed to use the new name. I think that it would be
> > nice if you add a comment in that section of code to explain why you did
> > that?
> >=20
> ok, I changed the code to this,
> +	/* To refresh the expire timer value of a conntrack,
> +	 * linux 2.6.9 kernel starts using ip_ct_refresh_acct(),
> +	 * while older ones use ip_ct_refresh()
> +	 */
> +#ifdef ip_ct_refresh_acct
> +	ip_ct_refresh_acct(ct, 0, NULL, new_expires);
> +#else
> +	ip_ct_refresh(ct, new_expires);
> +#endif

Did you actually verify this works?

I don't see ip_ct_refresh_acct defined as a macro, only a forward decl.=20
Forward decls don't count because ifdef operates on the preprocessor level.=
=20
You'll need another way to test (netfilter version, kernel version, etc.)

--=20
Old timer, n.:
        One who remembers when charity was a virtue and not an organization.

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iEYEARECAAYFAkHYTR8ACgkQFMm9uvwPXW7iVgCfcVFstJNq8gRVuJhGx9Xac7ZY
3goAnRkhA4edX092mMv1ZUcVoVvEqdve
=MPik
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
