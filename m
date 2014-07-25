From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: reset nfacct counters
Date: Fri, 25 Jul 2014 18:01:23 +0200
Message-ID: <20140725160123.GA20548@salvia>
References: <53D20FB8.9050606@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mathieu.poirier@linaro.org, netfilter-devel@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	alexey.perevalov@hotmail.com,
	=?utf-8?B?J+qzoO2YhOyEsSc=?= <hs81.go@samsung.com>
To: Alexey Perevalov <a.perevalov@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59749 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760675AbaGYQBV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:01:21 -0400
Content-Disposition: inline
In-Reply-To: <53D20FB8.9050606@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Alexey,

On Fri, Jul 25, 2014 at 12:05:12PM +0400, Alexey Perevalov wrote:
> Hello Pablo and Mathieu.
> I would like to thank you for quota with notification implementation
> in nfacct.
> 
> But also I want to discuss about resetting counters value. Right now
> nfacct has 2 way to get counter
> NFNL_MSG_ACCT_GET and NFNL_MSG_ACCT_GET_CTRZERO, last one is
> intended to nullify accumulated counter.
> It resets counters with and without populated quota value. After
> commit 683399eddb nfacct really operates
> with 2 different entities: pure counter and quota based counter. If
> so, why not to operate with it separately,
> maybe by some filter (flag).
> 
> Also it was strange for me, why reset is not a command of command
> line tool nfacct, like get? Ok, if it's an argument of get, why not
> it's a flag (attribute) in netlink serialization?
> 
> Why I'm asking such questions. My use case requires periodic reset
> of the counters, also I have quota based counters and I don't want
> to reset them.
>
> I could work around it from user space, for example, I could get
> quota based counter before I'm going to reset counters, delete it
> and key it in after counters reset. As you could see too much
> operations. Or I could could avoid reseting, but in this case I need
> to operates with deltas in user space and it's not robust in
> situation when my daemon is restarting. Every variant in user space
> leads to more run time complexity.
> 
> And my final question, will you accept a patch, which will move
> CTRZERO to netlink attribute and CTRZERO will be expanded to
> CTRZERO_OVERAL, CTRZERO_COUNTER and CTRZERO_QUOTA? For both kernel
> side and user space part (nfacct tool with libraries).

You can make a patch that uses NFACCT_FLAGS in the nfnl_acct_get()
path to specify the filtering criteria. In the nfnl_acct_get() path,
you can use c->data in struct netlink_dump_control to attach the
filter, which needs to be allocated before the dump_start() call and
released through the dump_done() callback. If no NFACCT_FLAGS are
specified, no filter is specified and all counters should be cleared
as it happens now.
