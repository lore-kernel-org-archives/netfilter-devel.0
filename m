From: Michael Richardson <mcr@sandelman.ottawa.on.ca>
Subject: Re: New extension: CRYPT target
Date: Sun, 21 May 2006 18:54:30 -0400
Message-ID: <9699.1148252070@sandelman.ottawa.on.ca>
References: <44708E68.9080508@speedy.com.ar>  <4470A895.5090707@rtij.nl>
Cc: Gervasio Bernal <gervasiobernal@speedy.com.ar>,
	Martijn Lievaart <m@rtij.nl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: Message from Martijn Lievaart <m@rtij.nl>
	of "Sun, 21 May 2006 19:51:17 +0200." <4470A895.5090707@rtij.nl>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


>>>>> "Martijn" == Martijn Lievaart <m@rtij.nl> writes:
    Martijn> Does -mode cbc use the iv from the last packet? If not,

  That method, which IPsec has suggested for awhile, turns out to be 
less than ideal. 
  see http://www.hut.fi/~svaarala/espiv.pdf

  Well, that URL is no longer valid... try:

   http://www.samivaarala.com/publications/espiv_final.pdf

    Martijn> this seems like a false sense of security. Protocols that
    Martijn> use lots of small packets will still more or less have the
    Martijn> drawbacks of ecb.

  ecb mode is just not useful.
  If you want network encryption, use it: it's called IPsec.

  If you want snake oil, then I guess this is the code for you.

  I recommend against including this functionality.

- -- 
]       ON HUMILITY: to err is human. To moo, bovine.           |  firewalls  [
]   Michael Richardson,    Xelerance Corporation, Ottawa, ON    |net architect[
] mcr@xelerance.com      http://www.sandelman.ottawa.on.ca/mcr/ |device driver[
] panic("Just another Debian GNU/Linux using, kernel hacking, security guy"); [

    "The Microsoft _Get the Facts CD_ does not work on Linux." - orospakr





-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)
Comment: Finger me for keys

iQEVAwUBRHDvm4CLcPvd0N1lAQIPFgf+N9Vpe+9FpjmCcZKw708ja1vp5MmjRP8k
sQKOsjiwGe37/0u7g4wlX5SsAZ5ns9lloWZUWV65z+QeMal/2eBZb90H+E9cpjYy
4XKqBwUe3C9Oe6iJywL6FVY/4Q/VQ2nJhhei5s65MwTynevJ4oTAbUSF2yVqlSbM
YR5t+QMnXYVRkX8TmOKG51hTtC+PTp24RL/Gvl0QL/BPBubojGYnxY/P0X9m1i7y
jfhtwFmI352NsQJuqWXizHgcE39nj69ycpPT2FWf5FoXVR73cTg/+zfRZ6wHcx7U
360SUkwPfY2VUg/l0lpQDPSCOQV8heJqp1MgG+8Nn7dS54VEbwl0KQ==
=/0uZ
-----END PGP SIGNATURE-----
