From: Anton VG <anton.vazir@gmail.com>
Subject: Re: (nfnl_talk: recvmsg over-run) and (nf_queue: full at 1024
	entries, dropping packets(s). Dropped: 582) - bug or just some defaults
	increase required?
Date: Mon, 16 Feb 2009 20:33:48 +0500
Message-ID: <c4b050a10902160733y605a5cc1l710596b0aa658f5d@mail.gmail.com>
References: <c4b050a10902061014w3df3b2c3xe9e6465be79b4e07@mail.gmail.com>
	 <200902121545.16590.anton.vazir@gmail.com>
	 <4996FBBE.20009@netfilter.org>
	 <200902161819.27630.anton.vazir@gmail.com>
	 <49996D49.9050606@netfilter.org>
	 <c4b050a10902160638s231bd34by7e90f320dde3e27e@mail.gmail.com>
	 <49998504.9020004@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	Vitaly Bodzhgua <vitaly@eastera.tj>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:21697 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbZBPPdu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2009 10:33:50 -0500
Received: by fk-out-0910.google.com with SMTP id f33so1074022fkf.5
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Feb 2009 07:33:48 -0800 (PST)
In-Reply-To: <49998504.9020004@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The same stuff with commented out

// fcntl(nfqfd,F_SETFL,O_NONBLOCK);

The same stuff. Or do i miss something, and there is a flag, which
forces blocking operation?
Any suggestion?

if (nfqfd>0) {
 // fcntl(nfqfd,F_SETFL,O_NONBLOCK);
 } else throw "fail to set nfq nfnl fd";
}

2009/2/16 Pablo Neira Ayuso <pablo@netfilter.org>:
> Anton VG wrote:
>>
>> Pablo,
>> Attached is the code which triggers the case, and it does not use
>> threads (btw we of coase use mutexes in threaded app)
>>
>> How to use it:
>> at first, the app created 40 queues and attaches to output. Every
>> first 40 created queues have assigned corrwsponding
>> 192.168.1.{queue_num} IP address assigned to the queue.
>> This means, for instance when you send a file to an IP address
>> 192.168.1.37 it flows through QUEUE 37.
>>
>> Than app started the loop, where it's randomly creates and destroys
>> extra queues (over 40) every second.
>>
>> After starting the app, you need to send a big file, say 1GB, over FTP
>> to anther PC with IP address from group of first 40, we used
>> 192.168.1.37
>>
>> Somewhere is the middle of sending the file it triggers the error on
>> queue creation.
>>
>> Please make sure that you use OUTPUT chain, and you send a file from test
>> PC.
>> With this test code we did trigger this both on 64 and 32 bit systems.
>> Kernel versions on test PC's 2.6.26.1 and 2.6.26.5
>>
>> Just let me know if anything needs clarification.
>
> void init_nfq()
> ...
>  if (nfqfd>0) {
>   fcntl(nfqfd,F_SETFL,O_NONBLOCK);
>  } else throw "fail to set nfq nfnl fd";
> }
>
> With the current interface of libnetfilter_queue, the queue creation must be
> blocking to ensure serialization. I'll document this. I can add some
> functions to allow non-blocking queue creation but that's a different point.
>
> --
> "Los honestos son inadaptados sociales" -- Les Luthiers
>
