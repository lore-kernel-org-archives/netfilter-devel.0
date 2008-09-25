From: Grant Coady <grant_lkml@dodo.com.au>
Subject: Re: ipt_recent misuses jiffies? misreports oldest_pkt too
Date: Thu, 25 Sep 2008 15:51:27 +1000
Message-ID: <iv8md4tqst7jb7j6b3qfokfua9t7qbhth0@4ax.com>
References: <6fvld41g81t1ognd9h8uhkmlro5ghogal2@4ax.com> <48DB17BE.3060905@trash.net>
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Grant Coady <gcoady.lk@gmail.com>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:44591 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751784AbYIYFvj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Sep 2008 01:51:39 -0400
In-Reply-To: <48DB17BE.3060905@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

On Thu, 25 Sep 2008 06:46:54 +0200, Patrick McHardy <kaber@trash.net> wrote:

>Grant Coady wrote:
>> Hi there,
>> 
>> Given The LDD says:
>> "note that the actual clock frequency is almost completely hidden from user
>> space. The macro HZ always expands to 100 when user-space programs include
>> param.h, and every counter reported to user space is converted accordingly. 
>> This applies to clock(3), times(2), and any related function."
>> 
>> Why does ipt_recent expose jiffies to userspace when there seems to be no 
>> reliable method to determine the jiffies/second rate?  Should not ipt_recent 
>> report in 10ms increments to match 'official jiffies'? (or why not epoch 
>> seconds?)  I asked about this on lkml and received no response.  
>
>It probably should use USER_HZ units. I just rewrote it, but kept
>the old interface as it was for compatibility.
>
>> There's also another problem with ipt_recent misreporting oldest_pkt -- 
>> the number given is meaningless as it is not an offset to the oldest 
>> packet timestamp, nor does it indicate how many packets have been seen.
>> There seems to be a problem when the table is full, I'm still collecting 
>> data on this.
>
>Indeed, its completely useless information. Actually I don't see
>much use for anything in that proc file, but again, I kept it for 
>compatiblity.

Twice you mention compatibility, should I plan on a replacement so the 
old code can be deprecated over time?  The proc file is useful for 
external timebase process to remove stale IPs or inject IPs for service 
quota limiting.  (At least, I can see a use for it that way).
...
>Please base your patches on
>
>git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-next-2.6.git

Yeah, me git-challenged ;) got to figure out how to make two trees 
(this and kernel) play together?  Got the git dribbling in at all of 
3k/s (900k objects). 

Thanks,
Grant.
