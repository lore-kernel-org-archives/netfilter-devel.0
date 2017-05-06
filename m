From: Pavel Vajarov <pavel@x3me.net>
Subject: How to reinject a packet (skb) at some later point in time
Date: Sat, 6 May 2017 19:21:03 +0300
Message-ID: <CAJEV1ijznokQj78RNXTRxMnrnRTBtoWZUVwcB4k7JHYb9FfLJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:34541 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751255AbdEFQVE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 May 2017 12:21:04 -0400
Received: by mail-oi0-f42.google.com with SMTP id b204so15195883oii.1
        for <netfilter-devel@vger.kernel.org>; Sat, 06 May 2017 09:21:04 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

First, I'd like to say why I need this. Maybe, I've taken the wrong
path to achieve the goal.
We have a user space TCP proxy working in transparent mode (TPROXY)
and we would like to not accept a connection to the user space if the
proxy can't connect to the original destination. The problem is that
the proxy stops being truly transparent when it accepts a connection
but can't connect to the original destination, because the last is
down, overloaded, etc.

In order to fix the above problem I was thinking for a way to try to
make a connection to the origin before accepting the input connection.
Later if the proxy can make connection to the origin it'll accept the
pending input connection. If the proxy can't make connection to the
origin in few seconds it'll drop the pending input connection.
I've rough understanding how the accept of new TCP connections works
in the Linux kernel and If I'm not wrong the kernel automatically
sends SYN,ACK to the incoming SYN packet as long as there is a free
slot in the accept queue(s). So I was thinking for a way to delay the
incoming SYN packets until the user space makes decision whether to
accept the SYN packet or drop it.

One way, that I found to achieve the above was through the
libnetfilter_queue. However, according to the experiment that I did,
it can't cope well when there are few hundreds and even few thousands
pending SYN packets. As far as I thought about it, the problems come
from two things:
1. The kernel functionality in net/netfilter/nfnetlink_queue.c usues
linked list to store pending packets and it doesn't perform well when
we need to search by packet id there when the user space issues
NF_ACCEPT verdict at some time later.
2. There are input SYN re-transmits which goes to the user space
simply to be dropped (NF_DROP) because the original SYN packet with
the same (src ip:port -> dst ip:port) is still waiting it's verdict,
and there is no point keeping the re-transmitted SYN packets.

So, after the above experiment I started to search a way to do the
main logic with a kernel module and netlink socket to communicate the
knowledge about (src ip:port, dst ip:port) to the user space and the
verdict back. Note that the logic needs to happen at given
position/rule in the iptables because not all of the traffic coming
into the machine is redirected to the user space application and thus
the 'delay logic' must not try to check every SYN.
One way to achieve this, that I thought about, was to write kernel
module similar to nfnetlink_queue which will use hashtable instead of
linked list for the queue and will drop immediately repeated SYNs. The
module was going to use nf_reinject to reinject the delayed packets
back in the kernel stack. However, the problem with such module is
that nf_register_queue_handler is supposed to be called only once for
the whole kernel (there is only one queueing backend in the kernel)
and when I call it from my kernel module registration routine the
kernel frowns about it, because there is already registered handler
there
(WARN_ON(rcu_access_pointer(queue_handler));).
I think, I can implement most of the logic in iptables target module
which will return NF_STOLEN for the packets which it want's to be
checked. So my main question is how to reinject such packets later
because I do not have there nf_hook_state with okfn to call, as the
the net/netfilter/nf_queue.c does on nf_reinject.

It became a long post, but I'll appreciate all responses even if they
don't answer the original question, because they can give me some
clues to solve the main problem in a different way.

Thanks,
Pavel.
