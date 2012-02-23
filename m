From: Ganesh Kumar <ganeshkumarnm@gmail.com>
Subject: Re: nfulnl_test doesn't work on Ubuntu
Date: Thu, 23 Feb 2012 13:05:31 +0530
Message-ID: <CAHS57vVYyO+yES9CSk8Fbmdwc-S8g_p9QCT=kkOK2A-RmwzFJg@mail.gmail.com>
References: <CAHS57vUULJmJZuaR3-e2Lzx24Jj-gkg2t5qu_oa9vVdwfjOv-w@mail.gmail.com>
	<1329981861.15610.10.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Ganesh Kumar <gkumarnm@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60435 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab2BWHfc convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Feb 2012 02:35:32 -0500
Received: by ghrr11 with SMTP id r11so452698ghr.19
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Feb 2012 23:35:31 -0800 (PST)
In-Reply-To: <1329981861.15610.10.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

   Thanks for a fast reply.
I tried modprobe nfnetlink_log

this is what I get in dmesg

[2054919.049919] Netfilter messages via NETLINK v0.30.

gakumar@krishna-desktop:~/PacketFilter/libnetfilter_log-1.0.0/utils$
=2E/nfulnl_test
binding nfnetlink_log to AF_INET
error during nflog_bind_pf()
gakumar@krishna-desktop:~/PacketFilter/libnetfilter_log-1.0.0/utils$

These are the contents of
gakumar@krishna-desktop:~/PacketFilter/libnetfilter_log-1.0.0/utils$
ls /usr/local/lib/
libnetfilter_log.a                   libnetfilter_log_libipulog.so.1
   libnfnetlink.a                       pkgconfig/
libnetfilter_log.la
libnetfilter_log_libipulog.so.1.0.0  libnfnetlink.la
   python2.6/
libnetfilter_log_libipulog.a         libnetfilter_log.so
   libnfnetlink.so
libnetfilter_log_libipulog.la        libnetfilter_log.so.1
   libnfnetlink.so.0
libnetfilter_log_libipulog.so        libnetfilter_log.so.1.1.0
   libnfnetlink.so.0.2.0
gakumar@krishna-desktop:~/PacketFilter/libnetfilter_log-1.0.0/utils$

Hope its installed properly.
anything else I need to fix/check

Many Thanks,
Ganesh

On 2/23/12, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le jeudi 23 f=E9vrier 2012 =E0 12:00 +0530, Ganesh Kumar a =E9crit :
>> dear all,
>>
>>  I'm trying my hand on the NFLOG target of iptables, so I setup
>> the below ones on my ubuntu machine 10.4  :
>>
>>
>> libnetfilter_log-1.0.0
>> libnfnetlink-dev_1.0.0
>>
>>
>> $ uname -a
>> Linux ubuntu 2.6.32.21 #2 SMP Wed Jul 6 22:03:07 PDT 2011 i686 GNU/L=
inux
>>
>>
>> but when I try to build and run the utils nfulnl_test.c this is what
>> I'm getting using the below command
>> gcc -o nfulnl_test nfulnl_test.c -L /usr/local/lib/ -lnetfilter_log
>>
>> $ ./nfulnl_test
>> binding nfnetlink_log to AF_INET
>> error during nflog_bind_pf()
>>
>> Am I missing something, any help is appreciated.
>>
>> Many thanks,
>> GK
>
> It works well on ubuntu 11.10 & 11.04, not sure for 10.04
>
> Could you check if you can load nfnetlink_log module ?
>
> modprobe nfnetlink_log
>
>
>
>


--=20
Ganesh Kumar NM

Experience is what causes a person to make
new  mistakes  instead  of old ones.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
