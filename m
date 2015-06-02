From: Florian Westphal <fw@strlen.de>
Subject: Re: netlink multi-thread / libmnl / nfq
Date: Tue, 2 Jun 2015 23:22:41 +0200
Message-ID: <20150602212241.GB11015@breakpoint.cc>
References: <CAJ0j+bpNqDJZTcbU-4wHcmNT8=28U3jJ5ftu-OpbpfZJjAjBxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ryan Johnston <ryan@mediapixel.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60015 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751556AbbFBVWn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2015 17:22:43 -0400
Content-Disposition: inline
In-Reply-To: <CAJ0j+bpNqDJZTcbU-4wHcmNT8=28U3jJ5ftu-OpbpfZJjAjBxg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ryan Johnston <ryan@mediapixel.co.nz> wrote:
> When creating a multi-threaded NFQ/Netlink application, should I have
> multiple threads with fd sockets connected to the kernel, or do I have
> one socket with multiple thread loops to read the socket?

Its up to you.

> If I am to have many threaded fd sockets connected to kernel's
> netlink, is there any performance loss by having too many?

For best performance use multiple queues, e.g. manually via iptables
-m cpu ...  -j NFQUEUE, or via iptables .. NFQUEUE --queue-balance 0:x,
then run one process or thread for each queue.

One thread per queue model is implemented in suricata ids for example.
