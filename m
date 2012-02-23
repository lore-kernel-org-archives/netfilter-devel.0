From: Ganesh Kumar <ganeshkumarnm@gmail.com>
Subject: Re: nfulnl_test doesn't work on Ubuntu
Date: Thu, 23 Feb 2012 13:35:53 +0530
Message-ID: <CAHS57vVTPUxhvKu3iUEs=f8KPpdxy2yomAs+9ZqMYp9xs1UpBA@mail.gmail.com>
References: <CAHS57vUULJmJZuaR3-e2Lzx24Jj-gkg2t5qu_oa9vVdwfjOv-w@mail.gmail.com>
	<1329981861.15610.10.camel@edumazet-laptop>
	<CAHS57vVYyO+yES9CSk8Fbmdwc-S8g_p9QCT=kkOK2A-RmwzFJg@mail.gmail.com>
	<1329983898.15610.11.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Ganesh Kumar <gkumarnm@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48427 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab2BWIFy convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Feb 2012 03:05:54 -0500
Received: by yhoo21 with SMTP id o21so455576yho.19
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Feb 2012 00:05:53 -0800 (PST)
In-Reply-To: <1329983898.15610.11.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

  Thanks, now did  sudo, this is what I get;

 gakumar@krishna-desktop:~/PacketFilter/libnetfilter_log-1.0.0/utils$
sudo ./nfulnl_test
[sudo] password for gakumar:
/home/gakumar/PacketFilter/libnetfilter_log-1.0.0/utils/.libs/lt-nfulnl=
_test:
error while loading shared libraries: libnfnetlink.so.0: cannot open
shared object file: No such file or directory
gakumar@krishna-desktop:~/PacketFilter/libnetfilter_log-1.0.0/utils$
echo $LD_LIBRARY_PATH
/opt/qnx641/host/linux/x86/usr/lib:/opt/qnx650/host/linux/x86/usr/lib:/=
usr/local/lib/
gakumar@krishna-desktop:~/PacketFilter/libnetfilter_log-1.0.0/utils$

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


wondering why its not able to locate the .so

Thanks,
Ganesh


On 2/23/12, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le jeudi 23 f=E9vrier 2012 =E0 13:05 +0530, Ganesh Kumar a =E9crit :
>> Hi Eric,
>>
>>    Thanks for a fast reply.
>> I tried modprobe nfnetlink_log
>>
>> this is what I get in dmesg
>>
>> [2054919.049919] Netfilter messages via NETLINK v0.30.
>>
>> gakumar@krishna-desktop:~/PacketFilter/libnetfilter_log-1.0.0/utils$
>> ./nfulnl_test
>> binding nfnetlink_log to AF_INET
>> error during nflog_bind_pf()
>> gakumar@krishna-desktop:~/PacketFilter/libnetfilter_log-1.0.0/utils$
>>
>> These are the contents of
>> gakumar@krishna-desktop:~/PacketFilter/libnetfilter_log-1.0.0/utils$
>> ls /usr/local/lib/
>> libnetfilter_log.a                   libnetfilter_log_libipulog.so.1
>>    libnfnetlink.a                       pkgconfig/
>> libnetfilter_log.la
>> libnetfilter_log_libipulog.so.1.0.0  libnfnetlink.la
>>    python2.6/
>> libnetfilter_log_libipulog.a         libnetfilter_log.so
>>    libnfnetlink.so
>> libnetfilter_log_libipulog.la        libnetfilter_log.so.1
>>    libnfnetlink.so.0
>> libnetfilter_log_libipulog.so        libnetfilter_log.so.1.1.0
>>    libnfnetlink.so.0.2.0
>> gakumar@krishna-desktop:~/PacketFilter/libnetfilter_log-1.0.0/utils$
>>
>> Hope its installed properly.
>> anything else I need to fix/check
>>
>
> You have to be root
>
> sudo ./nfulnl_test
>
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
