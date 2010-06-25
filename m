From: krunal patel <krunal.raj@gmail.com>
Subject: Re: high latency with ipset-4.2 and 2.6.27.45 kernel.
Date: Fri, 25 Jun 2010 19:19:47 +0530
Message-ID: <AANLkTing_IaYjNhkuRIH8DJ7eQH4mLp5IZmAQ-Eb8oWP@mail.gmail.com>
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
	<AANLkTimOMu3h74XG1H6o5hsx_sbXMYppemqkFW8N3prW@mail.gmail.com>
	<alpine.DEB.2.00.1006232157580.6811@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63646 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab0FYNts convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:49:48 -0400
Received: by iwn41 with SMTP id 41so2016696iwn.19
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Jun 2010 06:49:47 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1006232157580.6811@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 24, 2010 at 1:30 AM, Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
> On Wed, 23 Jun 2010, krunal patel wrote:
>
>> On Wed, Jun 23, 2010 at 6:20 PM, Eric Dumazet <eric.dumazet@gmail.co=
m> wrote:
>> > Le mercredi 23 juin 2010 ? 18:13 +0530, krunal patel a ?crit :
>> >
>> > These affinities are buggy.
>> >
>> > You put decimal values but kernel expect hexadecimal values.
>> >
>> > You should use following power of two values :
>> >
>> > 01, 02, 04, 08, 10, 20, 40, 80
>> >
>> Sorry for such a silly mistake. But after correcting affinities my
>> problem is not solved :(.
>
> Then please report what kind of network hardware you have got (exact =
type,
> version), the version of the network driver if that comes from outsid=
e of
> the kernel source and *any* non-default network related kernel parame=
ter
> and setting.
>
> And running oprofile could help as well.
>
> Best regards,
> Jozsef
> -
> E-mail =A0: kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : KFKI Research Institute for Particle and Nuclear Physics
> =A0 =A0 =A0 =A0 =A0H-1525 Budapest 114, POB. 49, Hungary
>

oops, Eric is correct. I have misconfigured irq affinities in
2.6.27.45. Things are working fine with proper affinities !!!!!
Binding In-out interface pairs to a single core solved the issue.

># cat /proc/irq/202/smp_affinity
>32
># cat /proc/irq/203/smp_affinity
>16
># cat /proc/irq/204/smp_affinity
>08
># cat /proc/irq/205/smp_affinity
>04
># cat /proc/irq/206/smp_affinity
>02
># cat /proc/irq/207/smp_affinity
>01
># cat /proc/irq/208/smp_affinity
>16
># cat /proc/irq/209/smp_affinity
>16
># cat /proc/irq/210/smp_affinity
>ff
># cat /proc/irq/211/smp_affinity
>64

changed to
# cat /proc/irq/202/smp_affinity
80
# cat /proc/irq/203/smp_affinity
80
# cat /proc/irq/204/smp_affinity
40
# cat /proc/irq/205/smp_affinity
40
# cat /proc/irq/206/smp_affinity
20
# cat /proc/irq/207/smp_affinity
20
# cat /proc/irq/209/smp_affinity
10
# cat /proc/irq/210/smp_affinity
01
# cat /proc/irq/211/smp_affinity
01


Regards,
Krunal
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
