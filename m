From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: Re: [PATCH RFC 3/3] netfilter: rename nfnetlink_queue_core.c to
 nfnetlink_queue.c
Date: Wed, 9 Sep 2015 18:55:16 +0900
Message-ID: <20150909095516.GC11843@gmail.com>
References: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
 <1441731291-21342-4-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33257 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbbIIJzV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Sep 2015 05:55:21 -0400
Received: by pacex6 with SMTP id ex6so5885297pac.0
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Sep 2015 02:55:21 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1441731291-21342-4-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 08, 2015 at 06:54:51PM +0200, Pablo Neira Ayuso wrote:
[...]
> rename from net/netfilter/nfnetlink_queue_core.c
> rename to net/netfilter/nfnetlink_queue.c

So you know though, we can delete the nfnetlink_queue_core.o line
from Makefile.

May I suggest one thing? How about returning -EOPNOTSUPP at
nfqnl_recv_config() if derefering nfq_ct_hook is NULL?

Thanks,
