From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [RFC]: ip_conntrack breaks UDP PMTU
Date: Fri, 14 Feb 2003 15:55:21 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030214145521.GB17921@sunbeam.de.gnumonks.org>
References: <20030214080612.GN14794@sunbeam.de.gnumonks.org> <3E4CF238.2030207@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	coreteam@netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3E4CF238.2030207@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 14, 2003 at 02:42:16PM +0100, Patrick McHardy wrote:

> Usually all fragments except the last one will have equal size, so the
> fragment sizes can be stored as (size, boundary) tuples. I would
> suggest making the max.

yes, usually.  But if we implement this 'fragment-backlog', we should do
it as good as possible. =20

I see people already whining about 'firewall can be detected because
overlapping fragments are not present after passing through' or stuff
like this :((

> number of different fragment sizes fixed or controllable via sysctl and=
=20
> set it to some low default (like 4). This would reduce the amount of
> memory per reassembled packet to 4 * (2b + 2b) =3D 16b.

so what do we do if the number is exceeded?  fallback to current
behaviour?

Thanks for your feedback.

> Bye,
> Patrick

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+TQNZXaXGVTD0i/8RAneFAJ0XOHUnfLqb1pCEf/1vdG0KLcGndwCfViGZ
r968R7AOGZV8bmHlRjiZHXU=
=DQhn
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
