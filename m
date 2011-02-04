From: Patrick McHardy <kaber@trash.net>
Subject: Re: WIP/RFC: add new module ebt_NFQUEUE for ebtables
Date: Fri, 04 Feb 2011 14:07:41 +0100
Message-ID: <4D4BFA1D.4070007@trash.net>
References: <4D49E1E0.50304@trash.net> <1296743540-8148-1-git-send-email-chifflier@edenwall.com> <4D4BCF5E.8020100@edenwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pierre Chifflier <chifflier@edenwall.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46291 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab1BDNH6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Feb 2011 08:07:58 -0500
In-Reply-To: <4D4BCF5E.8020100@edenwall.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04.02.2011 11:05, Pierre Chifflier wrote:
> On 02/03/2011 03:32 PM, Pierre Chifflier wrote:
> 
>> The current problems I'm facing are described in the previous mail,
>> and specifically a fault in skb_free, deep inside the br_handle_frame code
>> after a reinject.
>> I'll try to isolate a backtrace when it happens.
>>
> 
> Hi,
> 
> The backtrace is more or less the same as the one in Jan's email
> <alpine.LNX.2.01.1102031605330.21536@obet.zrqbmnf.qr>
> (Kernel crash with repeated NF invocation)
> 
> At the moment, I'm wondering if I'm not having several cumulated
> problems, which may be triggered more easily by my modifications ...

We can't really help debug this without seeing the code, so please
post your current version (either privately or to the list).
