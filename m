From: Stephen Frost <sfrost@snowman.net>
Subject: Re: ipsec patches test: minor compilation and policy match issues
Date: Tue, 13 Jul 2004 12:10:21 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040713161021.GO21419@ns.snowman.net>
References: <20040415212034.GE7611@obs.bg> <20040713023700.GM21419@ns.snowman.net> <40F34EF2.2010405@trash.net> <20040713115306.GN21419@ns.snowman.net> <40F4062B.9060308@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bnUi9GzdSM4S/DMA"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <40F4062B.9060308@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--bnUi9GzdSM4S/DMA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Patrick McHardy (kaber@trash.net) wrote:
> Stephen Frost wrote:
> >Ahhh, now that makes much more sense.  I just had 'require' before.  I'm
> >getting closer it seems.  Now, at least, I seem to be able to match the
> >number I put after the 'unique:' using '--reqid'.  Still doesn't work
> >when using '--spi' though.  Not sure that I care though, unless someone
> >can tell me a reason why I should?  It's important, of course, to match
> >the right packets, since I'm doing tunneling and different remote sites
> >will have access to different things and so different firewall rules to
> >handle them...
>=20
> Ooops, right, that was the --reqid option. I need to update the manpage
> again ;) Not sure what the problem with --spi is, I will test is myself
> soon.

Okay, thanks.  For --reqid...  Do you think that's sufficient to base
firewall rules off of?  Can it be somehow 'faked' by the
remote/potentially untrusted side?  That's my main issue.  If it can't
and will only match if the ipsec packet is valid and coming from that
network then I don't need to care about --spid and will just use
--reqid...

	Thanks,

		Stephen

--bnUi9GzdSM4S/DMA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA9AltrzgMPqB3kigRAr2EAJ0VQBzvOk3rNwE9Nm78gkwKpBaIUgCeL/oE
YvPYdlkFixCnPHm2Bim7Ikg=
=8fgq
-----END PGP SIGNATURE-----

--bnUi9GzdSM4S/DMA--
