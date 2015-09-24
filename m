From: Florian Westphal <fw@strlen.de>
Subject: Re: NFQUEUE parallelization
Date: Fri, 25 Sep 2015 00:18:45 +0200
Message-ID: <20150924221845.GB24240@breakpoint.cc>
References: <CAKEqNm=2vnqe_fmSTM4G7xWsHkrXP29f_QxLUf7v7_-f5ESyKQ@mail.gmail.com>
 <20150924204840.GC29479@breakpoint.cc>
 <CAKEqNmmvrHwZGiwMA8AutnW_K+E9Wno3oq8duCFWkUNyBE_=Yw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eugene Strulyov <eugene.strulyov@gmail.com>, g@breakpoint.cc
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:59722 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753544AbbIXWSs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Sep 2015 18:18:48 -0400
Content-Disposition: inline
In-Reply-To: <CAKEqNmmvrHwZGiwMA8AutnW_K+E9Wno3oq8duCFWkUNyBE_=Yw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eugene Strulyov <eugene.strulyov@gmail.com> wrote:

Please don't top post.

> Thanks for your reply.
> 
> So with regards to parallelization, I need to use multiple queues, correct?

Not necessarily, but it avoids contention for a (single) queue.

> Also, with --queue-balance, will the same (src_ip, dst_ip) pair always
> map to the same queue?

Yes, all saddr,daddr [and replies] get into same queue.
