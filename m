From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] modification in current protocol helper API to handle
	error/unclean packets
Date: Sun, 20 Jun 2004 21:17:56 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1087759076.9146.32.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.33.0406141551410.12847-100000@blackhole.kfki.hu>
	 <40D18A0B.2070101@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-B7ZKKgPwM2xzZztGbBZs"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <40D18A0B.2070101@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-B7ZKKgPwM2xzZztGbBZs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2004-06-17 at 14:09, Pablo Neira wrote:

[snip]

> - Jozsef, I resolve to use your inverse return value but I must confess=20
> that I'm still thinking about another way to do that with no sucess,=20

What's the deal with these inverse return values in tcp-window-tracking
and now conntrack_error-api?

Sometimes we return NF_ACCEPT and sometimes we return -NF_ACCEPT which
have two completely diffrent meanings. That's really really ugly.

As I've understod it we have two cases:
1. We want to return NF_* all the way back to the netfilter core.
2. We want conntrack to continue processing the packet.

And we need a way to distinguish these returnvalues.

My suggestion is that when we want NF_* we return NF_* and if we want
conntrack to continue we return CONNTRACK_CONT which is defined as -1
All NF_* macros are >=3D 0

Instead of checking for a negative returnvalue as we do today we check
!=3D CONNTRACK_CONT and then return the value previously returned to us.

In my oppinion that would greatly improve the readability of the code.
The mixing of negative and positive values using the same macro=20
confuses me sometimes to say the least. I bet I'm not the only one that
sometimes has to look twice at the return value.

Have I missed something?
If not and noone objects I'll fix it up in cvs unless someone beats me
to it.

> well this issue is not important. BTW, you also modified conntrack core=20
> in your tcp-window-tracking patch, do you think that I could add that=20
> part to my patch since I think that it's more related stuff and your=20
> patch will go on top of this?
> - I'll work on that extra patch to check for malformed udp/icmp packets=20
> these days.

I fixed the length checking in the udp part of the second patch.
It compared lengths in network byteorder, added two missing ntohs()
Now udp works again :)

--=20
/Martin

--=-B7ZKKgPwM2xzZztGbBZs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBA1eLkWm2vlfa207ERApb/AJ9K++s3atYYUnsoZrXbUxAk3Q3niwCgm0NJ
H53lb07fqSobOrqTX53jGyA=
=JfN6
-----END PGP SIGNATURE-----

--=-B7ZKKgPwM2xzZztGbBZs--
