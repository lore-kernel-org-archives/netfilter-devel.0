From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: Re: [PATCHv2 nf-next 1/1] netfilter: nfnetlink_queue: check
 NFQA_CFG_F_CONNTRACK config flag
Date: Wed, 7 Oct 2015 13:20:17 +0900
Message-ID: <20151007042016.GA23203@gmail.com>
References: <1443724990-4014-1-git-send-email-pablo@netfilter.org>
 <1443724990-4014-2-git-send-email-pablo@netfilter.org>
 <20151005024454.GA14637@gmail.com>
 <20151005025046.GE14637@gmail.com>
 <20151005152315.GA11562@salvia>
 <20151006021001.GA30037@gmail.com>
 <20151006021246.GB30037@gmail.com>
 <20151006100728.GA2429@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33018 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbbJGEUW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Oct 2015 00:20:22 -0400
Received: by pacex6 with SMTP id ex6so8195857pac.0
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Oct 2015 21:20:22 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20151006100728.GA2429@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 06, 2015 at 12:07:28PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Oct 06, 2015 at 11:12:46AM +0900, Ken-ichirou MATSUZAWA wrote:
> > +		if (flags & mask & NFQA_CFG_F_CONNTRACK) {
> > +			if (!rcu_access_pointer(nfnl_ct_hook))
> > +#ifdef CONFIG_MODULES
> > +				if (request_module("ip_conntrack_netlink") ||
> 
> nfnl_lock is held while requesting a module, which is something that
> we should avoid. Please, abort the operation and return -EAGAIN to
> retry, this is the usual procedure when requesting other modules.

Thank you as always.

I read another request_module() part and I think I can understand,
would you review it again? I changed rcu_access_pointer() since
rcu_read_lock() is called in nfqnl_recv_config().

I think a few fix seems to be needed at that time, and try to fix
it in the following patches. Would you confirm these too?

Thanks,
