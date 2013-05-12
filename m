From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH 2/2] ulogd: Implement PID file writing
Date: Sun, 12 May 2013 11:47:42 +0200
Message-ID: <1368352062.22387.15.camel@ice-age.regit.org>
References: <1368291713-40132-1-git-send-email-bootc@bootc.net>
	 <1368291713-40132-3-git-send-email-bootc@bootc.net>
	 <20130511192150.GA10646@localhost> <518EA9B3.8050606@bootc.net>
	 <20130512004852.GA11205@localhost> <518F4EC7.1050403@bootc.net>
	 <20130512093405.GA12095@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ngbuLjKxnqgrDCj9hwpT"
Cc: Chris Boot <bootc@bootc.net>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:38506 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab3ELJru (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 May 2013 05:47:50 -0400
In-Reply-To: <20130512093405.GA12095@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-ngbuLjKxnqgrDCj9hwpT
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Le dimanche 12 mai 2013 =E0 11:34 +0200, Pablo Neira Ayuso a =E9crit :
> Hi Chris,
>=20
> On Sun, May 12, 2013 at 09:11:51AM +0100, Chris Boot wrote:
> > On 12/05/2013 01:48, Pablo Neira Ayuso wrote:
> > > On Sat, May 11, 2013 at 09:27:31PM +0100, Chris Boot wrote:
> > > [...]
> > >> Hi Pablo,
> > >>
> > >> I'd argue exactly the opposite point: that when you want multiple
> > >> instances a PID file can help you work out which is which.
> > > That new option may break existing setups with multiple instances.
> >=20
> > My patch explicitly doesn't change the behaviour of existing
> > configurations. If you don't pass '--pidfile /path/to/file.pid', no pid
> > file is written and there is no change in how ulogd works.
>=20
> Existing setups having already two ulogd2 instances will break, as
> they won't be passing --pidfile, thus clashing on the same default pid
> file. One of the instances will not proceed. They will have to add
> --pidfile to their scripts to get things back working.

If I read the patch correctly, the pidfile is not created if the option
is not given:

In main we have:

+       if (write_pidfile() < 0)
+               warn_and_exit(daemonize);

and in the write_pidfile() function we have:

+static int write_pidfile()
+{
+       int pid_fp;
+       char pidtext[16];
+       int len;
+
+       if (!ulogd_pidfile)
+               return 0;

So, the default behavior is not changed.

If the default behavior is not changed, I see no problem in adding the
pidfile feature. And if it can help to get ulogd into distributions, I'm
in favor of it ;)

But, as pointed out by Pablo's reading of the code, testing if we need
to write the file only inside of write_pidfile() is a bit confusing
something like:

  if (ulogd_pidfile) write_pidfile(); // add error handling here

would be better.

BR,
--
Eric

--=-ngbuLjKxnqgrDCj9hwpT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQBRj2U+nxA7CdMWjzIRApqcAJ4184H1Wr30JjpED1hPQMgZQgrMNACeINv4
+MeDqFukfe6pyLqlpenfPBE=
=r1ut
-----END PGP SIGNATURE-----

--=-ngbuLjKxnqgrDCj9hwpT--

