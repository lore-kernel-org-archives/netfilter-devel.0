From: krunal patel <krunal.raj@gmail.com>
Subject: Re: high latency with ipset-4.2 and 2.6.27.45 kernel.
Date: Wed, 23 Jun 2010 19:44:22 +0530
Message-ID: <AANLkTimOMu3h74XG1H6o5hsx_sbXMYppemqkFW8N3prW@mail.gmail.com>
References: <AANLkTimikytx8wGmEtC0gbOng_vAyDUPVHRJWMmnm6p9@mail.gmail.com>
	<alpine.DEB.2.00.1006211518090.32109@blackhole.kfki.hu>
	<AANLkTin1A2whIiaHWa4k0NZcdGqJhpk511hBSuLZd-pB@mail.gmail.com>
	<alpine.LSU.2.01.1006211846000.17820@obet.zrqbmnf.qr>
	<AANLkTil7HS75O5WO3Bxz1S7CF5D4r1om0iWD8vSF3bF6@mail.gmail.com>
	<alpine.LSU.2.01.1006221046110.13935@obet.zrqbmnf.qr>
	<alpine.DEB.2.00.1006221057510.2237@blackhole.kfki.hu>
	<alpine.DEB.2.00.1006221151050.2393@blackhole.kfki.hu>
	<AANLkTimLe-21bu_kun2_H_o_QHltfrfx0QRjZHUeYaoX@mail.gmail.com>
	<AANLkTilEoFJ54j8kCmEebatbnoRoXF-ong5Hcl4yOIPV@mail.gmail.com>
	<1277297436.2469.583.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59609 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab0FWOOY convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jun 2010 10:14:24 -0400
Received: by iwn5 with SMTP id 5so753673iwn.19
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Jun 2010 07:14:23 -0700 (PDT)
In-Reply-To: <1277297436.2469.583.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Wed, Jun 23, 2010 at 6:20 PM, Eric Dumazet <eric.dumazet@gmail.com> =
wrote:
> Le mercredi 23 juin 2010 =E0 18:13 +0530, krunal patel a =E9crit :
>
> These affinities are buggy.
>
> You put decimal values but kernel expect hexadecimal values.
>
> You should use following power of two values :
>
> 01, 02, 04, 08, 10, 20, 40, 80
>
Sorry for such a silly mistake. But after correcting affinities my
problem is not solved :(.

Regards,
Krunal
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
