From: Sergey Popovich <popovich_sergei@mail.ua>
Subject: Re: ipset: Proposed improvements to the kernel code
Date: Wed, 25 Mar 2015 18:11:26 +0200
Message-ID: <7893986.4pVhdOQPzb@tuxracer>
References: <2984705.dCFJb2qqrb@tuxracer> <14722035.jXe0WcxyPC@tuxracer> <20150325160536.GA4360@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp44.i.mail.ru ([94.100.177.104]:58220 "EHLO smtp44.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587AbbCYQLd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 12:11:33 -0400
In-Reply-To: <20150325160536.GA4360@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> On Wed, Mar 25, 2015 at 04:54:54PM +0200, Sergey Popovich wrote:

> Could please send small batch (not more than 10 patches in one go,
> please) to the mailing list so everyone can help in reviewing this?

Not a problem.

My series of patches for nf-next, while Jozsef would like to receive
patches against ipset git tree and rebase may take a while.

Main problem with rebase is that my series implementing RCU, but
this implementation differs from one found in the current ipset git
tree.

This causes excessive number of conflicts, requiring lot of porting
to ipset git tree.

As option I could send only bugfixes to the current nf-next, of course
if Jozsef acknowledges them.

Thanks for the interest.

> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
SP5474-RIPE
Sergey Popovich

