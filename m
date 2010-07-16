From: Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: [PATCH] netfilter: xtables: inclusion of xt_condition
Date: Fri, 16 Jul 2010 15:16:01 +0300
Message-ID: <1279282561.1603.73.camel@powerslave>
References: <1279278635.1603.53.camel@powerslave>
	 <alpine.LSU.2.01.1007161320310.14608@obet.zrqbmnf.qr>
	 <1279279882.1603.56.camel@powerslave>
	 <alpine.LSU.2.01.1007161353060.18961@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "kaber@trash.net" <kaber@trash.net>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: ext Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:32428 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965245Ab0GPMQL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Jul 2010 08:16:11 -0400
In-Reply-To: <alpine.LSU.2.01.1007161353060.18961@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 2010-07-16 at 13:54 +0200, ext Jan Engelhardt wrote:
> On Friday 2010-07-16 13:31, Luciano Coelho wrote:
> >
> >> >As you may have seen in my earlier rfc email, I'm interested in
> >> >something similar to the condition match.  I'm not sure whether the best
> >> >approach is to create a CONDITION target where we can set the condition
> >> >variable in the iptables itself or if it is better to create a new
> >> >"variable match" and an accompanying "VARIABLE target" that keeps the
> >> >variables in memory, instead of using procfs.
> >> 
> >> procfs is in memory :)
> >
> >Yes, of course, but I meant without exporting it to procfs. ;) That
> >would probably make the code a lot simpler (actually I can't imagine a
> >simpler match/target than a "variable" match/target ;)
> 
> Well, if not procfs, what should influence this anonymous variable?
> The weather? (No really, that came up at last NFWS. Using a userspace 
> program, you can write into the procfs file and thus firewall based upon 
> storm and thunder....)

Heh! :)

What I need is a state variable that is set and read by netfilter
tables.  The idea is to have a state variable high_throughput that will
be set to true (high) or false (low) depending on the rateest results.
This would be used to prevent multiple NFLOG events for the same state
(say, "HIGH") from being sent to userspace.

This is similar to what propose with the condition match:

> With xt_condition that should not be a problem
> (-A INPUT -m condition --name ruleXYZ -j NFLOG..)
> This is settable through procfs.

But without depending on the userspace to change the condition value.  I
could have rules like this to change the condition:

-A INPUT -j throughput 

-A above -m condition --name hi_thru -j RETURN 
-A above -m rateest --rateest throughput --rateest-bps1 0bit --rateest-bps2 1000bit --rateest-gt -j NFLOG --nflog-prefix "HIGH" 
-A above -m rateest --rateest throughput --rateest-bps1 0bit --rateest-bps2 1000bit --rateest-gt -j CONDITION --name hi_thru --set 1 

-A below -m condition ! --name hi_thru -j RETURN 
-A below -m rateest --rateest throughput --rateest-bps1 0bit --rateest-bps2 1000bit --rateest-lt -j NFLOG --nflog-prefix "LOW" 
-A below -m rateest --rateest throughput --rateest-bps1 0bit --rateest-bps2 1000bit --rateest-lt -j CONDITION --name hi_thru --set 0

-A throughput -j RATEEST --rateest-name throughput --rateest-interval 250.0ms --rateest-ewmalog 500.0ms 
-A throughput -j above 
-A throughput -j below 


-- 
Cheers,
Luca.

