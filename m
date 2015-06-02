From: Florian Westphal <fw@strlen.de>
Subject: Re: netlink multi-thread / libmnl / nfq
Date: Wed, 3 Jun 2015 00:23:09 +0200
Message-ID: <20150602222309.GC11015@breakpoint.cc>
References: <CAJ0j+bpNqDJZTcbU-4wHcmNT8=28U3jJ5ftu-OpbpfZJjAjBxg@mail.gmail.com>
 <20150602212241.GB11015@breakpoint.cc>
 <CAJ0j+bpKjLYH7jQRL3QTkrhn36-5uOst9O-Ymh8eZ6BUY5uNWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Ryan Johnston <ryan@mediapixel.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60112 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752127AbbFBWXK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2015 18:23:10 -0400
Content-Disposition: inline
In-Reply-To: <CAJ0j+bpKjLYH7jQRL3QTkrhn36-5uOst9O-Ymh8eZ6BUY5uNWA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ryan Johnston <ryan@mediapixel.co.nz> wrote:
> Yes with --queue-balance do I open a socket via nfq_open() per thread
> or do I just have the one nfq_open() and have each thread call
> nfq_create_queue only?

Apparently both is possible (I had to look it up :-/)
but i'd suggest to have one fd per queue, i.e. nfq_open() per thread.
