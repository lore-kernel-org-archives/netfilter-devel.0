From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC 0/3] Rework nfnetlink_queue conntrack support
Date: Thu, 10 Sep 2015 02:06:15 +0200
Message-ID: <20150910000615.GB5734@salvia>
References: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
 <20150909095042.GA11843@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32866 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbbIIX7i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Sep 2015 19:59:38 -0400
Content-Disposition: inline
In-Reply-To: <20150909095042.GA11843@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 09, 2015 at 06:50:42PM +0900, Ken-ichirou MATSUZAWA wrote:
>  Hi Pablo,
> 
> Thank you for taking your time.
> 
> On Tue, Sep 08, 2015 at 06:54:48PM +0200, Pablo Neira Ayuso wrote:
> > They are totally untested, so please carefully review them.
> 
> I'm sorry I could not to meet your expectations since I might not
> understand your intention correctly, please let me ask three
> questions:
> 
> * We will not modularize nfqueue attaching conntrack information
>   part? (was nfnetlink_queue_ct.c)

After my patchset, everything is in nf_conntrack_netlink.c, so you
only need some little extra glue code to access the nfnl_ct
indirection from nfnetlink_log.c

> * May I update nfqnl_ct prefix to nfnl_ct after this patch series
>   applied to attach nfct info to nflog?

Yes, that's the idea.

> * We do not add another Kconfig for nflog attaching ct info?

I think you can add it too, yes.

> I tested your patch a little with following lnf-queue patch and
> it works fine.

Thanks for reporting.

So will you send a follow up patchset on top of those three to add
what you need?
