From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: Easy network (config) breakage with 3.17-rc1: NETFILTER_XT_TARGET_LOG
Date: Fri, 29 Aug 2014 09:04:50 +0200
Message-ID: <CACna6rzXE7TxN6umb0+z+z2_7ESNaAS4g352bQTgU8Xz75cj4Q@mail.gmail.com>
References: <CACna6rymZjgex0p1snf3e-GvK2xHrQST3roGiA3F__y3DvYhKw@mail.gmail.com>
	<20140822180112.GB3402@salvia>
	<20140824132801.GA11927@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:37858 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbaH2HEv convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Aug 2014 03:04:51 -0400
Received: by mail-ig0-f175.google.com with SMTP id uq10so9237439igb.14
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Aug 2014 00:04:50 -0700 (PDT)
In-Reply-To: <20140824132801.GA11927@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24 August 2014 15:28, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Aug 22, 2014 at 08:01:12PM +0200, Pablo Neira Ayuso wrote:
>> On Thu, Aug 21, 2014 at 12:49:33PM +0200, Rafa=C5=82 Mi=C5=82ecki wr=
ote:
>> > Few days ago I updated my 3.16 to 3.17-rc1 (both self compiled) an=
d I
>> > was using it until I noticed my machine doesn't respond to pings. =
I
>> > rebooted to 3.16 and it was working again.
>> >
>> > I bisected between 3.16 and 3.17-rc1 but it has failed. After all =
I
>> > got 3.16 not working anymore as well.
>> >
>> > It took me few hours to find the one to blame:
>> > CONFIG_NETFILTER_XT_TARGET_LOG. After moving my config from 3.16 t=
o
>> > 3.17-rc1 CONFIG_NETFILTER_XT_TARGET_LOG got disabled because of tw=
o
>> > new dependencies: NF_LOG_IPV4 && NF_LOG_IPV6.
>> >
>> > It would be nice if you could try to use "select" instead of "depe=
nds
>> > on" in such cases in the future. I bet fix my problem would be tri=
vial
>> > since the beginning, but end-users may spent hours or days trackin=
g
>> > such things :(
>>
>> Sorry for that Kconfig problem. Please, have a look at the attached
>> patch and confirm that it fixes the problem. At quick glance I think
>> it's safe to use select in this case.
>
> I'm just looking at this again.
>
> We cannot select NF_LOG_IPV6. This is going to break if IPV6 is not
> enabled.
>
> I can just relax this to avoid the dependency with NF_LOG_IPV4 and
> NF_LOG_IPV6 so CONFIG_NETFILTER_XT_TARGET_LOG will be still selected
> if not NF_LOG_IP* is set (see patch attached).
>
> However, those new modules are really required to get this working, i=
f
> they are not present, iptables ... -j LOG will fail with -ENOENT sinc=
e
> the protocol logger won't be available.

Well, with the attached patch, after moving from 3.16 to 3.17-rc1+ I ge=
t:
CONFIG_NETFILTER_XT_TARGET_LOG=3Dm
# CONFIG_NF_LOG_IPV4 is not set

I've just noticed there used to be "select"s, but they were removed in
c1878869c0c8e0def3df5397155f369442ce4e06
netfilter: fix several Kconfig problems in NF_LOG_*

Could this be solved with some conditional select-s? Something like a:
select NF_LOG
select NF_LOG_IPV4
select NF_LOG_IPV6 if IPV6
maybe?

--=20
Rafa=C5=82
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
