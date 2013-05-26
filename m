From: Alex Maltinsky <maltalex@gmail.com>
Subject: Re: Negative value in /proc/net/netfilter/nfnetlink_queue
Date: Sun, 26 May 2013 15:19:54 +0300
Message-ID: <CAAitQh=1nMc-YPw3xF-+8OV8bjXTumRfZdLjdwC0LrQtJYWdAw@mail.gmail.com>
References: <CAAitQh=ZUM8+8TqO8EFNrT7GL8VThvDje_Vfc4P0e3T60QVpSA@mail.gmail.com>
 <CAAitQhkvPWzjvWE7G80OxrwpKbemxbm9N6bchfygiOdwjDUgjA@mail.gmail.com> <20130526104226.GA6578@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:44442 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab3EZMUZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 May 2013 08:20:25 -0400
Received: by mail-oa0-f47.google.com with SMTP id m1so7987252oag.34
        for <netfilter-devel@vger.kernel.org>; Sun, 26 May 2013 05:20:25 -0700 (PDT)
In-Reply-To: <20130526104226.GA6578@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks for the quick reply.

The system I'm dealing often has traffic spikes that cause NFQ packet
drops. So I can't put a counter in userspace because it would miss
dropped packets. Counting dropped packets (as a percentage of the
total number of packets) is the main reason why I'm trying to get the
correct number of packets sent to the NFQ in the first place...

On Sun, May 26, 2013 at 1:42 PM, Florian Westphal <fw@strlen.de> wrote:
> Alex Maltinsky <maltalex@gmail.com> wrote:
>> I've stumbled across the issue on a heavily loaded system that uses
>> the nfqueue. After a few days, the number of packets wraps around:
>>
>> root@xxxx ~ # cat /proc/net/netfilter/nfnetlink_queue
>>     1   2401  1024 2  4096 247495836     0 -894731272  1
>
> -8.... is not the number of packets, its the nfqueue sequence number,
> which is a 32bit value (admittingly, it should use %u instead of %d
> to avoid the '-' silliness).
>
>> Is this a new issue or has it been fixed in recent versions?
>
> No, it has been like this forever.
>
>> I couldn't find anything in the changelog so I've decided not to
>> update libnfnetlink since it's an otherwise stable production machine
>> running a three year old version (0.0.39).
>
> Has nothing todo with libnfnetlink, the procfs contents are
> from netfilter_queue kernel part.
>
>> Second, is there a way of getting the correct value besides keeping
>> track of the number of wraparounds and compensating for them?
>
> If you want to know the number of packets processed by application
> you should simply add uint64_t counter in userspace and increment
> it per-packet.
