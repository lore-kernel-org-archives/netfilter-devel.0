From: Peter Surda <shurdeek@panorama.sth.ac.at>
Subject: Re: conntrack question
Date: Thu, 9 Jan 2003 14:47:02 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030109134702.GM17367@noir.cb.ac.at>
References: <3E1D7361.8030400@myland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8cpS+6Cx+xtICsjy"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <3E1D7361.8030400@myland.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--8cpS+6Cx+xtICsjy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 09, 2003 at 02:04:33PM +0100, Bart wrote:
> Hi,
hi

> E.g. if I want to monitor connections to an FTP-server, I would register=
=20
> a helper
> with destination-port set to 21, but this ain't the way it works,=20
> because I saw that
> the ftp/irc contrack helpers register a helper with a source port set,
> why ?
I assume because the conntrack works in both directions, you can run both a
server and a client behind it.

> Tnx,
> greetz
Bye,

Peter Surda (Shurdeek) <shurdeek@panorama.sth.ac.at>, ICQ 10236103, +436505=
122023

--
              The best things in life are free, but the
                expensive ones are still worth a look.

--8cpS+6Cx+xtICsjy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+HX1WzogxsPZwLzcRAj7vAKCHrLDl7s7TBkcQ1SZ73hNOGIy69gCfRbVI
pS2GmdDNRBBhN156sWypKMo=
=fmFm
-----END PGP SIGNATURE-----

--8cpS+6Cx+xtICsjy--
