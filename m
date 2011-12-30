From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: libnetfilter_acct now available at git.netfilter.org
Date: Fri, 30 Dec 2011 02:09:11 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1112300205270.18357@frira.zrqbmnf.qr>
References: <20111229184741.GA6405@1984> <alpine.LNX.2.01.1112292221210.29747@frira.zrqbmnf.qr> <20111230000546.GC7866@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:45363 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab1L3BJN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Dec 2011 20:09:13 -0500
In-Reply-To: <20111230000546.GC7866@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2011-12-30 01:05, Pablo Neira Ayuso wrote:
>>>I'm thinking about including this tool into the iptables tree, instead
>>>of distributing it separately, but I may change my mind. Let me know
>>>if you have any preference.
>> 
>>It would pose - just formally - the question how many more tools we 
>>intend to ship with iptables. For example, try to find an answer as to 
>>why conntrack-tools and ipset are separate instead of being included in 
>>iptables.
>
>Good question.
>
>From what I see (because the policy is not clear to me either), I can
>extract that it's a matter of how big (in terms of LOC) the project is
>and how many changes you expect from that code.

Well, do you expect nfacct to grow to proportions similar to ipset or
conntrack-tools?

As for nfnl_osf, it certainly has not reached that threshold (and
is unlikely to do so in the near future), and therefore I move to keep it.

>For nfnl_osf, we can move it to one standalone tool.
>Probably it's better to avoid polluting iptables tree with other
>projects and provide standalone trees for everyone.
