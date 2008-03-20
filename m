From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Netfilter hooks on SMP?
Date: Thu, 20 Mar 2008 16:00:28 +0100 (CET)
Message-ID: <alpine.LNX.1.00.0803201554580.10642@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.00.0803201504340.10642@fbirervta.pbzchgretzou.qr> <f25ec17f7669d6877cc52f0ca5dc27d3@nadia>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@vger.kernel.org
To: strawks <strawks@yahoo.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52734 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbYCTPA3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Mar 2008 11:00:29 -0400
In-Reply-To: <f25ec17f7669d6877cc52f0ca5dc27d3@nadia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Mar 20 2008 15:47, strawks wrote:
>
> So when the driver exits the IRQ handler for its device, IRQ are reenabled.
> If a packet comes before the softirq has finished with the previous
> packet(s), an IRQ is raised again.

> It appears that this IRQ will be handled by the same CPU.
> But is it possible that the second IRQ should be handled by another CPU?

Yes, by balancing the IRQ elsewhere, in short, setting its CPU affinity
mask accordingly.

But if the processing of packets takes most of the time, then you
should not worry about balancing NIC IRQs, but enqueueing the
packets onto the right softirq thread.

> I don't really know how IRQs are handled on SMP (nor I know
> how irq-balance works)

IRQs are enabled for one CPU only in the general case, and
balancing it should be straightforward.
I have no idea what happens if the affinity mask allows an IRQ
for more than one CPU, but you should not worry about that, because

  (a) you probably do not want a deliver-to-a-random-CPU behavior nor
  (b) deliver-to-all

(since I doubt the hardware does (c) round-robin automatically)
