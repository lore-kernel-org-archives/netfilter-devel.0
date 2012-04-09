From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: ipsets and network namespaces
Date: Mon, 09 Apr 2012 08:50:32 +0800
Message-ID: <4F823258.9070902@cn.fujitsu.com>
References: <CAFJYBU3q9au5qS0_CC4kp_jsRo-r08hejhQb_nvMqXGt57WdSw@mail.gmail.com> <alpine.DEB.2.00.1204051324190.23192@blackhole.kfki.hu> <4F8149A3.1080607@cn.fujitsu.com> <alpine.DEB.2.00.1204082001370.4765@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Gorik Van Steenberge <gorik.vansteenberge@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:1701 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab2DIBdz convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Apr 2012 21:33:55 -0400
In-Reply-To: <alpine.DEB.2.00.1204082001370.4765@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=E4=BA=8E 2012=E5=B9=B404=E6=9C=8809=E6=97=A5 02:06, Jozsef Kadlecsik =E5=
=86=99=E9=81=93:
> On Sun, 8 Apr 2012, Gao feng wrote:
>=20
>> ? 2012?04?05? 19:24, Jozsef Kadlecsik ??:
>>> On Thu, 5 Apr 2012, Gorik Van Steenberge wrote:
>>>
>>>> I've noticed that when creating a new network namespace (using the=
 lxc
>>>> tools) that ipsets (userspace v6.11 on kernel 3.3.1) are still glo=
bal,
>>>> i.e. an ipset created in the container is visible in the host and =
vice
>>>> versa. Iptables rulesets, however, are isolated.
>>>>
>>>> Is this an as of yet unimplemented feature or a conscious design d=
ecision?
>>>
>>> It's an unimplemented feature - no one requested it yet ;-).
>>
>> And I see there are a lot of /proc/sys/entries are not isolated.
>> is this an unimplemented feature too?
>=20
> I don't know what you mean here. There's nothing under /proc/sys whic=
h is=20
> related to ip_set* modules.
> =20

I mean proc files such /proc/sys/net/netfilter/nf_conntrack_udp_timeout=
 are not isolated.

>> If so,I want to implement it. How do you think about this?
>=20
> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics, Hungarian Academy of Sc=
iences
>           H-1525 Budapest 114, POB. 49, Hungary
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
