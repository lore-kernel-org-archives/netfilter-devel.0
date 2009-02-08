From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: (nfnl_talk: recvmsg over-run) and (nf_queue: full at 1024 entries,
 	dropping packets(s). Dropped: 582) - bug or just some defaults increase
 	required?
Date: Sun, 08 Feb 2009 02:34:11 +0100
Message-ID: <498E3693.6030702@netfilter.org>
References: <c4b050a10902061014w3df3b2c3xe9e6465be79b4e07@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Anton VG <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42901 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750936AbZBHBe1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Feb 2009 20:34:27 -0500
In-Reply-To: <c4b050a10902061014w3df3b2c3xe9e6465be79b4e07@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Anton VG wrote:
> Hello Friends,
> 
> Just came to a problem with nfnetlink_queue -
> 
> I've created a service where users do connect to a host, and every
> connected user (over PPP) get's a separate NF-QUEUE -
> In this QUEUE i do packet accounting, to a different destination. When
> number of simultaneous queues went to 40+  I just came to a problem -
> deadloop with continues generation of the error to stderr - (3GB of
> record in the log in 3 minutes of deadlock)
> 
> nfnl_talk: recvmsg over-run

This happens when netlink fails to deliver a packet from kernel to
userspace due to an overrun in the buffer.

> GDB connected and backtrace showed the loop in the following:
[...]
> Also I'm watching the following in the dmesg (though, it does not kill
> the service) - but maybe somehow influences?
> 
> __ratelimit: 14 messages suppressed
> nf_queue: full at 1024 entries, dropping packets(s). Dropped: 679

This message is triggered when you exceed queue_maxlen.

> Further details: using kernel 2.6.26.5 and
> libnetfilter_queue-0.0.16
> libnfnetlink-0.0.39
> 
> Do you think that increasing the NFQNL_QMAX_DEFAULT from 1024 to 10240
> would solve the problem
> (in linux-2.6.26.5/net/netfilter/nfnetlink_queue.c) - or the problem is deeper?

That would reduce the chances to hit the printk error that you have
reported (which I think that it needs to be removed or disabled it, we
have the /proc interface to report this error, the point would be to
document this issue in the library).

For the ENOBUFS problem, what you can do is to increase the buffer size,
that will delay the appearance of the ENOBUFS problem. Please, see
nfnl_rcvbufsiz() in libnfnetlink. Increasing the priority of the process
via nice() would reduce the chances to hit ENOBUFS.

> Maybe anything like this is fixed in further versions of the kernel of
> libraries?

ENOBUFS is there to tell userspace that Netlink cannot back off. It's
not a bug, it's a feature of Netlink.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
