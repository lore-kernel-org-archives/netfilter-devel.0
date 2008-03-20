From: strawks <strawks@yahoo.fr>
Subject: Re: Netfilter hooks on =?UTF-8?Q?SMP=3F?=
Date: Thu, 20 Mar 2008 18:17:11 +0100
Message-ID: <c69068465a754f44c3cbdfefe408f086@nadia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp19.orange.fr ([80.12.242.18]:15389 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755958AbYCTRRS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Mar 2008 13:17:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thu, 20 Mar 2008 16:00:28 +0100 (CET), Jan Engelhardt
<jengelh@computergmbh.de> wrote:
> But if the processing of packets takes most of the time, then you
> should not worry about balancing NIC IRQs, but enqueueing the
> packets onto the right softirq thread.
>
>> I don't really know how IRQs are handled on SMP (nor I know
>> how irq-balance works)
>
> IRQs are enabled for one CPU only in the general case, and
> balancing it should be straightforward.
> I have no idea what happens if the affinity mask allows an IRQ
> for more than one CPU, but you should not worry about that, because
>
>   (a) you probably do not want a deliver-to-a-random-CPU behavior nor
>   (b) deliver-to-all
>
> (since I doubt the hardware does (c) round-robin automatically)

I'm not sure that hardware does not automatically balance IRQs
(/proc/interrupts/#/smp_affinity is a bitfield used to balance IRQs, and I
suppose the APIC does the balancing).

Also, I found this thread on this maling list :
http://marc.info/?t=119094666500002&r=1&w=4

I'll take a look at this patch, it looks really interesting.

regards,
strawks



