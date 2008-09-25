From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipt_recent misuses jiffies? misreports oldest_pkt too
Date: Thu, 25 Sep 2008 08:02:06 +0200
Message-ID: <48DB295E.9080102@trash.net>
References: <6fvld41g81t1ognd9h8uhkmlro5ghogal2@4ax.com> <48DB17BE.3060905@trash.net> <iv8md4tqst7jb7j6b3qfokfua9t7qbhth0@4ax.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Grant Coady <gcoady.lk@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58991 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbYIYGCK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Sep 2008 02:02:10 -0400
In-Reply-To: <iv8md4tqst7jb7j6b3qfokfua9t7qbhth0@4ax.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Grant Coady wrote:
> On Thu, 25 Sep 2008 06:46:54 +0200, Patrick McHardy <kaber@trash.net> wrote:
> 
>> Indeed, its completely useless information. Actually I don't see
>> much use for anything in that proc file, but again, I kept it for 
>> compatiblity.
> 
> Twice you mention compatibility, should I plan on a replacement so the 
> old code can be deprecated over time?  The proc file is useful for 
> external timebase process to remove stale IPs or inject IPs for service 
> quota limiting.  (At least, I can see a use for it that way).

The tree I pointed to includes a port of ipt_recent to IPv6 and
adds a new proc file for that. So you could just fix it for the
new proc file, that avoids all compatibility issues.

>> Please base your patches on
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-next-2.6.git
> 
> Yeah, me git-challenged ;) got to figure out how to make two trees 
> (this and kernel) play together?  Got the git dribbling in at all of 
> 3k/s (900k objects). 

Its a full tree, so you can simply compile and boot that one.
Or you can pull it into an existing clone of Linus' tree.
