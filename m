From: Patrick McHardy <kaber@trash.net>
Subject: Re: The glorious NFCT "none" helper
Date: Tue, 07 Jun 2011 13:09:44 +0200
Message-ID: <4DEE06F8.2080909@trash.net>
References: <1305757266-8730-1-git-send-email-jengelh@medozas.de> <4DDA6F53.9060809@trash.net> <4DDA8184.3060407@netfilter.org> <alpine.LNX.2.01.1105231755550.18360@frira.zrqbmnf.qr> <4DDA8793.7010203@netfilter.org> <4DDB5901.2090607@trash.net> <4DDC00FF.6040405@netfilter.org> <4DEDFC36.6070301@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50555 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab1FGLJw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 07:09:52 -0400
In-Reply-To: <4DEDFC36.6070301@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07.06.2011 12:23, Patrick McHardy wrote:
> On 24.05.2011 21:03, Pablo Neira Ayuso wrote:
>> BTW, not related with this patch but I'd like to fix the current issue
>> with the userspace expectation support problem, still don't like my
>> patches to add a template and set one flag to explicitly tell conntrack
>> to allocate the helper CT extension?
> 
> This is too much exposure of implementation in my opinion, userspace
> shouldn't have to care about extension areas. I'll have another look
> at your patches to see if I can come up with an alternative.

I couldn't come up with anything reasonable that would be better than
your approach, so let's do that.
