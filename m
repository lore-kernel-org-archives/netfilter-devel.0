From: Anton <anton.vazir@gmail.com>
Subject: Re: (nfnl_talk: recvmsg over-run) and (nf_queue: full at 1024 =?iso-8859-1?q?=09entries?=, dropping packets(s). Dropped: 582) - bug or just some defaults =?iso-8859-1?q?=09increase?= required?
Date: Thu, 12 Feb 2009 15:45:14 +0500
Message-ID: <200902121545.16590.anton.vazir@gmail.com>
References: <c4b050a10902061014w3df3b2c3xe9e6465be79b4e07@mail.gmail.com> <c4b050a10902110426s5e997220r21d615ebf0683bb8@mail.gmail.com> <4992FFD7.9090706@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.eastera.tj ([82.198.21.18]:39911 "EHLO mail.eastera.tj"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755415AbZBLKpZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 05:45:25 -0500
In-Reply-To: <4992FFD7.9090706@netfilter.org>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo,

Some more info. After applying the patch, If we do try to 
just create 100 QUEUE's by the test code - on the test PC, 
with _no_ transit traffic, routed to QUEUE's - it works 
fine, queues created with no problem. 
But if we do this on the live PC, with trasit traffic routed 
to queues - we came to the problem once in a few queues. 
We localized the place, and the sequence is as follows:
nfnl_query=>nfnl_catch=>nfnl_process

and in the nfnl_process

if (nlh->nlmsg_seq && nlh->nlmsg_seq != h->seq) {
                errno = EILSEQ;
                return -1;
}

and varibales are
nlh->msg_seq=1234422225, h->seq=1234422229.

EILSEQ=84
strerr(84) returns "Invalid or incomplete multibyte or wide 
character"

Any clue on this?

Regards,
Anton.

On Wednesday 11 February 2009 21:41, Pablo Neira Ayuso 
wrote:
> Anton VG wrote:
> > Pablo,
> >
> > On 64bit system, after applying the patch,
> > nfq_create_queue() started to oftenly return NULL, and
> > calling
> > strerror(errno) - I've got a error "Invalid or
> > incomplete multibyte or wide character".
> >
> > On 32bit it works. This have been tested with only 2x
> > simultaneous queues Any thoughts?
>
> Let me check this. Do you think that I can reproduce it
> with the test file in libnetfilter_queue? If you can pass
> something similar to your code to reproduce the problem,
> it would be great. Thanks.
