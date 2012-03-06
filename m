From: Florian Westphal <fw@strlen.de>
Subject: Re: netfilter_queue : use --queue-balance in multithreaded
 environment
Date: Tue, 6 Mar 2012 22:45:18 +0100
Message-ID: <20120306214518.GB19133@Chamillionaire.breakpoint.cc>
References: <1330681120.2106.14.camel@arifLaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Arif Hossain <freefall1986@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:54683 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758314Ab2CFVpU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:45:20 -0500
Content-Disposition: inline
In-Reply-To: <1330681120.2106.14.camel@arifLaptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Arif Hossain <freefall1986@gmail.com> wrote:
> I'm using libnetfilter_queue for userspace modification of
> incoming/outgoing packets. I have been using a single threaded model.
> But i've found out that from 2.6.31 kernel, its possible to have
> different queues for different connection. so i was wandering if its
> possible to manage each queues in different threads.

Its usually simpler to just run several instances of the same program,
easier to maintain/debug and avoids locking/race conditions...

If you have requirements that make this a bad choice (e.g. memory
usage), then yes, you can use threads.

See
http://git.breakpoint.cc/cgi-bin/gitweb.cgi?p=fw/afcd.git;a=blob;f=src/in/in_nl.c;h=e298bd073f3c7e0c62432510c2b3f7de953df1ec;hb=74a2df00cdee5f3ff8360b32d711d5db086b5355#l351

for a program that does this.

> if i initialize above in the main thread and want to run the callbacks
> in threads, is it enough to run infinite loop in a function which will
> be given to pthread_create()? Will it run the callbacks in threads? 

Yes.

> i'm not sure, but my understanding tells me, a packet is popped from the
> queues when nfq_set_verdict is returned. so i need to run
> nfq_set_verdict in separate threads so that i packets can be popped from
> queues parallel.

I don't understand this part.  Basically all the processing do this
(see url above for full example):

 static int nfnl_queue_cb(struct nfq_q_handle *qh, struct nfgenmsg *nfmsg,
               struct nfq_data *nfa, void *data) {
        [..]
        ret = nfq_get_payload(nfa, &pkt);
	do_something(pkt);
        return nfq_set_verdict2( .. )
}

static void *_thread_main(void *arg) {
	[..]
        while (!thread_should_stop) {
                ssize_t rv = read(fd, buf, nfq_buf_len);
                if (rv > 0)
                        nfq_handle_packet(nfq_h, buf, (int) rv);
                else
                        /* error ... */
        }
	/* cleanup */
        return NULL;
}

All the threads then run nfnl_queue_cb() independently.
Of course, you'll need to add proper locking if they need to
access shared data structures...
