From: Thomas Graf <tgraf@infradead.org>
Subject: Re: [PATCH] netfilter: audit target to record accepted/dropped
 packets
Date: Fri, 14 Jan 2011 11:19:37 -0500
Message-ID: <20110114161937.GA22101@canuck.infradead.org>
References: <20110114152024.GA9654@canuck.infradead.org>
 <4D306FBB.8020705@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, linux-audit@redhat.com,
	Eric Paris <eparis@parisplace.org>,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from canuck.infradead.org ([134.117.69.58]:38810 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189Ab1ANQTi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Jan 2011 11:19:38 -0500
Content-Disposition: inline
In-Reply-To: <4D306FBB.8020705@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 14, 2011 at 04:46:03PM +0100, Patrick McHardy wrote:
> This won't work in the AF_INET/LOCAL_OUT hook, skb->dev is set just
> before the packet is handed to the POST_ROUTING hook. The ethernet
> header is also only present on incoming packets.

Aha, that is the reason for in && !out in ipt_LOG then.

I will fix this.
