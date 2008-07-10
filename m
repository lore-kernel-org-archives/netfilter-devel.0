From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: Netfilter module help
Date: Thu, 10 Jul 2008 02:06:02 +0200
Message-ID: <1215648362.11885.5.camel@henriknordstrom.net>
References: <13f1ba4c0807091558m5fff70ear7515557278001922@mail.gmail.com>
	 <alpine.LNX.1.10.0807100127040.27323@fbirervta.pbzchgretzou.qr>
	 <13f1ba4c0807091641j33a9ebe0ocbe6c0cb95883159@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lunh1DO1+x6XStWHjv9s"
Cc: netfilter-devel@vger.kernel.org
To: tung tran <tunghack@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vps1.henriknordstrom.net ([195.20.207.177]:41313 "EHLO
	vps1.henriknordstrom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbYGJAGL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jul 2008 20:06:11 -0400
In-Reply-To: <13f1ba4c0807091641j33a9ebe0ocbe6c0cb95883159@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-lunh1DO1+x6XStWHjv9s
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On ons, 2008-07-09 at 18:41 -0500, tung tran wrote:
> Hi Jan,
> Thanks for your quick reply. Could you please give me some advices to
> accomplish the task? I need to pass the packet from kernel to a user
> space process to decide if the packet is accepted or denied.

For that the existing NF_QUEUE mechanism should be used. If a hook
returns NF_QUEUE then the kernel suspends the packet and submits it to a
queue handler for querying the userspace. When the userspace responds
the packet is either rejected or allowed to continue processing at the
next hook handler.

The normal ip_queue handler uses netlink to talk to userspace.

There can only be one queue handler in the system.

iptables has support for this via the QUEUE psuedo-target.

Regards
Henrik

--=-lunh1DO1+x6XStWHjv9s
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUASHVSZ0NPQ5Kbx8daAQLQTwQAiP0NLxUTLzkfADiFkGs/Q9vOBA71u0X8
5m4pB6c347u7gW02425XjsHVQfDoBrTUeM51lIw9FGdyZER/pK5/b2MNvEN2EtcS
v5poGtFNF/NzjC9muuoxhakNj9yB4KRFnOPEGLtYkskKd9O7XgLznJqsgX+IOM66
Anz+qWQvv6M=
=u9pA
-----END PGP SIGNATURE-----

--=-lunh1DO1+x6XStWHjv9s--

