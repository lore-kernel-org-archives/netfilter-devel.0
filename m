From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: nfqueue batch verdict with conntrack (was [PATCH RFC 3/3] netfilter:
 rename nfnetlink_queue_core.c to nfnetlink_queue.c)
Date: Thu, 10 Sep 2015 17:02:34 +0900
Message-ID: <20150910080234.GA26465@gmail.com>
References: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
 <1441731291-21342-4-git-send-email-pablo@netfilter.org>
 <20150909095516.GC11843@gmail.com>
 <20150910000958.GC5734@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33914 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbbIJICk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Sep 2015 04:02:40 -0400
Received: by padhy16 with SMTP id hy16so36053384pad.1
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2015 01:02:39 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150910000958.GC5734@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 10, 2015 at 02:09:58AM +0200, Pablo Neira Ayuso wrote:
> BTW, I think it would be good to add the missing code on
> nfqnl_recv_verdict_batch() to support conntrack there too. Would you

Sorry, I have never used it and I tried to understand, but...

It seems batch verdict mark and reinject packets in nfqueue its id
is less than user requested. What does conntrack (and payload) work
on it? update all conntrack expectations less than the id, to the
same one user requests?

Thanks,
