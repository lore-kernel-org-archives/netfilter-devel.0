From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 7/8] libxtables: symbol visibility
Date: Fri, 4 Feb 2011 14:22:49 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1102041421530.5968@obet.zrqbmnf.qr>
References: <1296824935-4606-1-git-send-email-jengelh@medozas.de> <1296824935-4606-8-git-send-email-jengelh@medozas.de> <4D4BFB75.4080803@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52242 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab1BDNWu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Feb 2011 08:22:50 -0500
In-Reply-To: <4D4BFB75.4080803@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-02-04 14:13, Patrick McHardy wrote:

>On 04.02.2011 14:08, Jan Engelhardt wrote:
>> -void xtables_free_opts(int unused)
>> +EXPORT_SYMBOL void xtables_free_opts(int unused)
>
>This is pretty ugly in my opinion. Please do something like this:
>
>#define EXPORT_SYMBOL(x)        typeof(x) (x)
>__attribute__((visibility("default")))
>
>so you can use EXPORT_SYMBOL as in the kernel.

But that is redundancy nonplusultra. The reason why EXPORT_SYMBOL is a 
separate statement is because it is much more than just a function 
attribute inside the kernel.
