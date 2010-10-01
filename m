From: Anand Raj Manickam <anandrm@gmail.com>
Subject: Re: IS Mapping ipset to iptable chains possible
Date: Fri, 1 Oct 2010 15:11:45 +0530
Message-ID: <AANLkTi=sX5DO2zGFESnxnwmZ4WZPEXr2F8khSd1BBADF@mail.gmail.com>
References: <AANLkTin81gLzh3iHbONkeAckWxc++WZtmuHXeFuMN6VT@mail.gmail.com>
	<alpine.DEB.2.00.1010010918510.11563@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60675 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab0JAJlr convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Oct 2010 05:41:47 -0400
Received: by qyk36 with SMTP id 36so3058377qyk.19
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Oct 2010 02:41:46 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1010010918510.11563@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 1, 2010 at 12:50 PM, Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
> On Fri, 1 Oct 2010, Anand Raj Manickam wrote:
>
>> I m just learning to use ipsets .
>> I have a basic doubt
>>
>> Suppose i create a ipset
>>
>> ipset -N test ipmap --network 192.168.0.0/16
>>
>> add a few ips
>> #ipset -A test 192.168.0.1
>> ..
>>
>> if i want to have 1 chain per ip
>>
>> 192.168.0.1 to CHAIN1
>> ..
>> 192.168.0.100 to CHAIN100
>
> If you mean to store the IP addresses in a set and use it to "jump" t=
o the
> chains, then no, that's not possible.
>
> Best regards,
> Jozsef
> -
> E-mail =A0: kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : KFKI Research Institute for Particle and Nuclear Physics
> =A0 =A0 =A0 =A0 =A0H-1525 Budapest 114, POB. 49, Hungary
>
Thanks,

Do you think its a good idea to create a ipset type ..

ipset -N test ipmapchain --network 192.168.0.0/16

ipset -A test 192.168.0.1 CHAIN1
=2E.
ipset -A test 192.168.0.100 CHAIN100


mabbe a new

iptables -A FORWARD -m set  --set test src,dst,chain

Please correct me if there are complications on this  idea or its
nonsense to do this ;-)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
