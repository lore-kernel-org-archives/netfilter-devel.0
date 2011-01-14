From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCHv2] netfilter: audit target to record accepted/dropped
 packets
Date: Fri, 14 Jan 2011 20:18:43 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101142017410.30008@obet.zrqbmnf.qr>
References: <20110114152024.GA9654@canuck.infradead.org> <4D306FBB.8020705@trash.net> <20110114161937.GA22101@canuck.infradead.org> <20110114165937.GA5759@canuck.infradead.org> <4D309B4D.2010701@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	linux-audit@redhat.com, Eric Paris <eparis@parisplace.org>,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50304 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab1ANTSq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Jan 2011 14:18:46 -0500
In-Reply-To: <4D309B4D.2010701@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-01-14 19:51, Mr Dash Four wrote:
>
> Thomas Graf wrote:
>> This patch adds a new netfilter target which creates audit records
>> for packets traversing a certain chain.
>>  
> Just a question/suggestion from a (regular) user point of view: Would it be
> possible to store the entire packet content or would that prove a bit too much?
> If that's possible I am dumping tcpdump (pun intended ;-) ) for good!

Is nflog/nfqueue (the two also seem to be doing almost the same)
not good enough? (The reason for audit's existence still eludes me..)
