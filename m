From: "Piotr =?iso-8859-2?Q?Gasid=B3o?="
	<quaker@pandora.barbara.ds.polsl.gliwice.pl>
Subject: Re: [ANNOUNCE] Proceedings of Netfilter Developer Workshop 2004
Date: Mon, 27 Sep 2004 16:31:16 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040927143116.GB18298@barbara.eu.org>
References: <20040925213322.GJ3236@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=_pandora.barbara.ds.polsl.gliwice.pl-22823-1096295476-0001-2"
Cc: Harald Welte <laforge@netfilter.org>, lwn@lwn.net,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>,
	Netfilter Announcement List <netfilter-announce@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20040925213322.GJ3236@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_pandora.barbara.ds.polsl.gliwice.pl-22823-1096295476-0001-2
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, 25/09, 11:33:22PM, Harald Welte wrote:
> |---------------------------+----------------------------------------+---=
-----|
> |IPMARK                     |why is tc not enough to do this? Too    |No =
     |
> |                           |obscure                                 |   =
     |
> |---------------------------+----------------------------------------+---=
-----|

Target is useful when using MASQUERADE or SNAT. Using tc we are *unable*
to put outgoing trafic from single IP (behind masquerade) into queue
created on outgoing interface. With this target we can mark packets from
each internal IP and then, using tc filter fw put it into queues. This
target replaces many MARK rules, which can be really CPU hog.

--=20
Piotr 'QuakeR' Gasid=B3o, BOFH @ pandora.barbara.eu.org
############## sending lusers to /dev/null since 1998
##### Waiting for tomorrow, for a little ray of light
### Waiting for tomorrow just to see your smile again

--=_pandora.barbara.ds.polsl.gliwice.pl-22823-1096295476-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQFBWCQ0gEmu6PNADqoRAkf7AJ9LQqyywkTHjEM1ucK1IGQXu/oBtACdG2Mm
8UPAzglIIfiBm541A7WbuHQ=
=4rea
-----END PGP SIGNATURE-----

--=_pandora.barbara.ds.polsl.gliwice.pl-22823-1096295476-0001-2--
