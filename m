From: Harald Welte <laforge@netfilter.org>
Subject: Re: [netfilter-core] Minor Bugs found
Date: Wed, 7 May 2003 11:42:39 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030507094239.GG6702@sunbeam.de.gnumonks.org>
References: <20030507091335.7456.qmail@mail.brawijaya.ac.id>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vmttodhTwj0NAgWp"
Cc: coreteam@netfilter.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: prima@brawijaya.ac.id
Content-Disposition: inline
In-Reply-To: <20030507091335.7456.qmail@mail.brawijaya.ac.id>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--vmttodhTwj0NAgWp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 07, 2003 at 09:13:35AM +0000, prima@brawijaya.ac.id wrote:
>=20
> Dear,=20
>=20
> I have found minor bugs related to iptables program.
> The bugs are about wasting memory spaces when the iptables (in particular=
,=20
> iptables-restore), reads from a file with many command lines for entries.
> Before it "COMMIT"-s, it builds up handle with one by one entry appended.=
=20
> Some memory spaces are not freed, each time an entry is inserted into=20
> handle.=20

We've been well aware of the memory leaks within the iptables / libiptc
implementation.  There have been several threads on it on the
netfilter-devel mailinglist.

It's just that nobody got around actually doing something against those
memory leaks. (And it is considered a minor issue, since both iptables
and iptables-restore are one-shot programs, they are executed and
terminate a very short time later).

> So, in order to save the memory spaces, we should add
>=20
> 	free(e);
>       free(saddrs);
>       free(daddrs);=20
>=20
>       if(target)
>               free(target->t);=20
>=20
>       if(opts !=3D original_opts)
>               free(opts);=20
>=20
> before do_command() in iptables.c returns.=20
>=20
> In addition to that, we should also add=20
>=20
> 	        if(opts !=3D original_opts)
>               free(opts);=20
>=20
> before merge_option() function returns.=20

would you mind implementing those changes and sending us a patch for it?
That would help a lot.

If not, could you please submit this as a bug to http://bugzilla.netfilter.=
org/

Thanks!

> Primantara HT

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--vmttodhTwj0NAgWp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+uNUPXaXGVTD0i/8RAuj+AJ9ccBTQZNSn2s5OHvLvLU0Yv/sYdwCgh508
O217fWuU00SKpm9N1mf4LPc=
=p7Oz
-----END PGP SIGNATURE-----

--vmttodhTwj0NAgWp--
