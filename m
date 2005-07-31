From: Eric Leblond <eric@inl.fr>
Subject: Re: [ANNOUNCE] netfilter-2.6.14 git tree / TODO
Date: Sun, 31 Jul 2005 20:04:44 +0200
Message-ID: <1122833084.4159.24.camel@porky>
References: <20050731080143.GA10374@rama.de.gnumonks.org>
	<1122802193.4159.12.camel@porky>
	<20050731103812.GF14874@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-oTpP9w0T+OqCoB9nW/Co"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050731103812.GF14874@rama.de.gnumonks.org>
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


--=-oTpP9w0T+OqCoB9nW/Co
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2005-07-31 at 12:38 +0200, Harald Welte wrote:
> On Sun, Jul 31, 2005 at 11:29:53AM +0200, Eric Leblond wrote:
> > Hi,
> >=20
> > On Sun, 2005-07-31 at 10:01 +0200, Harald Welte wrote:
> > > Hi!

> > So, we are really interested in userspace counterparts. In particular,
> > our center of interest is libnfnetlink_queue. I will do some test in
> > the coming days to check if NuFW is working with NFQUEUE.
>=20
> great.  Please consider supporting nfnetlink_queue natively, rather than
> using the (still incomplete) compat_libipq interface.  The latter has to
> do one additional copy of every packet (to build the fake
> ipq_packet_msg_t), which you definitely want to avoid.

Ok, I will work in that direction.


> The problem are the optional attributes.  A packet from the kernel could
> optionally contain
> 	PAYLOAD
> 	MARK
> 	TIMESTAMP
> 	IFINDEX_IN
> 	IFINDEX_OUT
> 	...
> and this may change from packet to packet.  so we cannot just pass a
> fixed structure to the application program like libipq did.  OTOTH, I
> don't want the applications have to do their own netlink message parsing
> (with NFA_... macros), since that would violate the layering. Any ideas?

It reminds me the problem we had when we had to define the NuFW
protocols. We take the idea from radius protocol which can contains an
arbitrary number of fields. This works as follow :=20
start of the message contains the type of the message and its length
(calculate from the content). Then we have fields all optional
containing their type, option and length

Decomposition is the following :
MSG type | option | length
field type | option | length
DATA of field
field type | option | length
DATA of field
...
field type | option | length
DATA of field

It can easily be extended for any new fields as long as there is room in
the field type interval.

Hope this can help.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-oTpP9w0T+OqCoB9nW/Co
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBC7RK7nxA7CdMWjzIRAmBPAJ4ti2vi8dob1G6wBXfw8i+dKAw70ACgiYni
nuRSsRun9gXp+Ujy47WDtOU=
=anct
-----END PGP SIGNATURE-----

--=-oTpP9w0T+OqCoB9nW/Co--
