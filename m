From: Harald Welte <laforge@netfilter.org>
Subject: Re: iptables extensions
Date: Sun, 27 Apr 2003 14:39:27 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030427123927.GW990@sunbeam.de.gnumonks.org>
References: <20030416180232.15493.qmail@web13907.mail.yahoo.com> <20030416181404.54392.qmail@web13906.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZUxj+kVYsk1YKJSS"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Scott MacKay <scottmackay@yahoo.com>
Content-Disposition: inline
In-Reply-To: <20030416181404.54392.qmail@web13906.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ZUxj+kVYsk1YKJSS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 16, 2003 at 11:14:04AM -0700, Scott MacKay wrote:
> Hiyas,
>    I don't know if there is a 'request' area for
> development or not, but would there be any way to get
> a new function added to the extensions library?  While
> printing the field (->print()) is yippie skippie, I
> would really like it of the string representation of
> the field could be dumped into a character buffer,
> maybe using a function like:=20
> static const void sprint(const struct ipt_ip
> *ip,ipt_entry_match *match, char *sbuffer, int
> sbuffer_len);
> Basically would do what print() does, but dump the
> results into a character buffer, to examine/deliver in
> a means other than printf(). =20

As the iptables userspace was not designed to be used (as a library) by
other applications, there is no support for doing so.

With good luck, we will eventually see libiptables show up in the far
future...

> -Scott

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ZUxj+kVYsk1YKJSS
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+q89/XaXGVTD0i/8RApokAJ9sCFFHHen5jq9TlAm5aB9ZZ7LLZACcDACx
ISa0fGrl/2985HhjjlMNbcQ=
=McZA
-----END PGP SIGNATURE-----

--ZUxj+kVYsk1YKJSS--
