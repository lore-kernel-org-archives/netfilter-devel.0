From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/9] iptables-save: remove binary dumping dead code
Date: Mon, 12 Sep 2011 12:48:36 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1109121244070.32300@frira.zrqbmnf.qr>
References: <1315755359-7012-1-git-send-email-jengelh@medozas.de> <1315755359-7012-3-git-send-email-jengelh@medozas.de> <20110912093253.GC2194@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:56993 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915Ab1ILKsi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Sep 2011 06:48:38 -0400
In-Reply-To: <20110912093253.GC2194@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2011-09-12 11:32, Pablo Neira Ayuso wrote:
>>  
>> -static int show_binary = 0, show_counters = 0;
>> +static int show_counters = 0;
>>  
>>  static const struct option options[] = {
>> -	{.name = "binary",   .has_arg = false, .val = 'b'},
>
>Please, better something less agressive like displaying a message
>telling "-b option was never implemented, ignoring it".
>
>So if anyone, for some strange reason, is using it, their scripts will
>not break.
>
>I know this may sound a bit nitpicking but I think it's good to make
>sure that we don't break anything.

I think we are not talking about the same thing. If you run
`iptables-save -b`, the program will exit with status 1 without
printing anything related to rules. (Outputs "binary NYI" which, if
you happen to be able to resolve the acronym, expands to "not yet
implemented")

How would that be any better than getting "invalid option: -B"?

It is "NYI". Given the issues with binary representations that have
come up within the last 10 years so far, I doubt that we have a
reason to offer wanting to dump the packed ruleset right now.
