From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: xtables: inclusion of xt_condition
Date: Fri, 16 Jul 2010 13:54:23 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1007161353060.18961@obet.zrqbmnf.qr>
References: <1279278635.1603.53.camel@powerslave>  <alpine.LSU.2.01.1007161320310.14608@obet.zrqbmnf.qr> <1279279882.1603.56.camel@powerslave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "kaber@trash.net" <kaber@trash.net>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Luciano Coelho <luciano.coelho@nokia.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36219 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965187Ab0GPLyY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Jul 2010 07:54:24 -0400
In-Reply-To: <1279279882.1603.56.camel@powerslave>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2010-07-16 13:31, Luciano Coelho wrote:
>
>> >As you may have seen in my earlier rfc email, I'm interested in
>> >something similar to the condition match.  I'm not sure whether the best
>> >approach is to create a CONDITION target where we can set the condition
>> >variable in the iptables itself or if it is better to create a new
>> >"variable match" and an accompanying "VARIABLE target" that keeps the
>> >variables in memory, instead of using procfs.
>> 
>> procfs is in memory :)
>
>Yes, of course, but I meant without exporting it to procfs. ;) That
>would probably make the code a lot simpler (actually I can't imagine a
>simpler match/target than a "variable" match/target ;)

Well, if not procfs, what should influence this anonymous variable?
The weather? (No really, that came up at last NFWS. Using a userspace 
program, you can write into the procfs file and thus firewall based upon 
storm and thunder....)
