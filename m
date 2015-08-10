From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] extensions: restore matching any SPI id by default
Date: Mon, 10 Aug 2015 14:04:07 +0200
Message-ID: <20150810120407.GA3291@salvia>
References: <1436964819-28109-1-git-send-email-jengelh@inai.de>
 <1436964819-28109-3-git-send-email-jengelh@inai.de>
 <20150715162442.GA22476@salvia>
 <alpine.LSU.2.20.1507151837110.15534@nerf40.vanv.qr>
 <20150715165515.GA4177@salvia>
 <alpine.LSU.2.20.1507151907560.1320@nerf40.vanv.qr>
 <20150715173035.GA5675@salvia>
 <alpine.LSU.2.20.1507151937160.528@nerf40.vanv.qr>
 <20150807110754.GA13279@salvia>
 <alpine.LSU.2.20.1508071321280.18255@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57353 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081AbbHJL6B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2015 07:58:01 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1508071321280.18255@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 07, 2015 at 01:38:01PM +0200, Jan Engelhardt wrote:
[...]
> When specifying e.g. "-m policy --dir in", the xt_policy kernel
> module will indeedx test for much more than just the direction, but
> the additional tests it does on other fields are idempotent after
> all.
> 
> I oppose that idempotent expressions in rules, implicit or explicit,
> shall lead to output when the ruleset is read back. A rule like
> 
> 	-A INPUT -m policy --dir in
> 
> should not, by default, cause `iptables -S` to output a
> rule with terms essentially irrelevant to the human reader.
> 
> 	-A INPUT -m policy --dir in --reqid 0:4294967295 --spi
> 	0:4294967295 proto 0 --mode 0 --tunnel-src 0.0.0.0/0
> 	--tunnel-dst 0.0.0.0/0

We're not discussing a policy.

The point is that this has been broken for two years, chances that
users have fixed this in the ruleset without reporting is high, so
restoring the old behaviour may break things again for them.

That's why I'm insisting on the fact that switching to a less obscure
behaviour is a good idea in the very specific case of 'ah' since they
can easily detect that things have change by diffing the new and old
iptables-save output.

If you don't want to send me that follow up patch, that's very bad,
but if I have no other chance I'll make it myself.
