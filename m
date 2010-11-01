From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrack-tools: build system cleanups
Date: Mon, 01 Nov 2010 23:09:01 +0100
Message-ID: <4CCF3A7D.4020703@netfilter.org>
References: <1288478982-6758-1-git-send-email-jengelh@medozas.de> <4CCF330B.9010605@netfilter.org> <alpine.LNX.2.01.1011012237270.13962@obet.zrqbmnf.qr> <alpine.LNX.2.01.1011012239390.19670@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53880 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268Ab0KAWJH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Nov 2010 18:09:07 -0400
In-Reply-To: <alpine.LNX.2.01.1011012239390.19670@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 01/11/10 22:40, Jan Engelhardt wrote:
> On Monday 2010-11-01 22:38, Jan Engelhardt wrote:
> 
>> On Monday 2010-11-01 22:37, Pablo Neira Ayuso wrote:
>>
>>> On 31/10/10 00:49, Jan Engelhardt wrote:
>>>> The following changes since commit 31ae56a2af1381459e4ec38c31ab810ffa410cf9:
>>>>
>>>>   conntrack: allow to listen to all kind of expectation events (2010-10-12 12:56:01 +0200)
>>>>
>>>> are available in the git repository at:
>>>>   git://dev.medozas.de/conntrack-tools master
>>>
>>> pulled and pushed this also. Thanks for all this build updates Jan :-).
> 
> Speaking of which, what's Mr. Undocumented Commit 
> 178b917b75bc531843e45da0b06c05a73cba0ff2 doing in 
> libnetfilter_conntrack?

oops, that has slipped through, it was a unfinished patch in my stgit
stack. I have removed and forced a push. Sorry.
