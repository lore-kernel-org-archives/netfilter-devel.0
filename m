From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: MAC address update
Date: Tue, 22 May 2007 00:09:47 +0200
Message-ID: <1179785387.12033.9.camel@henriknordstrom.net>
References: <00d401c797ff$b2f60230$9f0201c0@nethawk.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-5HH4DGjH1fLSrSo0SfUi"
Cc: netfilter-devel@lists.netfilter.org
To: Sarbeswar Mohapatra <Sarbeswar.Mohapatra@nethawkgroup.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <00d401c797ff$b2f60230$9f0201c0@nethawk.fi>
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


--=-5HH4DGjH1fLSrSo0SfUi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

ons 2007-05-16 klockan 16:18 -0500 skrev Sarbeswar Mohapatra:
> Hi,
> I am using netfilter hook (NF_POST_ROUTING) to create IP tunnel. In the n=
f
> hook function, the skb is expanded and added a new IP header (IP tunnel).

Hmm.. shouldn't this be done before routing?

After routing the kernel has already decided which next-hop the packet
should be sent to. If you change this after the routing is done you need
to re-route the packet, the kernel won't notice otherwise.

Regards
Henrik

--=-5HH4DGjH1fLSrSo0SfUi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUARlIYqUNPQ5Kbx8daAQLkcgP9H5kLtPEiAXClL85tMXNsjyYi5v6NNADR
QEMzSMgioZu69/7ze3CNjoBhjgLx0jBs3dHZFH5nCa6DS+BaeHselZ8MVOZCMRs6
dbZmSar/W0wOhFKIXt7iTSW0KQvkwmaCgFmebB1d0eeJ/6+U4YJi6ICBtenMrMFg
uF68Wfdnitk=
=gPKt
-----END PGP SIGNATURE-----

--=-5HH4DGjH1fLSrSo0SfUi--
