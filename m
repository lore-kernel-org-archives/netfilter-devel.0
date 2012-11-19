From: Ricardo Klein <klein.rfk@gmail.com>
Subject: Re: [ANNOUNCE] ipset 6.15 released
Date: Mon, 19 Nov 2012 18:20:09 -0200
Message-ID: <CADuigkVE-qMowSn0oSh==L998rraoc7H793dppJFY2fEfqkLpg@mail.gmail.com>
References: <alpine.DEB.2.00.1211191356240.21756@blackhole.kfki.hu>
	<CADuigkXXwhGkjYVCo68BmOGSbe95DzSYcM6u-YQmrjKSD5VWaQ@mail.gmail.com>
	<alpine.LNX.2.01.1211191927160.9275@nerf07.vanv.qr>
	<CADuigkV+d=xvKvKODTyA8avp21ZcL0pY0TjhxAehQi975wkwdQ@mail.gmail.com>
	<alpine.DEB.2.00.1211192056520.23128@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jan Engelhardt <jengelh@inai.de>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:36125 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab2KSUUK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Nov 2012 15:20:10 -0500
In-Reply-To: <alpine.DEB.2.00.1211192056520.23128@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It works.

Now I will implement a new firewall configuration script using ipset
instead of txt lists that need to be reloaded every time....
--
Att...

Ricardo Felipe Klein
klein.rfk@gmail.com


On Mon, Nov 19, 2012 at 5:57 PM, Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
> On Mon, 19 Nov 2012, Ricardo Klein wrote:
>
>> if  you need, I can deploy a clean CentOS 6.3 64bits and test it again
>> running autogen with pkg-config installed....
>
> Yes, please. A double check does not hurt.
>
> Best regards,
> Jozsef
>
>> On Mon, Nov 19, 2012 at 4:28 PM, Jan Engelhardt <jengelh@inai.de> wrote:
>> > On Monday 2012-11-19 18:39, Ricardo Klein wrote:
>> >
>> >>It fails on ./configure on CentOS 6.3 x84_64 with the message:
>> >>./configure: line 14702: syntax error near unexpected token `libmnl,'
>> >>./configure: line 14702: `PKG_CHECK_MODULES(libmnl, libmnl >= 1)'
>> >
>> > This means you ran autoreconf (which you normally don't need to, because
>> > there already is a configure script), while at the same time did not
>> > have pkg-config installed.
>> --
>> To unsubscribe from this list: send the line "unsubscribe netfilter" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
>           H-1525 Budapest 114, POB. 49, Hungary
