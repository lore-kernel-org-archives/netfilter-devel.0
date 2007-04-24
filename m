From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: Libipq problem
Date: Tue, 24 Apr 2007 15:50:04 +0200
Message-ID: <1177422604.3032.1.camel@henriknordstrom.net>
References: <f015bcab0704190221u70fe1d9by1808eac18f53e669@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-d8MNbLi6xf5egHaTDn8/"
Cc: netfilter-devel@lists.netfilter.org
To: miguel Angel Vazquez <mikinho21@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <f015bcab0704190221u70fe1d9by1808eac18f53e669@mail.gmail.com>
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


--=-d8MNbLi6xf5egHaTDn8/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

tor 2007-04-19 klockan 11:21 +0200 skrev miguel Angel Vazquez:

> It works, correcting the checksums, the total lenght of the
> packet...but when it reinjects and send the package it produces some
> incompleted copies of the sent package in the queue. My receiver is
> reciving 2 "bad-repeated" packages (3 packages at all).

Hmm.. how do you handle TCP sequence numbers in this rewrite chain?

Regards
Henrik

--=-d8MNbLi6xf5egHaTDn8/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUARi4LCENPQ5Kbx8daAQJk0wP/eu4jTxEjtqVlS+6lkIcOmxBwAfIID7sJ
evTjdcZhmWUJqf2yvOrlnQUrJrqq74+BSrKJuD8D6iM8MjS1a+UPpND8R8aipXkc
4f1RI51j5yr308YbowN90DWHG9OWQ3gQOmD+yGzUx5W27aDaNQAkjFbG6pEBEtXI
FtIPzf1SETE=
=1bPY
-----END PGP SIGNATURE-----

--=-d8MNbLi6xf5egHaTDn8/--
