From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V4 0/3] Add mark target
Date: Thu, 2 Apr 2015 10:57:31 +0200
Message-ID: <20150402085731.GA24296@salvia>
References: <1427682948-18699-1-git-send-email-zhangcy@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Zhang Chunyu <zhangcy@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44629 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbbDBIx3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Apr 2015 04:53:29 -0400
Content-Disposition: inline
In-Reply-To: <1427682948-18699-1-git-send-email-zhangcy@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Mar 29, 2015 at 10:35:45PM -0400, Zhang Chunyu wrote:
> v1:
>   add mark target for arptables
> 
> v2:
>   add --and-mark
>   add --or-mark
>   add revision for common api
> 
> v3:
>   fold 2/4, 3/4 and 4/4 patch into one single patch
>   use C99 initialization
>   change some format
> 
> V4:
>   resubmit the kernel patch

net/netfilter/xt_mark.c is missing a small change, you have to add
MODULE_ALIAS("arpt_MARK").

And after that, I hitting here:

# arptables -I OUTPUT -j MARK --set-mark 1
arptables: Protocol wrong type for socket

With my arptables patches applied in first place, so I suspect the
right revision is not being set in what we send to the kernel from
userspace.
