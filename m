From: Thomas Heinz <creatix@hipac.org>
Subject: Re: iptables as a state machine
Date: Fri, 01 Oct 2004 22:26:16 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <415DBD68.3040404@hipac.org>
References: <20040930193955.6fa24afc.davem@davemloft.net>	<61687.63.170.215.71.1096602469.squirrel@www.osdl.org>	<20040930210127.0ac9623c.davem@davemloft.net>	<415D1437.6030503@hipac.org>
	<20041001124608.6a6b374c.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig8D89225002BC8A89F7E4560E"
Cc: netfilter-devel@lists.netfilter.org, shemminger@osdl.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20041001124608.6a6b374c.davem@davemloft.net>
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
--------------enig8D89225002BC8A89F7E4560E
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

You wrote:
> Thanks for the correction.

You're welcome.

>>This approach was already considered very early in history
>>of packet classification. Even more complex matchings as
>>context free grammars have been used. Nonetheless, even
>>regular expressions have been found to not being able to
>>cope with high performance demands of todays rule bases.
> 
> Any pointers to papers on this topic?

http://citeseer.ist.psu.edu/rd/0%2C56411%2C1%2C0.25%2CDownload/http://citeseer.ist.psu.edu/compress/0/papers/cs/364/http:zSzzSzwww.cs.wustl.eduzSzcszSztechreportszSz1995zSzwucs-95-21.ps.gz/jayaram95efficient.ps
This paper describes the use of an optimized LR parser
for packet classification. Note that it's from 1995.

As for regular expressions, any theoretical computer
science textbook describes the way how to construct
deterministic finite automata from regular expressions
and how to compute the equivalent minimal automaton.
This approach is for example also implemented by flex.

One of the first approaches towards packet
classification was the design of dedicated virtual
machines similar to what is used in compiler
technology.

As the demand for high performance packet classification
grew, one came up with the so-called packet classification
problem which is the foundation of todays firewalling
rule sets.


Regards,

Thomas

--------------enig8D89225002BC8A89F7E4560E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)
Comment: Using GnuPG with Debian - http://enigmail.mozdev.org

iD8DBQFBXb1o8oNQPJ8CvngRAobaAJ9Iws+BsSY/wMPApAHJNQM5J4lQyACgvfDO
7q5iC2ENfUZkglVpMrBFC/0=
=qQt/
-----END PGP SIGNATURE-----

--------------enig8D89225002BC8A89F7E4560E--
