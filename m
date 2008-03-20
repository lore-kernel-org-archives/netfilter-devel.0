From: strawks <strawks@yahoo.fr>
Subject: Re: Netfilter hooks on =?UTF-8?Q?SMP=3F?=
Date: Thu, 20 Mar 2008 15:47:16 +0100
Message-ID: <f25ec17f7669d6877cc52f0ca5dc27d3@nadia>
References: <alpine.LNX.1.00.0803201504340.10642@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp19.orange.fr ([80.12.242.17]:58068 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbYCTOrU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Mar 2008 10:47:20 -0400
In-Reply-To: <alpine.LNX.1.00.0803201504340.10642@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



On Thu, 20 Mar 2008 15:17:19 +0100 (CET), Jan Engelhardt
<jengelh@computergmbh.de> wrote:
> On Mar 20 2008 14:42, strawks wrote:
>> Is there a way to make packets coming from a single NIC handled by
> multiple
>> CPUs?
> 
> Possibly. I think the netif_rx() function in net/core/dev.c
> is the sweet spot:
> 
>          queue = &__get_cpu_var(softnet_data);
> 
> include/linux/netdevice.h tells us about softnet_data:
> 
>  	/*
>  	 * Incoming packets are placed on per-cpu queues so that
>  	 * no locking is needed.
>  	 */
> 
> which means if you distribute packets across CPUs (by using
> something else than __get_cpu_var), you need additional locking
> or rcu.

Thanks for your reply!

netif_rx is called by the NIC driver, by the IRQ handler (maybe I'm wrong
since NAPI may work differently), to queue packets which will be handled by
the softirq.

So when the driver exits the IRQ handler for its device, IRQ are reenabled.
If a packet comes before the softirq has finished with the previous
packet(s), an IRQ is raised again. It appears that this IRQ will be handled
by the same CPU. But is it possible that the second IRQ should be handled
by another CPU? I don't really know how IRQs are handled on SMP (nor I know
how irq-balance works)
-- 
Regards,
strawks



