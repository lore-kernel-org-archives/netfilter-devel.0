From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Netfilter hooks on SMP?
Date: Thu, 20 Mar 2008 15:17:19 +0100 (CET)
Message-ID: <alpine.LNX.1.00.0803201504340.10642@fbirervta.pbzchgretzou.qr>
References: <87bed2001e2a343fd125af9b3c97f8c4@nadia>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@vger.kernel.org
To: strawks <strawks@yahoo.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33941 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873AbYCTORV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Mar 2008 10:17:21 -0400
In-Reply-To: <87bed2001e2a343fd125af9b3c97f8c4@nadia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Mar 20 2008 14:42, strawks wrote:
>
> This hook should be executed in a softirq, and so could be run by multiple
> CPUs at the same time.
>
> This seems to be the case when 2 NICs are used (tested on a dual Xeon,
> 85%"load on each CPU).
>
> But when there is only one NIC, only one CPU is used.

Correct, each network card has an assigned interrupt, and when that fires,
the CPU assigned for this interrupt will process the NIC buffer
(which may have multiple packets).

> Is there a way to make packets coming from a single NIC handled by multiple
> CPUs?

Possibly. I think the netif_rx() function in net/core/dev.c
is the sweet spot:

         queue = &__get_cpu_var(softnet_data);

include/linux/netdevice.h tells us about softnet_data:

 	/*
 	 * Incoming packets are placed on per-cpu queues so that
 	 * no locking is needed.
 	 */

which means if you distribute packets across CPUs (by using
something else than __get_cpu_var), you need additional locking
or rcu.
