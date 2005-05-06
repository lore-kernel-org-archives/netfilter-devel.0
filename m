From: Harald Welte <laforge@netfilter.org>
Subject: Re: iptables-batch 2nd try
Date: Fri, 6 May 2005 13:41:51 +0200
Message-ID: <20050506114151.GJ30482@sunbeam.de.gnumonks.org>
References: <20050421122008.GA22032@suse.de> <426BC783.3030603@trash.net>
	<20050427125808.GA16169@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Vh31efl4+3BNPW2z"
Cc: Ludwig Nussel <ludwig.nussel@suse.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050427125808.GA16169@suse.de>
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


--Vh31efl4+3BNPW2z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ludwig!

Sorry for my delayed response.

On Wed, Apr 27, 2005 at 02:58:08PM +0200, Ludwig Nussel wrote:
> + *	iptables -- IP firewall administration for kernels with
> + *	firewall table (aimed for the 2.3 kernels)
> + *
> + *	See the accompanying manual page iptables(8) for information
> + *	about proper usage of this program.

well those two comments are no longer valid, that's for sure ;)
> +	fprintf(stderr, "Usage: %s [FILE]\n\n", program_name);
> +	puts("Read iptables commands from FILE, commit them at EOF\n");
> +	puts("In addition to normal iptables calls the commands");
> +	puts("'commit' and 'exit' are understood.");
> +	exit(0);

So why don't you put some simple parser/converter in front of
iptables-restore?  I mean, iptables-restore does pretty much the same,
just that it expects the input format to be something different than a
shell script.

Those differences should be quite easy to convert (probably even in some
shell or perl script).  Basically all you need to do is to remove the
"iptables" from the beginning of the command, and add the COMMIT line at
the end.  Even though "-P" and "-N" are not used.

Please correct me if I'm missing something completely.

My main objective is that the functionality between iptables-restore and
iptables-batch is pretty much the same.  I think either a converter
before iptables-restore, or modifications to iptables-restore would be a
better way.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Vh31efl4+3BNPW2z
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCe1f/XaXGVTD0i/8RAnxVAJ93+dY9ykEh3pS1/+Xdbh8IrPgetQCghx0P
bR5BIi9pbWNJ/2AAvmeo3jw=
=05XN
-----END PGP SIGNATURE-----

--Vh31efl4+3BNPW2z--
