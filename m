From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] libxtables: change option precedence order to be intuitive
Date: Mon, 15 Nov 2010 14:15:16 +0100
Message-ID: <4CE13264.3010104@trash.net>
References: <1289824097-27337-1-git-send-email-jengelh@medozas.de> <4CE12DF3.8050108@trash.net> <alpine.LNX.2.01.1011151413200.30546@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64475 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab0KONPQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 08:15:16 -0500
In-Reply-To: <alpine.LNX.2.01.1011151413200.30546@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 15.11.2010 14:13, Jan Engelhardt wrote:
> On Monday 2010-11-15 13:56, Patrick McHardy wrote:
> 
>> On 15.11.2010 13:28, Jan Engelhardt wrote:
>>> The following changes since commit 648fd1ad68ae2ec675ac07efee80783912535404:
>>>                                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>
>>>   libxt_TOS: avoid an undesired overflowing computation (2010-11-02 09:17:09 +0100)
>>>
>>> are available in the git repository at:
>>>   git://dev.medozas.de/iptables master
>>
>> Well, as I'm sure you're aware this doesn't apply to the
>> current tree, so please rebase.
> 
> Revert the revert and merge?
> 

Yes please.
