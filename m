From: =?UTF-8?Q?=C4=B0brahim_Ercan?= <ibrahim.ercan@engineer.com>
Subject: Re: ipset : ip range insertion to hash:net list does not work
Date: Mon, 13 Aug 2012 09:04:29 +0300
Message-ID: <CAK6Qs9mHoV9GSNmDpA_3feR=x-aNOWAGHH9+0DcPsCYCyiOrNg@mail.gmail.com>
References: <CAK6Qs9nVL6hzcjdaF98RkPhvH-sf+KUYnoeNxMyDvf92O9bK3A@mail.gmail.com>
	<alpine.DEB.2.00.1208102253290.12102@blackhole.kfki.hu>
	<alpine.DEB.2.00.1208102313300.12235@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout-us.mail.com ([74.208.122.35]:38174 "HELO
	mailout-us.mail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751765Ab2HMGEb convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Aug 2012 02:04:31 -0400
Received: by qcro28 with SMTP id o28so1999593qcr.19
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Aug 2012 23:04:29 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1208102313300.12235@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11 August 2012 00:16, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wr=
ote:
> On Fri, 10 Aug 2012, Jozsef Kadlecsik wrote:
>
>> On Fri, 10 Aug 2012, ?brahim Ercan wrote:
>>
>> > Hi. This is my first post. Sorry if there is impropriety. Here is =
the story.
>> >
>> >  I made rpm packet 6.13 for centos 5. While compilation, I got the=
se errors:
>> >
>> > ipset v6.13: Syntax error: IP address or IP/cidr must be specified=
:
>> > 1.2.3.4-1.2.3.10
>> > print.c:675: error: ?IPPROTO_UDPLITE? undeclared (first use in thi=
s function)
>> >
>> > Then I added below lines to needed files(print.c , parse.c) and
>> > problem solved and I installed rpm.
>> >
>> > #ifndef IPPROTO_UDPLITE
>> > #define IPPROTO_UDPLITE 136 /* from IANA */
>> > #endif
>> >
>> >
>> > Now I need to use hash:net and insert ip range. When I call follow=
ing
>> > commands, I get error.
>> >
>> > # ipset create foo hash:net family inet
>> > # ipset add foo 192.168.0.1-192.168.0.20
>> > ipset v6.13: Syntax error: IP address or IP/cidr must be specified=
:
>> > 192.168.0.1-192.168.0.20
>> >
>> > Here is some information
>> > kernel 3.0.4
>> > ipset 6.13
>> > iptables 1.4.14
>>
>> I'm unable to reproduce this.
>
> Ohh, you need the kernel modules from the ipset package itself.

I checked all modules, there is no missing. Here is kernel config
CONFIG_IP_SET=3Dm
CONFIG_IP_SET_MAX=3D2560
CONFIG_IP_SET_BITMAP_IP=3Dm
CONFIG_IP_SET_BITMAP_IPMAC=3Dm
CONFIG_IP_SET_BITMAP_PORT=3Dm
CONFIG_IP_SET_HASH_IP=3Dm
CONFIG_IP_SET_HASH_IPPORT=3Dm
CONFIG_IP_SET_HASH_IPPORTIP=3Dm
CONFIG_IP_SET_HASH_IPPORTNET=3Dm
CONFIG_IP_SET_HASH_NET=3Dm
CONFIG_IP_SET_HASH_NETPORT=3Dm
CONFIG_IP_SET_LIST_SET=3Dm

By the way gcc version I used is 4.1.2 if you need.

--=20
=C4=B0brahim Ercan
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
