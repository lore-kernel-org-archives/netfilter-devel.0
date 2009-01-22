From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: TCP-packet with PUSH flag with wrong payload data in LOCAL_OUT
Date: Thu, 22 Jan 2009 19:57:35 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901221955530.5482@fbirervta.pbzchgretzou.qr>
References: <7031232632416@webmail11.yandex.ru>  <alpine.LSU.2.00.0901221521450.24791@fbirervta.pbzchgretzou.qr>  <68611232638800@webmail51.yandex.ru>  <alpine.LSU.2.00.0901221705140.30491@fbirervta.pbzchgretzou.qr>
 <38bcb3ec0901221015x3da0e64bj8b4d0227224052a3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Vladimir Kobylyanskiy <kentlinux@yandex.ru>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: James King <t.james.king@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40141 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbZAVS5h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Jan 2009 13:57:37 -0500
In-Reply-To: <38bcb3ec0901221015x3da0e64bj8b4d0227224052a3@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-01-22 19:15, James King wrote:
>On Thu, Jan 22, 2009 at 8:11 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
>> Very well. But there still is another case I can think of -
>> non-linear skb.
>>
>>        struct tcphdr tcpbuf;
>>        const struct tcphdr *th;
>>
>>        th = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(tcpbuf), &tcpbuf);
>>        if (th->psh && ntohs(tcp->dest) == 80) {
>>                char n[4];
>>
>>                if (skb_copy_bits(skb, ip_hdrlen(skb) + 4*tcp->doff,
>>                    n, sizeof(n)) >= 0)
>>                        printk("data: %02x %02x %02x %02x\n", n[0], n[1],
>>                               n[2], n[3]);
>>        }
>
>Wouldn't
>
>if ((skb_linearize(skb) != 0) && net_ratelimit())
>      printk("skb is non-linear, but failed to linearize");
>
>be more preferable?

I don't think you want to be spending the CPU cycles for that.
skb_copy_.. has a reason, at least for when you only need
parts of the packet. A whole packet can be large --
the MTU for lo is slightly above 16K, and that's a pretty big
allocation already. The larger the allocation (come to think
of jumbo packets), the sooner the fail.
