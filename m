From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: "xt_conntrack: warn about use in raw table" and lo packets
Date: Wed, 27 Apr 2011 16:13:55 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1104271612130.31018@obet.zrqbmnf.qr>
References: <20110421125139.GA11260@Chamillionaire.breakpoint.cc> <alpine.LNX.2.01.1104261105400.19642@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "David S. Miller" <davem@davemloft.net>,
	Florian Westphal <fw@strlen.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46109 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932504Ab1D0ON6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Apr 2011 10:13:58 -0400
In-Reply-To: <alpine.LNX.2.01.1104261105400.19642@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2011-04-26 11:06, Jan Engelhardt wrote:
>On Thursday 2011-04-21 14:51, Florian Westphal wrote:
>
>>The commit a2361c8735e07322023aedc36e4938b35af31eb0
>>("netfilter: xt_conntrack: warn about use in raw table")
>>disallows use of -m conntrack in the raw table:
>>"nfct happens to run after the raw table only".
>>
>>Thats correct, but when the packet was sent from the local machine the
>>skb already has ->nfct attached, and -m conntrack seems to do
>>the right thing.
>
>Hm, I did not consider that. In this case, the patch should be backed 
>out.

Patrick/Dave - please issue a revert on 
a2361c8735e07322023aedc36e4938b35af31eb0 .
