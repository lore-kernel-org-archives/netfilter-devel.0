From: Thomas Heinz <creatix@hipac.org>
Subject: Re: iptables as a state machine
Date: Fri, 01 Oct 2004 10:24:23 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <415D1437.6030503@hipac.org>
References: <20040930193955.6fa24afc.davem@davemloft.net>	<61687.63.170.215.71.1096602469.squirrel@www.osdl.org>
	<20040930210127.0ac9623c.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigB5A2EFCB99DEB3CA61C50F89"
Cc: netfilter-devel@lists.netfilter.org, shemminger@osdl.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20040930210127.0ac9623c.davem@davemloft.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB5A2EFCB99DEB3CA61C50F89
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi David

Your statement about the algorithmic approach of nf-hipac
is wrong.

You wrote:
> nf-hipac is what I was indirectly referring to when I
> said "B-Tree based schemes". :-)
> 
> nf-hipac is fast for lookups, but it does so at a huge
> cost in memory usage.

There are indeed cases where the memory consumption of
the currently implemented scheme grows huge. Nevertheless,
your explanation of why this is the case is wrong.
 From your explanation, one must conclude that nf-hipac
is not even capable of handling _any_ real world rule set.

> It uses B-Trees and prefix
> expansion, which is a well known technique for this
> task.
> 
> How prefix expansion works is basically like the following.
> Say you had a rule which matches on address "10.0.0.0/24"
> Prefix expansion would duplicate this rule 256 times, one
> for every address in that prefix'd range.
> 
> 	10.0.0.1
> 	10.0.0.2
> 	...
> 	10.0.0.255
> 
> Then you can use whatever data structure you wish to do
> an exact match lookup.  The nf-hipac folks choose a B-Tree
> although at this point you could simply use a plain hash
> as well.

Sorry David, but that is completely wrong. Doing packet
classification this way would _not_ scale, even for the
simplest rule bases.

nf-hipac views the rules geometrically. Each rule is a
hypercube in d-dimensional space (d = number of matches).
This representation is powerful enough to express each
"iptables-like" rule as one "nf-hipac" rule.
The classification is based on solving one-dimensional
problems and thus recursively reducing the d-dimensional
problem to a (d-1)-dimensional one (and so on).

> It is a classic example, in fact, of a memory usage vs.
> lookup performance tradeoff.

Its indeed a tradeoff but it's a big difference if your
rules are simply points in d-dimensional space (as you
described) or hypercubes. The latter is obviously more
expressive.

> I warn you if you go looking at the existing nf-hipac, it's
> big and complex :-)  My dislike of nf-hipac's approach is
> one of the reasons I went looking for other possible schemes.

It's of course fine to think about alternative approaches.
Did I get you right that you intend to model packet
classification as regular expression matching on the packet
header and then compute the minimal automata to represent
the expression rule base?

This approach was already considered very early in history
of packet classification. Even more complex matchings as
context free grammars have been used. Nonetheless, even
regular expressions have been found to not being able to
cope with high performance demands of todays rule bases.


Regards,

Thomas

--------------enigB5A2EFCB99DEB3CA61C50F89
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)
Comment: Using GnuPG with Debian - http://enigmail.mozdev.org

iD8DBQFBXRQ+8oNQPJ8CvngRAkJuAJ4kA4Os6bjsou5NMBTtcAm9+l1rWgCgqY3P
st+JMnq3O9JVAnlgSPMC3rU=
=g4fo
-----END PGP SIGNATURE-----

--------------enigB5A2EFCB99DEB3CA61C50F89--
