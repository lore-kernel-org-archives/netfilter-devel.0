From: Florian Westphal <fw@strlen.de>
Subject: Re: NFQUEUE parallelization
Date: Thu, 24 Sep 2015 22:48:40 +0200
Message-ID: <20150924204840.GC29479@breakpoint.cc>
References: <CAKEqNm=2vnqe_fmSTM4G7xWsHkrXP29f_QxLUf7v7_-f5ESyKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eugene Strulyov <eugene.strulyov@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:59560 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751639AbbIXUsn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Sep 2015 16:48:43 -0400
Content-Disposition: inline
In-Reply-To: <CAKEqNm=2vnqe_fmSTM4G7xWsHkrXP29f_QxLUf7v7_-f5ESyKQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eugene Strulyov <eugene.strulyov@gmail.com> wrote:
> When using multiple queues, is it valid to call nfq_open() multiple
> times in the same process?

Yes.

> When I do that I get negative numbers for
> peer portid. Is this normal?

> $ sudo cat /proc/net/netfilter/nfnetlink_queue
>   100  27790     0 2 65531     0     0        0  1
>   101  -4585     0 2 65531     0     0        0  1

The proc formatter in nfnetlink_queue uses %d instead of %u.
It was fixed a few months back.

> Also, how exactly does --queue-balance work? All packets seem to be
> directed to one particular queue.

Hash over ipv4/ipv6 source & dst addresses.
