From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [patch] xtables: use guarded types
Date: Fri, 10 Dec 2010 11:24:05 +0100
Message-ID: <4D01FFC5.90808@netfilter.org>
References: <alpine.LNX.2.01.1012032012320.26825@obet.zrqbmnf.qr> <4D00B2D7.4010401@netfilter.org> <alpine.LNX.2.01.1012092024000.30670@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49915 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab0LJKZH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Dec 2010 05:25:07 -0500
In-Reply-To: <alpine.LNX.2.01.1012092024000.30670@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09/12/10 20:25, Jan Engelhardt wrote:
> On Thursday 2010-12-09 11:43, Pablo Neira Ayuso wrote:
> 
>> On 03/12/10 20:13, Jan Engelhardt wrote:
>>> parent b880c1f077000956b9f475d5f3b6c5e45ff2e342 (v2.6.37-rc1-241-gb880c1f)
>>> commit 4826151aedbe6e364b7b801f026fbe7383904b6a
>>> Author: Jan Engelhardt <jengelh@medozas.de>
>>> Date:   Thu Dec 2 21:01:17 2010 +0100
>>>
>>> netfilter: xtables: use guarded types
>>>
>>> We are supposed to use the kernel's own types in userspace exports.
>>
>> What's the point to have different headers in the kernel source code
>> tree and iptables?
> 
> Because iptables needs to know more structs than the kernel provides.
> 
> But... what does that have to do with the patch?

I mean that, after this patch, iptables headers and Linux kernel headers
will be out of sync, right?
