From: Patrick McHardy <kaber@trash.net>
Subject: Re: [Patch 0/2] Avoid direct connections between NATed hosts
Date: Wed, 17 Jan 2007 13:13:26 +0100
Message-ID: <45AE12E6.2080308@trash.net>
References: <1168621167.28615.14.camel@localhost.localdomain>
	<200701121911.48617@auguste.remlab.net>
	<45A7C377.2060600@trash.net>
	<200701121939.42232@auguste.remlab.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?ISO-8859-15?Q?R=E9mi_Denis-Courmont?= <rdenis@simphalempin.com>
In-Reply-To: <200701121939.42232@auguste.remlab.net>
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

R=E9mi Denis-Courmont wrote:
> Le vendredi 12 janvier 2007 19:20, Patrick McHardy a =E9crit :
>=20
>>Port randomization would still be a useful feature, not to wilfully
>>break skype, but to make spoofing attacks harder. Currently we
>>undo randomization done by the operating system/application. Since
>>its optional I don't see real harm in it.
>=20
>=20
> Right, randomizing port numbers when they are allocated can make it=20
> slightly more difficult to spoof DNS. Does the "regular" socket code=20
> picks port at random or not though? And is the port allocation logic=20
> shared between socket and NAT code (IMHO it should either be shared or=20
> at least be equivalent)? It makes little sense to secure host behind=20
> the NAT and not secure yourself; that also imples there should be no=20
> need for an iptables option to enable/disable it.

Its not shared, local port allocation is quite different from NAT.

> My concern is with when (and how) Netfilter NAT code allocates a new=20
> port number. If the source private-IP/port are identical, the external=20
> NATed-IP/port ought be identical too, and certainly not another=20
> randomized value.
>=20
> With that, you have the advantage of random source port numbers (better=
=20
> spoof protection), while not breaking any NAT-aware P2P app.

Thats impossible to guarantee, since we're mapping many address to
one we might get clashes.
