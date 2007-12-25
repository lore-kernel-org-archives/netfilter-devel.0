From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER]: nf_conntrack_ipv4: fix module parameter
 compatibility
Date: Mon, 24 Dec 2007 21:09:33 -0800 (PST)
Message-ID: <20071224.210933.205138787.davem@davemloft.net>
References: <476CCE0E.2000800@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38121
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750752AbXLYFJd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Dec 2007 00:09:33 -0500
In-Reply-To: <476CCE0E.2000800@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Sat, 22 Dec 2007 09:42:54 +0100

> [NETFILTER]: nf_conntrack_ipv4: fix module parameter compatibility
> 
> Some users do "modprobe ip_conntrack hashsize=...". Since we have the
> module aliases this loads nf_conntrack_ipv4 and nf_conntrack, the
> hashsize parameter is unknown for nf_conntrack_ipv4 however and makes
> it fail.
> 
> Allow to specify hashsize= for both nf_conntrack and nf_conntrack_ipv4.
> 
> Note: the nf_conntrack message in the ringbuffer will display an
> incorrect hashsize since nf_conntrack is first pulled in as a
> dependency and calculates the size itself, then it gets changed
> through a call to nf_conntrack_set_hashsize().
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied to net-2.6, thanks Patrick.
