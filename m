From: Florian Westphal <fw@strlen.de>
Subject: Re: [v5 PATCH 1/1] netfilter: Add fail-open support
Date: Thu, 24 May 2012 22:42:05 +0200
Message-ID: <20120524204205.GB23617@breakpoint.cc>
References: <20120524135631.24345.60254.sendpatchset@localhost.localdomain>
 <20120524135644.24345.694.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, pablo@netfilter.org, vivk@us.ibm.com,
	svajipay@in.ibm.com, netfilter-devel@vger.kernel.org,
	sri@us.ibm.com
To: Krishna Kumar <krkumar2@in.ibm.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60951 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756132Ab2EXUmM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 May 2012 16:42:12 -0400
Content-Disposition: inline
In-Reply-To: <20120524135644.24345.694.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Krishna Kumar <krkumar2@in.ibm.com> wrote:
> Implement a new "fail-open" mode where packets are not dropped
> upon queue-full condition. This mode can be enabled/disabled per
> queue using netlink NFQA_CFG_FLAGS & NFQA_CFG_MASK attributes.
> 
> Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
> Signed-off-by: Vivek Kashyap <vivk@us.ibm.com>
> Signed-off-by: Sridhar Samudrala <samudrala@us.ibm.com>
> ---
>  include/linux/netfilter/nfnetlink_queue.h |    5 ++
>  net/netfilter/nfnetlink_queue.c           |   40 ++++++++++++++++++--
>  2 files changed, 42 insertions(+), 3 deletions(-)

Looks good to me.  Thanks for your patience!
