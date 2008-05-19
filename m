From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: TPROXY 4.1 patch?
Date: Mon, 19 May 2008 15:38:16 +0200
Message-ID: <20080519133816.GC19397@sch.bme.hu>
References: <200805181950.24777.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Anton <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from centaur.sch.bme.hu ([152.66.208.5]:40720 "EHLO
	centaur.sch.bme.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760279AbYESN7A (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 May 2008 09:59:00 -0400
Content-Disposition: inline
In-Reply-To: <200805181950.24777.anton.vazir@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On v, m=E1j 18, 2008 at 07:50:24 +0500, Anton wrote:
> Just hoping if anyone may have a working TPROXY 4.1 patch=20
> against any of 2.6.24 or 2.6.25 kernel versions?=20
>=20
> Patches provided by BALABIT on their site does not apply=20
> cleanly on the mainstream kernels (and even after manual=20
> patching of rejects kernel does not compile than, some=20
> structure inconsistancies) , I suppose the patches have=20
> been taken out of some of the kernel developments branches,=20
> but I've did not found how to download any of this=20
> branches. -git gives only stable tags, but there is just a=20
> numeric tags...
>=20
> There is some patches in the
>=20
> http://people.netfilter.org/hidden/tproxy/
>=20
> but they does not apply cleanly to a stable kernels either.

Yeah, I know. These are just the snapshots of my tproxy-devel tree at
certain times. Think of these more like development versions.

> If someone have a patch or any advice, I'd be just=20
> gratefull, TPROXY+SQUID is a great stuff btw.

The patch Attila created should just work in theory -- will give it a t=
ry
when I get home.

I'm really sorry about the confusion my snapshots and the lack of clear
instructions have caused. Attila and me will try to work harder to make=
 it
easier to install and use tproxy.

--=20
KOVACS Krisztian
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
