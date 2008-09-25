From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipt_recent misuses jiffies? misreports oldest_pkt too
Date: Thu, 25 Sep 2008 06:46:54 +0200
Message-ID: <48DB17BE.3060905@trash.net>
References: <6fvld41g81t1ognd9h8uhkmlro5ghogal2@4ax.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Grant Coady <gcoady.lk@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57514 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbYIYEq5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Sep 2008 00:46:57 -0400
In-Reply-To: <6fvld41g81t1ognd9h8uhkmlro5ghogal2@4ax.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Grant Coady wrote:
> Hi there,
> 
> Given The LDD says:
> "note that the actual clock frequency is almost completely hidden from user
> space. The macro HZ always expands to 100 when user-space programs include
> param.h, and every counter reported to user space is converted accordingly. 
> This applies to clock(3), times(2), and any related function."
> 
> Why does ipt_recent expose jiffies to userspace when there seems to be no 
> reliable method to determine the jiffies/second rate?  Should not ipt_recent 
> report in 10ms increments to match 'official jiffies'? (or why not epoch 
> seconds?)  I asked about this on lkml and received no response.  

It probably should use USER_HZ units. I just rewrote it, but kept
the old interface as it was for compatibility.

> There's also another problem with ipt_recent misreporting oldest_pkt -- 
> the number given is meaningless as it is not an offset to the oldest 
> packet timestamp, nor does it indicate how many packets have been seen.
> There seems to be a problem when the table is full, I'm still collecting 
> data on this.

Indeed, its completely useless information. Actually I don't see
much use for anything in that proc file, but again, I kept it for 
compatiblity.

> Is anyone working on a fix for ipt_recent?  If not I'll have a go, need to 
> do a whitespace cleanup first then fix the issues.

Please base your patches on

git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-next-2.6.git
