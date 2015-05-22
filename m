From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Harden iptables memory allocator
Date: Fri, 22 May 2015 14:06:17 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1505221359460.4211@nerf40.vanv.qr>
References: <CAOp4FwQ5a=kKWDjGdpdHV7i3SX1msaqDkTrwYL2y=2+Bd690Cg@mail.gmail.com> <1432284611.3364.14.camel@stressinduktion.org> <alpine.LSU.2.20.1505221056510.29609@nerf40.vanv.qr> <20150522115148.GA1985@mx.elandsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
	Loganaden Velvindron <loganaden@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Loganaden Velvindron <logan@elandsys.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:50624 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756441AbbEVMGS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 May 2015 08:06:18 -0400
In-Reply-To: <20150522115148.GA1985@mx.elandsys.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2015-05-22 13:51, Loganaden Velvindron wrote:
>On Fri, May 22, 2015 at 10:59:44AM +0200, Jan Engelhardt wrote:
>>=20
>> On Friday 2015-05-22 10:50, Hannes Frederic Sowa wrote:
>> >
>> >> + if ((nmemb >=3D MUL_NO_OVERFLOW || size >=3D MUL_NO_OVERFLOW) &=
&
>> >
>> >if ((nmemb|size) >=3D MUL_NO_OVERFLOW) && ...
>>=20
>> I am sure there are many C tricks one can do, but iptables is
>> hardly that time-critical to warrant such.
>
>The same can be said of ipset, which uses strlcpy and has strlcat in=20
>its library. However, those are safer APIs to use.
>
>In this particular case, it's safer to use reallocarray(NULL,x,y) rath=
er than
>malloc(x*y).

My comment was not about reallocarray=E2=80=93malloc, but about the
not-immediately-self-explanatory expression ((a|b) >=3D x) which to
me sounds like a Google interview question similar to "what would
(x&~(x-1))=3D=3Dx do".
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
