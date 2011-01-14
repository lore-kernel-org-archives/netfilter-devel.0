From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: audit target to record accepted/dropped
 packets
Date: Fri, 14 Jan 2011 16:31:05 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101141628480.15541@obet.zrqbmnf.qr>
References: <20110114152024.GA9654@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, linux-audit@redhat.com,
	Patrick McHardy <kaber@trash.net>,
	Eric Paris <eparis@parisplace.org>,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Thomas Graf <tgraf@infradead.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55006 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757685Ab1ANPbH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Jan 2011 10:31:07 -0500
In-Reply-To: <20110114152024.GA9654@canuck.infradead.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-01-14 16:20, Thomas Graf wrote:

>This patch adds a new netfilter target which creates audit records
>for packets traversing a certain chain.

Apart from that it uses the audit infrastructure, what would this 
target offer over LOG (and/or LOGMARK)?

>The following information is logged:
> - netfilter hook
> - packet length
> - incomming/outgoing interface
> - MAC src/dst/proto for ethernet packets
> - src/dst/protocol address for IPv4/IPv6
> - src/dst port for TCP/UDP/UDPLITE
> - icmp type/code
