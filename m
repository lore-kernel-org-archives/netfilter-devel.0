From: Oliver <olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: Allow DNPT target from raw table?
Date: Mon, 06 May 2013 23:13:36 +0200
Message-ID: <65149599.bjN9hFl4GV@gentoovm>
References: <2531686.RPhsabGAWo@gentoovm> <20130506202101.GB6025@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:39340 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757926Ab3EFVSc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 May 2013 17:18:32 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id 2B3C8A395A
	for <netfilter-devel@vger.kernel.org>; Mon,  6 May 2013 22:18:31 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id BzC7z8EiDdCR for <netfilter-devel@vger.kernel.org>;
	Mon,  6 May 2013 22:17:49 +0100 (BST)
In-Reply-To: <20130506202101.GB6025@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 06 May 2013 22:21:01 you wrote:
> On Mon, May 06, 2013 at 04:38:19AM +0200, Oliver wrote:
> > Hi all,
> > 
> > Currently, the DNPT target is restricted to the mangle table; this means
> > that it is effectively impossible to utilise NPT in tandem with conntrack
> > since it's impossible to rewrite the destination prefix prior to
> > conntrack taking a look at the skb.
> > 
> > Please consider allowing the use of DNPT from the raw table so that it's
> > possible to do prefix translation without having to forego the benefits of
> > conntrack.
> 
> The raw table doesn't have a POSTROUTING chain, which is where SNPT is
> performed on order to catch both local and forwarded traffic.
> 
> If you're using conntrack anyways, why use NPT? The main benefit is that
> you don't have to use conntrack.

Right, I wanted to use NPT to avoid having to use conntrack for the 
translation.

imagine the following:

local internal subnet is 2001:db8:1::/64
local subnet is 2001:db8:aaaa::/64
remote is 2001:db8:ffff::/64

if my local hosts initiate a TCP connection to fc00::1 , they first send a 
packet with 2001:db8:1::x as source.

This then passes through the raw table and causes a conntrack entry to be 
created - then at mangle/POSTROUTING, SNPT will translate to 
2001:db8:aaaa::/64

At this point conntrack has an entry setup for 2001:db8:1::x rather than 
2001:db8:aaaa::x

when the reply returns, it will have a destination of 2001:db8:aaaa::x which 
will be considered to have a ctstate of INVALID since it has not been mangled.

If I wished to avoid this scenario, I would need to use DNPT within 
raw/PREROUTING in order to restore the original destination IP prior to the 
conntrack lookup - thus giving me the benefits of both stateless prefix 
translation and stateful TCP connection tracking.
