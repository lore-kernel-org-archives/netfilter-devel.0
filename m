From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next-2.6] netfilter: nfnetlink_log: RCU conversion
Date: Wed, 09 Jun 2010 18:15:47 +0200
Message-ID: <4C0FBE33.3030100@trash.net>
References: <1276099088.2442.196.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37256 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab0FIQPo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jun 2010 12:15:44 -0400
In-Reply-To: <1276099088.2442.196.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet wrote:
> - instances_lock becomes a spinlock
> - lockless lookups
>
> While nfnetlink_log probably not performance critical, using less
> rwlocks in our code is always welcomed...
>   


Looks good to me. Applied, thanks Eric.
