From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/5] netfilter: xt extensions: use pr_<level> (2)
Date: Thu, 25 Mar 2010 14:59:43 +0100
Message-ID: <4BAB6C4F.9040002@trash.net>
References: <1269521809-29393-1-git-send-email-jengelh@medozas.de> <1269521809-29393-3-git-send-email-jengelh@medozas.de> <4BAB604A.2090808@trash.net> <alpine.LSU.2.01.1003251414350.30248@obet.zrqbmnf.qr> <4BAB64D1.2070404@trash.net> <alpine.LSU.2.01.1003251443530.32573@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52539 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab0CYN7n (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Mar 2010 09:59:43 -0400
In-Reply-To: <alpine.LSU.2.01.1003251443530.32573@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2010-03-25 14:27, Patrick McHardy wrote:
>> Fair enough, but some consistency among modules would be great. There
>> are a few instances of pr_err/warning used for memory allocation errors
>> or invalid parameters in this patch.
> 
> As far as I can see, I've been consistent.
> 
> pcregrep -r 'pr_(?!info)' net/ipv4/netfilter/ net/ipv6/netfilter/
> net/bridge/netfilter/ net/netfilter/ | grep -v pr_debug |
> grep -v pr_fmt | less
> 
> Only shows either lines outside .checkentry, or things that really
> are an error, such as xt_LED.c being unable to register its ledtrigger,
> which is not a "user parameter error" and thus would not be pr_info.
> 
> If you see inconsistency, could you hint me towards it?

Right, I didn't notice these were all outside of checkentry.
