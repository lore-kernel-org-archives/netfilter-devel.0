From: Ryan Johnston <ryan@mediapixel.co.nz>
Subject: Re: netlink multi-thread / libmnl / nfq
Date: Wed, 3 Jun 2015 09:55:53 +1200
Message-ID: <CAJ0j+bpKjLYH7jQRL3QTkrhn36-5uOst9O-Ymh8eZ6BUY5uNWA@mail.gmail.com>
References: <CAJ0j+bpNqDJZTcbU-4wHcmNT8=28U3jJ5ftu-OpbpfZJjAjBxg@mail.gmail.com>
	<20150602212241.GB11015@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:34752 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbbFBVzz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2015 17:55:55 -0400
Received: by laew7 with SMTP id w7so43994748lae.1
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Jun 2015 14:55:53 -0700 (PDT)
In-Reply-To: <20150602212241.GB11015@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yes with --queue-balance do I open a socket via nfq_open() per thread
or do I just have the one nfq_open() and have each thread call
nfq_create_queue only?

On Wed, Jun 3, 2015 at 9:22 AM, Florian Westphal <fw@strlen.de> wrote:
> Ryan Johnston <ryan@mediapixel.co.nz> wrote:
>> When creating a multi-threaded NFQ/Netlink application, should I have
>> multiple threads with fd sockets connected to the kernel, or do I have
>> one socket with multiple thread loops to read the socket?
>
> Its up to you.
>
>> If I am to have many threaded fd sockets connected to kernel's
>> netlink, is there any performance loss by having too many?
>
> For best performance use multiple queues, e.g. manually via iptables
> -m cpu ...  -j NFQUEUE, or via iptables .. NFQUEUE --queue-balance 0:x,
> then run one process or thread for each queue.
>
> One thread per queue model is implemented in suricata ids for example.
