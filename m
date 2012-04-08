From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: ipsets and network namespaces
Date: Sun, 08 Apr 2012 16:17:39 +0800
Message-ID: <4F8149A3.1080607@cn.fujitsu.com>
References: <CAFJYBU3q9au5qS0_CC4kp_jsRo-r08hejhQb_nvMqXGt57WdSw@mail.gmail.com> <alpine.DEB.2.00.1204051324190.23192@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Gorik Van Steenberge <gorik.vansteenberge@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:54030 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab2DHIRN convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Apr 2012 04:17:13 -0400
In-Reply-To: <alpine.DEB.2.00.1204051324190.23192@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=E4=BA=8E 2012=E5=B9=B404=E6=9C=8805=E6=97=A5 19:24, Jozsef Kadlecsik =E5=
=86=99=E9=81=93:
> On Thu, 5 Apr 2012, Gorik Van Steenberge wrote:
>=20
>> I've noticed that when creating a new network namespace (using the l=
xc
>> tools) that ipsets (userspace v6.11 on kernel 3.3.1) are still globa=
l,
>> i.e. an ipset created in the container is visible in the host and vi=
ce
>> versa. Iptables rulesets, however, are isolated.
>>
>> Is this an as of yet unimplemented feature or a conscious design dec=
ision?
>=20
> It's an unimplemented feature - no one requested it yet ;-).

Hi Jozsef:

And I see there are a lot of /proc/sys/entries are not isolated.
is this an unimplemented feature too?

If so,I want to implement it.
How do you think about this?
>=20
> Best regards,
> Jozsef
> -
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
