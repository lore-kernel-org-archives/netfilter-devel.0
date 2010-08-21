From: krunal patel <krunal.raj@gmail.com>
Subject: Fwd: socket filter
Date: Sat, 21 Aug 2010 15:41:33 +0530
Message-ID: <AANLkTik26jxbDxj9k=9Koc56Kyo6-6-Hp0JAX5iOp2ZJ@mail.gmail.com>
References: <AANLkTi=_YJTBy5pPfgBAi-cNt=ock0UGGcdD=X94YtUg@mail.gmail.com>
	<20100819220431.381da765@nehalam>
	<AANLkTimqZR0S0H_SO=xkBEWbC2zc92gSFp4hi=EpFTP5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42466 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab0HUKLe convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Aug 2010 06:11:34 -0400
Received: by qwh6 with SMTP id 6so3833015qwh.19
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Aug 2010 03:11:33 -0700 (PDT)
In-Reply-To: <AANLkTimqZR0S0H_SO=xkBEWbC2zc92gSFp4hi=EpFTP5@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thank you Stepen. My kernel is 2.6.27.45 :).

I am taking bpf string like "host <ip>" from command prompt and doing
"pcap_compile_nopcap". Create my filter and do setsockopt but I am not
able to get result i wanted. May be i am doing something wrong in
creating filters. I am using link type as DLT_RAW.



On Fri, Aug 20, 2010 at 10:34 AM, Stephen Hemminger
<shemminger@vyatta.com> wrote:
> On Fri, 20 Aug 2010 09:57:33 +0530
> krunal patel <krunal.raj@gmail.com> wrote:
>
>> Hi,
>>
>> There are ioctl's for attaching bpf like filters to socket. I found =
it
>> in kernel documentation.
>> =A0 =A0 setsockopt(sockfd, SOL_SOCKET, SO_ATTACH_FILTER, &Filter, si=
zeof(Filter));
>> I doubt is can we attach filters in case of netlink socket.
>> I am logging all packets using ULOG target and using ulogd.
>> Is it possible to use same ioctl for netlink socket we create in ulo=
gd?
>
> You can use socket filters on netlink sockets since =A02.6.26
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
