From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] libxtables: Dont initialize global xt_params
Date: Thu, 12 Feb 2009 16:14:23 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902121612200.5658@fbirervta.pbzchgretzou.qr>
References: <1234448162.3271.1.camel@dogo.mojatatu.com> <200902121609.43664.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: hadi@cyberus.ca, Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36442 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312AbZBLPOY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 10:14:24 -0500
In-Reply-To: <200902121609.43664.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-02-12 16:09, Thomas Jarosch wrote:
>> -struct xtables_globals *xt_params = NULL;
>> +struct xtables_globals *xt_params;
>
>Thanks for your patch. Did you know about zeroing of .bss before?
>
>I see two possible drawbacks using this style:
>
>1. Other people which don't know this "trick" will think
>the variable is not initialized -> Hard to read.

Well, maybe then they should get a better C book --
automatic initialization is said to be(*) part of the C standard.
And one should know the standard of a language IMHO.

(*) Because it is not free, it remains a saga from people who do
have access to it. :p

>2. If that variable gets moved f.e. inside a function, it will become 
>uninitialized. Also I'm not sure if the savings are even measurable...

It seems to be for the Linux kernel. Especially when you happen
to have large globals (both a lot of them, and large; e.g.
foo[NR_CUPS]) this becomes a concern.


Just my 2 ints. (Oh wait, move them to bss!)

>
>Just my two cents
>Thomas
>

