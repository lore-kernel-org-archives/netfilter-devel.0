From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: nf_conntrack: show helper and class in /proc/net/nf_conntrack_expect
Date: Wed, 20 Jan 2010 23:43:31 +0100
Message-ID: <4B578713.6050108@trash.net>
References: <20100120191824.25922.36663.sendpatchset@x2.localnet> <20100120191826.25922.78583.sendpatchset@x2.localnet> <alpine.LSU.2.01.1001202037020.8723@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, flo@degnet.de, madduck@debian.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46627 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab0ATWng (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jan 2010 17:43:36 -0500
In-Reply-To: <alpine.LSU.2.01.1001202037020.8723@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2010-01-20 20:18, Patrick McHardy wrote:
> 
>> commit 8a96ae7fda648925254899ad997d5fe3984d3cf6
>> Author: Patrick McHardy <kaber@trash.net>
>> Date:   Wed Jan 20 17:38:16 2010 +0100
>>
>>    netfilter: nf_conntrack: show helper and class in /proc/net/nf_conntrack_expect
>>    
>>    Make the output a bit more informative by showing the helper an expectation
>>    belongs to and the expectation class.
>>    
>>    Signed-off-by: Patrick McHardy <kaber@trash.net>
> 
> Should not we extend on conntrack(8) instead?

Yeah, I've been planning on doing that as well. Especially the
expectation support is kind of lacking - it has a lot more
information than those shown. But I think having this available
through /proc is still useful.
