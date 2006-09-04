From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: Troubeleshooting  a  PPTP conversation
Date: Mon, 4 Sep 2006 11:22:51 -0500
Message-ID: <925A849792280C4E80C5461017A4B8A206FA79@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org,
	Mike McRae <Mike_McRae@schneidermans.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: "Patrick McHardy" <kaber@trash.net>
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

OK.  2.6.18 is also coming very soon and I hope to spin out a new
version of my stuff with 2.6.18 and some POM-ng modules when 2.6.18 is
ready.  So I can scrounge some hardware and also test with 2.6.18-rc6
here at my place if you want. =20

- Greg


-----Original Message-----
From: Patrick McHardy [mailto:kaber@trash.net]=20
Sent: Monday, September 04, 2006 11:12 AM
To: Greg Scott
Cc: netfilter-devel@lists.netfilter.org; Mike McRae
Subject: Re: Troubeleshooting a PPTP conversation

Greg Scott wrote:
>>I didn't notice any error .. are there still gre connection tracking
>=20
> entries when this error occurs?
>=20
> Yes.  Searching for "1723" in the output I posted from=20
> /proc/net/ip_conntrack, I see three entries.  The first two are from=20
> my end user.  The third ons is from somewhere else - not sure where.
> Curiously, all the IP Addresses on that third entry are internal.  I=20
> wonder why anyone would do a PPTP connection when they are already=20
> part of the network?  Here they are:
>
> [...]
>=20
> It looks like everything in here shows TCP traffic.  I don't see=20
> anything that mentions GRE specifically or protocol 47.  But that may=20
> be normal.

Depending on the state of the connection, yes. I'm currently cleaning
the helper up and noticed a few bugs. Not sure how they could lead to
something like this but I'll prepare a patch for 2.6.17 when I'm done if
you want to test it.
