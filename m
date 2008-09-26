From: Philip Craig <philipc@snapgear.com>
Subject: Re: been a while...what happened to NFC_ALTERED?
Date: Fri, 26 Sep 2008 14:16:51 +1000
Message-ID: <48DC6233.1020309@snapgear.com>
References: <F6673A17-B622-4F71-AD50-E7E020B3A1C9@pactolus.com> <alpine.LNX.1.10.0809251923040.18190@fbirervta.pbzchgretzou.qr> <E8E029BA163C694484CFEA4914619EA206853DA2@pcsexch-bknet> <alpine.LNX.1.10.0809252108230.17117@fbirervta.pbzchgretzou.qr> <E8E029BA163C694484CFEA4914619EA206853DA5@pcsexch-bknet> <48DC3BAC.2090609@snapgear.com> <E8E029BA163C694484CFEA4914619EA206853DAA@pcsexch-bknet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: "Horton, Dave" <dhorton@pactolus.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.securecomputing.com ([203.24.151.4]:58301 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750804AbYIZEQz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Sep 2008 00:16:55 -0400
In-Reply-To: <E8E029BA163C694484CFEA4914619EA206853DAA@pcsexch-bknet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Horton, Dave wrote:
> Well, maybe I could use that, or more likely base my kernel module off
> that code.  The reason that I probably can't use the DNAT target as is,
> is because I also have to inspect the packets, and for some (very small)
> number of them, send the packet up to userspace for further processing.
> Also, my userspace process needs to frequently (hundreds of times per
> second) change the forwarding rules, so for performance reasons I want
> to specify those changes via commands over a netlink socket rather than
> adding and removing iptables rules.
> 
> Does that make sense?  Should I be looking at creating a target similar
> to DNAT, and using that code as reference?

Try to use the existing DNAT target if possible.  You can make the DNAT
conditional by putting all your logic in a custom match.  But also
consider using the ipset patch rather than a custom match.  You may
be able to structure the rules so you only need to update the ipset when
your forwarding rules change.  ipset is currently sockopt only, but
netlink version is in progress.

Also do your forwarding rules change per packet or per connection?
Note that iptables nat is based on connection tracking.  If you want per
packet nat decisions (stateless nat) then use iproute2.

