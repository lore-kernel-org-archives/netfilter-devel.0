From: Jan Engelhardt <jengelh@medozas.de>
Subject: Fwd: xt_recent compat code supposedly broken
Date: Fri, 24 Apr 2009 10:43:35 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904241032310.20106@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, Josef Drexler <joe-lk@ttdpatch.net>,
	Roman Hoog Antink <rha@open.ch>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36064 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbZDXIni (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Apr 2009 04:43:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


[Cc: netfilter-devel and people that touched the code v2.6.28..v2.6.29]

>---------- Forwarded message ----------
>Date: Thu, 23 Apr 2009 17:52:12
>From: Roman Hoog Antink
>To: Jan Engelhardt
>
>Linux kernels 2.6.28 and 2.6.29 seem to have troubles, applying iptables
>rules correctly that use the recent match.
>
>See here for a bug description:
>https://bugs.launchpad.net/ubuntu/+source/linux/+bug/365539
>
>The duplicate entries can be created with the new /proc/net/xt_recent/
>files only. Successive "echo IP >/proc/net/xt_recent/test" calls cause
>a double entry of IP. More echo's wont increase the number of duplicates.
>This effect occurred with 2.6.29 only sporadically. After booting the
>kernel the first time, it worked for some hours (jiffies overrun?), then
>it stopped working (without reboot). When investigating the next day in the
>morning, the problem was there again and right this afternoon it vanished.
>
>The duplicate entries occur always together with the ignored recent rules.
>
>The denied removal of entries (echo -IP >/proc/net/xt_recent/test) only
>occurs on Ubuntu Jaunty Beta (linux 2.6.28), where
>CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT is not set. And here I was
>able to produce more than 2 duplicate entries by successive echo +IP >..
>executions. The flush command '/' works correctly in any case.
>
>I am sorry to report a sporadic problem, as I painfully know, they are the
>hardest to track down.
>
>---------- Forwarded message ----------
>Date: Fri, 24 Apr 2009 09:19:51
>
>I updated the bug description
>https://bugs.launchpad.net/ubuntu/+source/linux/+bug/365539
>
>It seems, that on kernel 2.6.29, only the COMPAT option is buggy. On kernel
>2.6.28 (used by Jaunty) however, xt_recent.ko has no effect on iptables rules.
