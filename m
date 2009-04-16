From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: First userspace, then module
Date: Thu, 16 Apr 2009 09:28:11 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904160927340.2510@fbirervta.pbzchgretzou.qr>
References: <49E6D7F8.6030507@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52044 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbZDPH2P (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Apr 2009 03:28:15 -0400
In-Reply-To: <49E6D7F8.6030507@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-04-16 09:02, Kristian Evensen wrote:
>
> I am playing around with an idea for a module that will manipulate the packets
> in userspace before passing them on to the xtables module. In other words,
> there will be two rules in iptables (in the samle table) and after userspace is
> done with the packet, it will be passed onto the next rule.

Not possible. But you can have it reenter at the start using
NF_REPEAT, I think.

> However, when creating a small prototype to see if this is possible, I did not
> find an equivalant to "XT_CONTINUE" that can be passed to nfq_set_verdict and I
> therefore did not get the prortype working.So my question is, is it possible to
> first send a packet to userspace, make a verdict and then have it processed by
> a rule in the same iptables-table?
