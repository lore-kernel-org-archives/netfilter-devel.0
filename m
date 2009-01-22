From: James King <t.james.king@gmail.com>
Subject: Re: TCP-packet with PUSH flag with wrong payload data in LOCAL_OUT
Date: Thu, 22 Jan 2009 10:15:00 -0800
Message-ID: <38bcb3ec0901221015x3da0e64bj8b4d0227224052a3@mail.gmail.com>
References: <7031232632416@webmail11.yandex.ru>
	 <alpine.LSU.2.00.0901221521450.24791@fbirervta.pbzchgretzou.qr>
	 <68611232638800@webmail51.yandex.ru>
	 <alpine.LSU.2.00.0901221705140.30491@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Vladimir Kobylyanskiy <kentlinux@yandex.ru>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f20.google.com ([209.85.219.20]:33991 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440AbZAVSPE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Jan 2009 13:15:04 -0500
Received: by ewy13 with SMTP id 13so2851235ewy.13
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Jan 2009 10:15:00 -0800 (PST)
In-Reply-To: <alpine.LSU.2.00.0901221705140.30491@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 22, 2009 at 8:11 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
> Very well. But there still is another case I can think of -
> non-linear skb.
>
>        struct tcphdr tcpbuf;
>        const struct tcphdr *th;
>
>        th = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(tcpbuf), &tcpbuf);
>        if (th->psh && ntohs(tcp->dest) == 80) {
>                char n[4];
>
>                if (skb_copy_bits(skb, ip_hdrlen(skb) + 4*tcp->doff,
>                    n, sizeof(n)) >= 0)
>                        printk("data: %02x %02x %02x %02x\n", n[0], n[1],
>                               n[2], n[3]);
>        }

Wouldn't

if ((skb_linearize(skb) != 0) && net_ratelimit())
      printk("skb is non-linear, but failed to linearize");

be more preferable?
