From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] ipvs: use list_del_init instead of
 list_del/INIT_LIST_HEAD
Date: Mon, 10 Sep 2012 11:16:05 +0200
Message-ID: <20120910091605.GA5661@1984>
References: <CAPgLHd_JMzWm-Eh48bXcq6xW2viVEQgmkxLU8KgVyD2gUk6sZQ@mail.gmail.com>
 <20120910000129.GA31408@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Wei Yongjun <weiyj.lk@gmail.com>, wensong@linux-vs.org, ja@ssi.bg,
	kaber@trash.net, yongjun_wei@trendmicro.com.cn,
	lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org
To: Simon Horman <horms@verge.net.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39585 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756851Ab2IJJQM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Sep 2012 05:16:12 -0400
Content-Disposition: inline
In-Reply-To: <20120910000129.GA31408@verge.net.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 10, 2012 at 09:01:30AM +0900, Simon Horman wrote:
> On Thu, Sep 06, 2012 at 12:21:53PM +0800, Wei Yongjun wrote:
> > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > 
> > Using list_del_init() instead of list_del() + INIT_LIST_HEAD().
> > 
> > spatch with a semantic match is used to found this problem.
> > (http://coccinelle.lip6.fr/)
> > 
> > Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Acked-by: Simon Horman <horms@verge.net.au>

Applied, thanks Simon and Wei.
