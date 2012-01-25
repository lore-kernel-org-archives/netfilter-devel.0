From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: NAT question
Date: Wed, 25 Jan 2012 18:30:51 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1201251830150.2852@frira.zrqbmnf.qr>
References: <4F202AD6.9090802@earthlink.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Stephen Clark <sclark46@earthlink.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:49041 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756367Ab2AYRaz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Jan 2012 12:30:55 -0500
In-Reply-To: <4F202AD6.9090802@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2012-01-25 17:16, Stephen Clark wrote:

> Can iptables do a network to network nat without having to write out a bunch of
> nat rules.
> In other words translate  192.168.198.0/24 to 172.16.10.0/24 without having to
> write out
> 256 rules.

-> NETMAP.

> Also can iptables handle 1000 nat rules like above if they have to be written
> out on
> a 1.66ghz intel dual core atom with 1gb of mem.

"It can. Can you?"
