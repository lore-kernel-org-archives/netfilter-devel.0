From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: xtables: inclusion of xt_condition
Date: Fri, 16 Jul 2010 21:14:40 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1007162114070.22666@obet.zrqbmnf.qr>
References: <1279278635.1603.53.camel@powerslave>  <alpine.LSU.2.01.1007161320310.14608@obet.zrqbmnf.qr>  <1279279882.1603.56.camel@powerslave>  <alpine.LSU.2.01.1007161353060.18961@obet.zrqbmnf.qr> <1279282561.1603.73.camel@powerslave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "kaber@trash.net" <kaber@trash.net>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Luciano Coelho <luciano.coelho@nokia.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45795 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758946Ab0GPTOp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Jul 2010 15:14:45 -0400
In-Reply-To: <1279282561.1603.73.camel@powerslave>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2010-07-16 14:16, Luciano Coelho wrote:
>> >
>> >Yes, of course, but I meant without exporting it to procfs. ;) That
>> >would probably make the code a lot simpler (actually I can't imagine a
>> >simpler match/target than a "variable" match/target ;)
>> 
>> Well, if not procfs, what should influence this anonymous variable?
>> The weather? (No really, that came up at last NFWS. Using a userspace 
>> program, you can write into the procfs file and thus firewall based upon 
>> storm and thunder....)
>
>Heh! :)
>
>What I need is a state variable that is set and read by netfilter
>tables.  The idea is to have a state variable high_throughput that will
>be set to true (high) or false (low) depending on the rateest results.
>This would be used to prevent multiple NFLOG events for the same state
>(say, "HIGH") from being sent to userspace.

We have exactlt that -- the nfmark, accessible via -j MARK.
