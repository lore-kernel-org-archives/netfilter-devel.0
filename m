From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: high latency with ipset-4.2 and 2.6.27.45 kernel.
Date: Wed, 23 Jun 2010 22:00:59 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1006232157580.6811@blackhole.kfki.hu>
References: <AANLkTimikytx8wGmEtC0gbOng_vAyDUPVHRJWMmnm6p9@mail.gmail.com> <alpine.DEB.2.00.1006211518090.32109@blackhole.kfki.hu> <AANLkTin1A2whIiaHWa4k0NZcdGqJhpk511hBSuLZd-pB@mail.gmail.com> <alpine.LSU.2.01.1006211846000.17820@obet.zrqbmnf.qr>
 <AANLkTil7HS75O5WO3Bxz1S7CF5D4r1om0iWD8vSF3bF6@mail.gmail.com> <alpine.LSU.2.01.1006221046110.13935@obet.zrqbmnf.qr> <alpine.DEB.2.00.1006221057510.2237@blackhole.kfki.hu> <alpine.DEB.2.00.1006221151050.2393@blackhole.kfki.hu>
 <AANLkTimLe-21bu_kun2_H_o_QHltfrfx0QRjZHUeYaoX@mail.gmail.com> <AANLkTilEoFJ54j8kCmEebatbnoRoXF-ong5Hcl4yOIPV@mail.gmail.com> <1277297436.2469.583.camel@edumazet-laptop> <AANLkTimOMu3h74XG1H6o5hsx_sbXMYppemqkFW8N3prW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
To: krunal patel <krunal.raj@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:50490 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab0FWUBA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jun 2010 16:01:00 -0400
In-Reply-To: <AANLkTimOMu3h74XG1H6o5hsx_sbXMYppemqkFW8N3prW@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 23 Jun 2010, krunal patel wrote:

> On Wed, Jun 23, 2010 at 6:20 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > Le mercredi 23 juin 2010 ? 18:13 +0530, krunal patel a ?crit :
> >
> > These affinities are buggy.
> >
> > You put decimal values but kernel expect hexadecimal values.
> >
> > You should use following power of two values :
> >
> > 01, 02, 04, 08, 10, 20, 40, 80
> >
> Sorry for such a silly mistake. But after correcting affinities my
> problem is not solved :(.

Then please report what kind of network hardware you have got (exact type, 
version), the version of the network driver if that comes from outside of 
the kernel source and *any* non-default network related kernel parameter 
and setting.

And running oprofile could help as well.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
