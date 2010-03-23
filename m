From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 8/9] netfilter: xtables: inclusion of xt_TEE
Date: Tue, 23 Mar 2010 13:29:21 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003231327070.12342@obet.zrqbmnf.qr>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de> <1268831945-6041-9-git-send-email-jengelh@medozas.de> <4BA0DAB3.3000700@trash.net> <alpine.LSU.2.01.1003200252060.762@obet.zrqbmnf.qr> <4BA7A1C8.8050402@trash.net> <alpine.LSU.2.01.1003221831070.2821@obet.zrqbmnf.qr>
 <4BA8AE4A.5090805@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42732 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946Ab0CWM3X (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Mar 2010 08:29:23 -0400
In-Reply-To: <4BA8AE4A.5090805@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2010-03-23 13:04, Patrick McHardy wrote:
>> 
>>>> Setting IP_DF on the cloned skb could possibly lead to a Packet Too
>>>> Big being sent back to the original sender - which should probably be
>>>> avoided too.
>>> Indeed. This might also happen if the packet is passed through another
>>> router of course.
>> 
>> Right. So let's set IP_DF on the teed packet and let the sender
>> reduce its packet size to accomodate for the (hidden) tee route :)
>> 
>> Is it ok if the Packet Too Big notification is received by the
>> original sender much later than an acknowledgement in reception to
>> the packet?
>
>I think its the responsibility of the admin to make sure that
>doesn't happen.

Is that so?

1. sending the clone through a tunnel - admin can't do much about MTU getting
smaller here.

2. the PTB may take longer to reach the source due to internet
routing - nothing the admin can really influence either.
