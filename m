From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: Netfilter module help
Date: Sun, 13 Jul 2008 23:54:17 +0200
Message-ID: <1215986057.13491.8.camel@henriknordstrom.net>
References: <13f1ba4c0807091558m5fff70ear7515557278001922@mail.gmail.com>
	 <alpine.LNX.1.10.0807100127040.27323@fbirervta.pbzchgretzou.qr>
	 <13f1ba4c0807091641j33a9ebe0ocbe6c0cb95883159@mail.gmail.com>
	 <1215648362.11885.5.camel@henriknordstrom.net>
	 <13f1ba4c0807091754oca9211dxd4166c1b56c0c66@mail.gmail.com>
	 <13f1ba4c0807121328m527a4fclcf5df079cf7cc836@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ib+oMGpPSMluMoLG0nmj"
Cc: netfilter-devel@vger.kernel.org
To: tung tran <tunghack@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vps1.henriknordstrom.net ([195.20.207.177]:44434 "EHLO
	vps1.henriknordstrom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971AbYGMVyW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Jul 2008 17:54:22 -0400
In-Reply-To: <13f1ba4c0807121328m527a4fclcf5df079cf7cc836@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-Ib+oMGpPSMluMoLG0nmj
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On l=C3=B6r, 2008-07-12 at 16:28 -0400, tung tran wrote:
> I have another question, if I use QUEUE, is there any way  that I can
> pass a packet back to a chain after processing it? For example, I use
> libipq to receive a packet from kernel (through the special QUEUE
> chain) and process the packet.  After processing the packet, I do not
> want to ACCEPT or REJECT the packet, but pass it back to a different
> chain, for example INPUT. Can I do this?

The verdict from the QUEUE handler needs to be a final ACCEPT/DROP
verdict from that chain.

But on ACCEPT the packet continues as if the iptables rule had been an
ACCEPT rule. The next priority handler will be called in the netfilter
hook, and then the packet will continue in the ip stack as usual..

So you can use QUEUE in PREROUTE, return ACCEPT and then see it in INPUT
again as that a different hook.

You can also use QUEUE in the raw table and then see the packet in
filter/mangle/nat as these are different even if you are using the same
hook.

Regards
Henrik

--=-Ib+oMGpPSMluMoLG0nmj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUASHp5hkNPQ5Kbx8daAQIiIwP9Enpl/9V7lRs6sdqpuEGRT5US8Dyes9/g
o/fOQ1xIthTFNZEaSF2PPaMPsypd+5iiVFip70gJhNpBlwizfTr5j1CvXjvS3pcx
AfsLsiGFJGxGGAlWPAVUVwwPgRnlYVPBaPo5vcFG2kJD4erKpy6pIiCR5xI5H9l3
Ft8L3bWH4Bg=
=jF10
-----END PGP SIGNATURE-----

--=-Ib+oMGpPSMluMoLG0nmj--

