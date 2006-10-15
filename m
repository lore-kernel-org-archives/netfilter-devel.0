From: Thomas Mader <thezema@gmail.com>
Subject: Re: remove connections notification by conntrack?
Date: Sun, 15 Oct 2006 19:03:00 +0200
Message-ID: <200610151903.05371.thezema@gmail.com>
References: <200609221359.22676.thezema@gmail.com>
	<200610151501.28715.thezema@gmail.com>
	<45325D96.9090004@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2237520.7LShRghsal";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <45325D96.9090004@netfilter.org>
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

--nextPart2237520.7LShRghsal
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

We started to look into ipt_REJECT.c and searched through the code for=20
send_icmp examples but we never were successful on sending paket.
It seems the problems lies in the setup of an skb for send_icmp. As you can=
=20
see from the codesample earlier we played around with setting it up but=20
nothing worked. We also tried to generate a raw socket for it but nothing w=
as=20
successful.
We also never found a code part in the kernel where the skb is created by=20
searching on occurances of send_icmp.

On Sunday 15 October 2006 18:11, you wrote:
> Thomas Mader wrote:
> > we figured out what the problem was some time ago, sorry for the delay.
> > We forgot to put it back as you said earlier.
> > We want to publish our code soon here on the mailinglist to finish this
> > topic and to help others with our code as an example but we don't find
> > out how to send ICMP packets from kernelspace.
> > Maybe you or somebody else could point us to some code example or
> > something so we can implement it? We searched the kernel code and the n=
et
> > for examples but we wasn't successful at finding working examples.
>
> Is send_icmp what you look for? See ipt_REJECT.c, I think that it can
> serve as example.

--nextPart2237520.7LShRghsal
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iQIVAwUARTJpyRjLzKnHCDEhAQJZWg//cDYIP6sjBJ6ICzLRlIus4BpvJv7+g2Gc
1+zYEa+2QnMkzlodNcKnRY1xKkN9HmEKPNg0/MEiF+ohPyjRtW5XVrR9VzGbOLEo
O+R3dHqEi4zwQ2lPghFevl+xqc9oHZlfCLr16EnEx7UHlHmt9+S1SJ4KX9+hguC1
qjAbRTN2IAr4GbzPhR5WNCz+BLoHmCyGHGtCQodnLyeso38PVnGlr7Cn8b620zAc
ZqaVYg0BjsHyf/nBGV5MQBSXyc+p7KQqGR80F2KTpC3yEyAHvlJoFx/SGidgQ4Em
tFozR3H94/Gu1Z4nwvvRaKJgiHaUzl7eX3QwErmtLFASEb4b1b+0nDrnDKn3xO5O
S4xt0T6gpXyMTDgPGc3mpy6ak3/68G3uyTmZiA8pxaM9E84/57BlQFWnkGjlOQL6
c6HU8pZDYjMXMqUgofFLteUpcXGGNyiFoMkPd93b3VvvZ9+RpgOX3hYKUqBnunVF
WQnws8G0L1xKj6kuMxYat5U4w/Wrw8DueEDuhW47PGHWF4ATKsItQncHUGqY61Po
UGgInrRuJEVJ4stcoX0THzc4RhOAFSTukFJy4d7Zy5ZOFI0a5oRT1tISqO4dswIa
2ADNhZmOFobmIuJr6BMP1IFcM7mN+SStZOtbtx+sugATnPBJqaVzWGqDdgo72r3d
G8LrPu0XMw8=
=CVw9
-----END PGP SIGNATURE-----

--nextPart2237520.7LShRghsal--
