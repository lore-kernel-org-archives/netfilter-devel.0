From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nft_ct: fix unpaired nf_connlabels_get/put
 call
Date: Mon, 18 Jul 2016 21:52:34 +0200
Message-ID: <20160718195234.GA5492@salvia>
References: <1468650441-17407-1-git-send-email-zlpnobody@163.com>
 <20160716091801.GB6123@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@163.com>, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59281 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbcGRTwn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jul 2016 15:52:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E72A2168385
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Jul 2016 21:52:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D800E9EBBB
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Jul 2016 21:52:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B0E3A9EBC1
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Jul 2016 21:52:39 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160716091801.GB6123@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 16, 2016 at 11:18:01AM +0200, Florian Westphal wrote:
> Liping Zhang <zlpnobody@163.com> wrote:
> > From: Liping Zhang <liping.zhang@spreadtrum.com>
> > 
> > We only get nf_connlabels if the user add ct label set expr successfully,
> > but we will also put nf_connlabels if the user delete ct lable get expr.
> > This is mismathced, and will cause ct label expr cannot work properly.
> > 
> > Also, if we init something fail, we should put nf_connlabels back.
> > Otherwise, we may waste to alloc the memory that will never be used.
> 
> Acked-by: Florian Westphal <fw@strlen.de>
> 
> Unrelated to your patch:
> 
> I think its time to change conntrack labels to a pure 128 bit field:

I think this is going to simplify this code a bit, so go ahead with this.
