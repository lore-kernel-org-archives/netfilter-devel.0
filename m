From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC 3/3] netfilter: rename nfnetlink_queue_core.c to
 nfnetlink_queue.c
Date: Thu, 10 Sep 2015 02:09:58 +0200
Message-ID: <20150910000958.GC5734@salvia>
References: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
 <1441731291-21342-4-git-send-email-pablo@netfilter.org>
 <20150909095516.GC11843@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33099 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbbIJADW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Sep 2015 20:03:22 -0400
Content-Disposition: inline
In-Reply-To: <20150909095516.GC11843@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 09, 2015 at 06:55:16PM +0900, Ken-ichirou MATSUZAWA wrote:
> On Tue, Sep 08, 2015 at 06:54:51PM +0200, Pablo Neira Ayuso wrote:
> [...]
> > rename from net/netfilter/nfnetlink_queue_core.c
> > rename to net/netfilter/nfnetlink_queue.c
> 
> So you know though, we can delete the nfnetlink_queue_core.o line
> from Makefile.

Right, the Makefile update is missing. I'm going to fix that here.

> May I suggest one thing? How about returning -EOPNOTSUPP at
> nfqnl_recv_config() if derefering nfq_ct_hook is NULL?

Makes sense. Thus, the user knows that it is not supported, please
send a patch for that.

BTW, I think it would be good to add the missing code on
nfqnl_recv_verdict_batch() to support conntrack there too. Would you
add that code for nfnetlink_queue.c?

Thanks.
