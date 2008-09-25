From: Grant Coady <grant_lkml@dodo.com.au>
Subject: ipt_recent misuses jiffies? misreports oldest_pkt too
Date: Thu, 25 Sep 2008 13:22:30 +1000
Message-ID: <6fvld41g81t1ognd9h8uhkmlro5ghogal2@4ax.com>
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:65014 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752166AbYIYDWr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Sep 2008 23:22:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi there,

Given The LDD says:
"note that the actual clock frequency is almost completely hidden from user
space. The macro HZ always expands to 100 when user-space programs include
param.h, and every counter reported to user space is converted accordingly. 
This applies to clock(3), times(2), and any related function."

Why does ipt_recent expose jiffies to userspace when there seems to be no 
reliable method to determine the jiffies/second rate?  Should not ipt_recent 
report in 10ms increments to match 'official jiffies'? (or why not epoch 
seconds?)  I asked about this on lkml and received no response.  

So I am here looking for answers ;)  So far the most reliable way to 
discover jiffie rate is to look at .config, but this fails if .config 
is not available (user hasn't compiled own kernel), so where else does 
one look for that jiffies rate number?  The /proc/timer_list gives 
conflicting results on different hardware, its jiffies value can be 
somewhat fictional:

fictional:
grant@pooh64:~$ awk 'NR==FNR{up=$1}/^jiff/{print $2/up}' \
	/proc/uptime /proc/timer_list
53109
53109
grant@pooh64:~$ awk '/^CONFIG_HZ=/ {split($1, a, "="); print a[2]}' \
	/lib/modules/$(uname -r)/build/.config
300


reasonable:
grant@deltree:~$ awk 'NR==FNR{up=$1}/^jiff/{print $2/up}' \
	/proc/uptime /proc/timer_list
249.865
grant@deltree:~$ awk '/^CONFIG_HZ=/ {split($1, a, "="); print a[2]}' \
	/lib/modules/$(uname -r)/build/.config
250

There's also another problem with ipt_recent misreporting oldest_pkt -- 
the number given is meaningless as it is not an offset to the oldest 
packet timestamp, nor does it indicate how many packets have been seen.
There seems to be a problem when the table is full, I'm still collecting 
data on this.

Is anyone working on a fix for ipt_recent?  If not I'll have a go, need to 
do a whitespace cleanup first then fix the issues.

I'm using iptables 1.4.1.1 with linux-2.6.26.5 on slackware-11.0.

Thanks,
Grant.
