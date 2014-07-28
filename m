From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] reset nfacct counters
Date: Tue, 29 Jul 2014 00:03:19 +0200
Message-ID: <20140728220319.GB4093@salvia>
References: <20140725160123.GA20548@salvia>
 <1406570272-3704-1-git-send-email-a.perevalov@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kyungmin.park@samsung.com, hs81.go@samsung.com,
	netfilter-devel@vger.kernel.org, alexey.perevalov@hotmail.com,
	mathieu.poirier@linaro.org
To: Alexey Perevalov <a.perevalov@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47618 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbaG1WDH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jul 2014 18:03:07 -0400
Content-Disposition: inline
In-Reply-To: <1406570272-3704-1-git-send-email-a.perevalov@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 28, 2014 at 09:57:50PM +0400, Alexey Perevalov wrote:
> Hello Pablo,
> I used you guidance on flags usage for separate counters reset.
> If no flags were specified we'll have old behaviour. I wanted to remove
> NFNL_MSG_ACCT_GET_CTRZERO and use combination of (NFACCT_F_RESET_COUNTERS |
> NFACCT_F_RESET_QUOTAS). But in this case I didn't find how to solve backward
> compatibility issue.

Just made a proposal to avoid adding these new flags.

> You proposed to allocate memory for filter entity to use it with
> netlink_dump_control, but netlink_dump_start is synchronous all the way,
> and stack variable could be used there. But I could be wrong here and
> there is a use case where netlink_dump_control's callback is calling from
> another thread.

You can't do that. The dumping happens per recvmsg() call in netlink,
if the number of nfacct objects is larger than one page
(NLMSG_GOODSIZE), the next call to recvmsg() will reference to an
invalid memory area. You really need to allocate this, which is a bit
overkill for just one u32 flags filter, but I guess we'll have more
selectors to filter out nfacct objects in the future.

> Due nfnetlink_acct header was modified, I think I need to send additional patches
> for nfacct and libnetfilter_acct git reposotories. I saw such practice,
> nfnetlink_acct.h duplicates in these repositories.
> 
> This patch was made for git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> repository, on top of 633594bb2d3890711a887897f2003f41735f0dfa commit.

That tree is fine in this case, there is no changes in nf-next that
can clash with this.

> Do you need a patch for nfacct command line tool to support following behaviour:
> nfacct list reset [counter|quota] ?

Yes please :-), it would be great so others in the community can
benefit from this new feature, it's just little extra work. Thanks.
