From: Lorraine Hall <lorraineehall@gmail.com>
Subject: Fastest way to send a packet from a target module
Date: Sun, 18 Aug 2013 17:13:46 -0700
Message-ID: <CALSwv_LuRuOuTnQJdGq3pOL+Bk8GmJDypeTJz3hLuJJ0QiZHDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f194.google.com ([74.125.82.194]:40100 "EHLO
	mail-we0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788Ab3HSANs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Aug 2013 20:13:48 -0400
Received: by mail-we0-f194.google.com with SMTP id u55so645068wes.5
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Aug 2013 17:13:46 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

In an iptables target module (that handles incoming packets), I need to send a
response packet back to the sender, then I can return NF_DROP or NF_STOLEN.

The first approach I tested was to allocate a new SKB, prepare the packet and
send it out. While this worked, I found that calling alloc_skb() was a major
performance killer.

My second approach was to reuse the SKB the packet arrived in, swap the MAC and
IP addresses and UDP ports, modify the packet (and adjust SKB length), call
dev_queue_xmit() to send it out the same interface it arrived in, and return
NF_STOLEN. This works because the response packet is not larger than the
request packet, and I also perform some validation on the request packet (no
IPv4 options, no fragmentation). It also avoids the overhead of L3 routing,
which I realize limits flexibility a bit but that flexibility isn't necessary in
this case.

I also have another possible approach, but I haven't tested this one yet: I
could have an SKB pool, probably one per RX queue, increase the reference count
by 1 so dev_queue_xmit() doesn't free the preallocated SKBs, walk the pool and
use the first SKB with a reference count of 1. This would also allow me to
prepare the UDP payload with some application-specific stuff (headers), then I'd
only need to fill in a few struct fields to send a packet out.

So far the second approach has worked quite well in testing, much better than
the first. But I'm still wondering if there any possible unforeseen consequences
from modifying the NIC's SKB and resending it. Also, I'm wondering if that is
even the best approach to take, or if the third option may be better.

Thanks,

L
