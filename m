From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables not working with monolithic 2.6.26.5 kernel on ARM
Date: Sun, 05 Oct 2008 15:21:06 +0200
Message-ID: <48E8BF42.6010906@trash.net>
References: <18661.41641.113458.932029@martins.ozlabs.org> <48E6166F.40607@trash.net> <alpine.LNX.1.10.0810031006260.3893@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Martin Schwenke <martin@meltin.net>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44612 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbYJENVM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 09:21:12 -0400
In-Reply-To: <alpine.LNX.1.10.0810031006260.3893@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Friday 2008-10-03 08:56, Patrick McHardy wrote:
>> If I remember correctly we had a similar reports that were related to ABI
>> mismatches. Please verify that both userspace and kernel are using the
>> same ABI, in case they are please post your .config.
> 
> Well, the kernel/userspace certainly has support for mixed 64/32 ABI,
> so calling for both being the same seems like an unnecessary push.

My knowledge of ARM is quite limited, so you're probably right
that its not necessary to have all of userspace match the kernel
ABI. But I think its necessary for iptables to avoid alignment
differences.
