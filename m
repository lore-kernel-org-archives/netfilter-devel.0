From: Thomas Graf <tgraf@infradead.org>
Subject: Re: [PATCH] netfilter: audit target to record accepted/dropped
 packets
Date: Fri, 14 Jan 2011 10:37:18 -0500
Message-ID: <20110114153718.GB9654@canuck.infradead.org>
References: <20110114152024.GA9654@canuck.infradead.org>
 <alpine.LNX.2.01.1101141628480.15541@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, linux-audit@redhat.com,
	Patrick McHardy <kaber@trash.net>,
	Eric Paris <eparis@parisplace.org>,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from canuck.infradead.org ([134.117.69.58]:52588 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757712Ab1ANPhT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Jan 2011 10:37:19 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1101141628480.15541@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 14, 2011 at 04:31:05PM +0100, Jan Engelhardt wrote:
> On Friday 2011-01-14 16:20, Thomas Graf wrote:
> 
> >This patch adds a new netfilter target which creates audit records
> >for packets traversing a certain chain.
> 
> Apart from that it uses the audit infrastructure, what would this 
> target offer over LOG (and/or LOGMARK)?

That is the main point of this target. The audit infrastructure
is a trusted infrastructure. Records are properly stored and can
be processed by the audit tools ausearch and aureport.
