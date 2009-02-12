From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: (nfnl_talk: recvmsg over-run) and (nf_queue: full at 1024  entries,
 dropping packets(s). Dropped: 582) - bug or just some defaults  increase
 required?
Date: Thu, 12 Feb 2009 13:43:27 +0100
Message-ID: <4994196F.7030400@netfilter.org>
References: <c4b050a10902061014w3df3b2c3xe9e6465be79b4e07@mail.gmail.com> <c4b050a10902110426s5e997220r21d615ebf0683bb8@mail.gmail.com> <4992FFD7.9090706@netfilter.org> <200902121545.16590.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Anton <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38590 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760226AbZBLMny (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:43:54 -0500
In-Reply-To: <200902121545.16590.anton.vazir@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Anton wrote:
> Pablo,
> 
> Some more info. After applying the patch, If we do try to 
> just create 100 QUEUE's by the test code - on the test PC, 
> with _no_ transit traffic, routed to QUEUE's - it works 
> fine, queues created with no problem. 
> But if we do this on the live PC, with trasit traffic routed 
> to queues - we came to the problem once in a few queues. 
> We localized the place, and the sequence is as follows:
> nfnl_query=>nfnl_catch=>nfnl_process
> 
> and in the nfnl_process
> 
> if (nlh->nlmsg_seq && nlh->nlmsg_seq != h->seq) {
>                 errno = EILSEQ;
>                 return -1;
> }
> 
> and varibales are
> nlh->msg_seq=1234422225, h->seq=1234422229.
> 
> EILSEQ=84
> strerr(84) returns "Invalid or incomplete multibyte or wide 
> character"
> 
> Any clue on this?

There's some race condition. It seems that you're receiving packets from
kernel-space to nfqueue before the ACK message from kernel-space to
user-space to confirm subscription is send. Let me investigate this.
Thanks for the accurate report.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
