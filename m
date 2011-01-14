From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: audit target to record accepted/dropped
 packets
Date: Fri, 14 Jan 2011 17:49:59 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101141748460.16708@obet.zrqbmnf.qr>
References: <20110114152024.GA9654@canuck.infradead.org> <4D306FBB.8020705@trash.net> <20110114161937.GA22101@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	linux-audit@redhat.com, Eric Paris <eparis@parisplace.org>,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Thomas Graf <tgraf@infradead.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51940 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757754Ab1ANQuA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Jan 2011 11:50:00 -0500
In-Reply-To: <20110114161937.GA22101@canuck.infradead.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-01-14 17:19, Thomas Graf wrote:

>On Fri, Jan 14, 2011 at 04:46:03PM +0100, Patrick McHardy wrote:
>> This won't work in the AF_INET/LOCAL_OUT hook, skb->dev is set just
>> before the packet is handed to the POST_ROUTING hook. The ethernet
>> header is also only present on incoming packets.
>
>Aha, that is the reason for in && !out in ipt_LOG then.

Actually, it reads if (in != NULL), because the MAC header of an 
incoming packet is retained in FORWARD before it is later replaced 
by the new neigh type.
