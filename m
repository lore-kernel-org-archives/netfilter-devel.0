From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 3/8] netfilter: xtables: inclusion of xt_TEE
Date: Tue, 13 Apr 2010 18:17:01 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004131816070.7914@obet.zrqbmnf.qr>
References: <1271162268-28131-1-git-send-email-jengelh@medozas.de> <1271162268-28131-4-git-send-email-jengelh@medozas.de> <4BC4756B.4090307@trash.net> <alpine.LSU.2.01.1004131801570.7914@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51684 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158Ab0DMQRC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 12:17:02 -0400
In-Reply-To: <alpine.LSU.2.01.1004131801570.7914@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2010-04-13 18:09, Jan Engelhardt wrote:
>>
>>> +#ifdef WITH_CONNTRACK
>>> +	nf_conntrack_put(skb->nfct);
>>> +	skb->nfct     = &tee_track.ct_general;
>>> +	skb->nfctinfo = IP_CT_NEW;
>>> +	nf_conntrack_get(skb->nfct);
>>> +#endif
>>
>>Why do we still need this? I thought the reentrancy-counter should take
>>care of this?
>
>Did I really delete that commit... it's done so that conntrack
>does not count the duplicated packets towards the original
>connection.

While at that, would retaining the old skb's nfctinfo make any sense?
