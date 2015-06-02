From: Ryan Johnston <ryan@mediapixel.co.nz>
Subject: Re: netlink multi-thread / libmnl / nfq
Date: Wed, 3 Jun 2015 10:25:43 +1200
Message-ID: <CAJ0j+boE9=Qd3V5ZenHO12XAvkKH=v9ZEiH0G35hd2Syid5Nrw@mail.gmail.com>
References: <CAJ0j+bpNqDJZTcbU-4wHcmNT8=28U3jJ5ftu-OpbpfZJjAjBxg@mail.gmail.com>
	<20150602212241.GB11015@breakpoint.cc>
	<CAJ0j+bpKjLYH7jQRL3QTkrhn36-5uOst9O-Ymh8eZ6BUY5uNWA@mail.gmail.com>
	<20150602222309.GC11015@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yk0-f172.google.com ([209.85.160.172]:33317 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbbFBWZo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2015 18:25:44 -0400
Received: by ykfr66 with SMTP id r66so58250367ykf.0
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Jun 2015 15:25:43 -0700 (PDT)
In-Reply-To: <20150602222309.GC11015@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Okay, is there any performance loss by havin more sockets connected to
the kernel? Or does --queue-balance just rotate each packet to each
socket/thread?

On Wed, Jun 3, 2015 at 10:23 AM, Florian Westphal <fw@strlen.de> wrote:
> Ryan Johnston <ryan@mediapixel.co.nz> wrote:
>> Yes with --queue-balance do I open a socket via nfq_open() per thread
>> or do I just have the one nfq_open() and have each thread call
>> nfq_create_queue only?
>
> Apparently both is possible (I had to look it up :-/)
> but i'd suggest to have one fd per queue, i.e. nfq_open() per thread.
