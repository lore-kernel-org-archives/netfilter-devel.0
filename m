From: Arif Hossain <freefall1986@gmail.com>
Subject: netfilter_queue : use --queue-balance in multithreaded environment
Date: Fri, 02 Mar 2012 15:38:40 +0600
Message-ID: <1330681120.2106.14.camel@arifLaptop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ZrvuJzzWES9k5TR/Gw1j"
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60277 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab2CBJiv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Mar 2012 04:38:51 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-ZrvuJzzWES9k5TR/Gw1j
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I'm using libnetfilter_queue for userspace modification of
incoming/outgoing packets. I have been using a single threaded model.
But i've found out that from 2.6.31 kernel, its possible to have
different queues for different connection. so i was wandering if its
possible to manage each queues in different threads.

normally i set up the queue handling like bellow:

struct nfq_handle * h =3D nfq_open();
nfq_unbind_pf(h, AF_NET);
nfq_bind_pf(h,m AF_NET);
struct nfq_q_handle(h, 0, &cb, NULL);
nfq_set_mode(qh, NFQNL_COPY_PACKET, 0xffff);

now if i want to manage like 100 queues, i will pack h,qh and que_num in
a structure and loop over it to initialize.

now my question is :

if i initialize above in the main thread and want to run the callbacks
in threads, is it enough to run infinite loop in a function which will
be given to pthread_create()? Will it run the callbacks in threads?=20

i'm not sure, but my understanding tells me, a packet is popped from the
queues when nfq_set_verdict is returned. so i need to run
nfq_set_verdict in separate threads so that i packets can be popped from
queues parallel.=20
--=20
"You have a voice"
                                        ----The King's Speech

Public Key : $ gpg --keyserver keyserver.ubuntu.com --recv-key C88CFC23

--=-ZrvuJzzWES9k5TR/Gw1j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJPUJUgAAoJEDcRh2vIjPwjCtkIAKm/k/JemUOzWxI42FhuFnep
lCXpShKCVxVY187c2XSK2F9zR8BmsNjpG3/AR20LPJ5/6vhQSE9/4Re0SUsEzKPe
olblSQNgQ1BwJ9a9AGboEV5QpZpKJh0Fm5lAXv8nfOqBBfVIjRbSBlsotGAVsmR+
xT+aJIGZSoowyrhxQLEs+Fg5KVcsC52o61Vj2z4eTRuTBEr3w4J1sXWAGIbbVXSL
4Ro2BdJG7CkZMft7jY8RECjm97tBTPX+5R3paeJXUskcdghrgqVKC6ejpsQEzFmz
VkEsGCb1P+8CIhgZxpuzO6I18+rDll7w/HqOW1Djz2Poc2VFY10bVFI8uKbAvks=
=6gEn
-----END PGP SIGNATURE-----

--=-ZrvuJzzWES9k5TR/Gw1j--

