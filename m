From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset website
Date: Tue, 2 Dec 2014 09:52:53 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1412020742150.14469@blackhole.kfki.hu>
References: <547919CB.7030202@nospam.hostisimo.com> <alpine.LSU.2.11.1411290212430.31411@nerf08.vanv.qr> <547946BA.106@nospam.hostisimo.com> <alpine.LSU.2.11.1411291212290.5728@nerf08.vanv.qr> <547A0277.3040301@nospam.hostisimo.com> <547A3893.1060009@nospam.hostisimo.com>
 <alpine.DEB.2.10.1411302030150.3940@blackhole.kfki.hu> <547B8682.2090207@nospam.hostisimo.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391812-995175922-1417503392=:14469"
Cc: netfilter-devel@vger.kernel.org
To: Mike Wright <nobody@nospam.hostisimo.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:49060 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbaLBIv6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:51:58 -0500
In-Reply-To: <547B8682.2090207@nospam.hostisimo.com>
Content-ID: <alpine.DEB.2.10.1412020951040.15287@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110391812-995175922-1417503392=:14469
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.2.10.1412020951041.15287@blackhole.kfki.hu>

On Sun, 30 Nov 2014, Mike Wright wrote:

> J=F3 napot, J=F3zsef,

=DCdv=F6zletem! :-)

> html restored.
>=20
> site: http://ipset.hostisimo.com
> diff: http://ipset.hostisimo.com/diff
> bzip: http://ipset.hostisimo.com/ipset.netfilter.org.tar.bz2
>=20
> Other comments?

The htmlized manpages are renamed from <foo>.man.html to <foo>.html.=20
That's not a problem, but you created the diff without the "-N" flag, so=20
their contents are missing from the diff file.

However, the best were to separate the common parts (header, menu,=20
footer) into files and use SSI to include them into the pages.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
--110391812-995175922-1417503392=:14469--
