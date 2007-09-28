From: "John Ye" <johny@asimco.com.cn>
Subject: remarkably Increase iptables' speed on SMP system.
Date: Fri, 28 Sep 2007 10:15:34 +0800
Message-ID: <00de01c80175$7402ef90$ca8510ac@asimco>
Cc: " john ye" <johny@asimco.com.cn>, "YE QY" <iceburgue@gmail.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.asimco-na.com ([207.138.153.195]:3367 "EHLO
	mail.asimco-na.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262AbXI1C30 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Sep 2007 22:29:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

All,

Iptables can't make full use of SMP because it runs in softirq.
There are many reports or complains saying that when netfilter runs, only one or two CPUs are busy doing softirq while others are
idle. see http://www.ussg.iu.edu/hypermail/linux/kernel/0702.0/1833.html, you can find many of these reports by googleING 'iptables
SMP sofitrq'.
This situation becomes especially worse when iptables' load is high, for example, when there are too many rules to match or there
are too many connections to track.
irqbalance looks like resolving this problem, but it does NOT. Balancing irq among CPUs doesn't mean to take full advantages of SMP
in any sense, periodically shifting NIC irq among CPUs can't gain extra processing speed(Because CPUs are not concurrently run in
softirq), when irq is shifted from CPU0 to CPU1, the CPU1 is busy, CPU0 becomes idle.
Linux network irq handling code tends to collect same irqs on different CPUs into one CPU when NIC is busy.
This tendency will make irqblance not work well. After running iptables for some time, the originally balanced irq may become
unbalanced. And, even if irqbalance works well, iptalbes' processing capacity doesn't go up.

There is a kernel patch to let softirq network code(iptables included in) concurrently run on every CPUs on SMP system.
We wrote the kernel patch, a loadable module as well, to totally resolve iptables SMP issue.
Have discussed with kernel netdev experts. it should be working.

The patch(module) will greatly increase the speed of iptalbes by making full use of every CPUs in SMP system.

It can be viewed and downloaded from blog http://blog.chinaunix.net/u/12848/showart.php?id=389602
You are welcome to review and test without patching and re-compiling the kerenl.

Thanks.

John Ye & Qianyu Ye



