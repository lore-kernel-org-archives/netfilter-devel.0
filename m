From: Eric Leblond <eric@inl.fr>
Subject: Re: Change Packet Payload
Date: Fri, 09 Feb 2007 10:31:52 +0100
Message-ID: <1171013512.18531.5.camel@localhost>
References: <1171012218.4162.27.camel@LinuxCampo>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-TwxChQ/v94IRNxi+KziR"
Cc: netfilter-devel@lists.netfilter.org
To: Luis Campo Giralte <lcg223@tid.es>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1171012218.4162.27.camel@LinuxCampo>
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


--=-TwxChQ/v94IRNxi+KziR
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

Le vendredi 09 f=E9vrier 2007 =E0 10:10 +0100, Luis Campo Giralte a =E9crit=
 :
> Hi every one!
> im using libnetfilter_queue lib, its posible to change any value of the
> packet, source address, icmp types, payload chars, or any data of the
> packet received on the Handler (nfq_create_queue(h,0,&MyHandler,NULL))
> and send it again with the correct checksum?

Yes, but you have to compute the checksum yourself.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-TwxChQ/v94IRNxi+KziR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBFzD+InxA7CdMWjzIRAsWpAJ9AnLR8r9/zDRHH8tS5UCTAuS4fggCgjDmD
EHu7nUE6KiPOv+fwtoffIEc=
=fFey
-----END PGP SIGNATURE-----

--=-TwxChQ/v94IRNxi+KziR--
