From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: Change Packet Payload
Date: Fri, 09 Feb 2007 10:48:36 +0100
Message-ID: <1171014516.19283.41.camel@henriknordstrom.net>
References: <1171012218.4162.27.camel@LinuxCampo>
	<1171013512.18531.5.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-NpgQHb9dE9BcYM312oZY"
Cc: netfilter-devel@lists.netfilter.org
To: Luis Campo Giralte <lcg223@tid.es>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1171013512.18531.5.camel@localhost>
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


--=-NpgQHb9dE9BcYM312oZY
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

fre 2007-02-09 klockan 10:31 +0100 skrev Eric Leblond:
> Hi,
>=20
> Le vendredi 09 f=C3=A9vrier 2007 =C3=A0 10:10 +0100, Luis Campo Giralte a=
 =C3=A9crit :
> > Hi every one!
> > im using libnetfilter_queue lib, its posible to change any value of the
> > packet, source address, icmp types, payload chars, or any data of the
> > packet received on the Handler (nfq_create_queue(h,0,&MyHandler,NULL))
> > and send it again with the correct checksum?
>=20
> Yes, but you have to compute the checksum yourself.

And also make sure conntrack isn't loaded as it does not expect QUEUE to
rewrite things.. unless you QUEUE in the raw table PREROUTING before
conntrack is invoked..

Regards
Henrik

--=-NpgQHb9dE9BcYM312oZY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQCVAwUARcxDcUNPQ5Kbx8daAQKdwwP+JuZ1Hmy7mYqV/UVvnu8Wbruws7v9I19z
3mQxRlcgPpAy+uASntyr/rKUIwgTntSWUBKidtaTNjsy/weJLImIOO1jUrt9Ed38
f0nzCckqP4PVPMU5JciVrneccp/x2Y97oioGL+jksu1HExeCVfwwegFSu7uq0g93
pvUB9zquG3E=
=H8jU
-----END PGP SIGNATURE-----

--=-NpgQHb9dE9BcYM312oZY--
