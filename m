From: Thomas Jacob <jacob@internet24.de>
Subject: Re: Plans for future iptables versions / jumpset feature
Date: Thu, 22 May 2008 22:27:16 +0200
Message-ID: <20080522202715.GA28875@internet24.de>
References: <1211482843.28066.40.camel@enterprise.ims-firmen.de> <4835C6F0.5080604@trash.net> <alpine.LNX.1.10.0805222140160.9332@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout02.ims-firmen.de ([213.174.32.97]:60155 "EHLO
	mailout02.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbYEVU1R (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 16:27:17 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0805222140160.9332@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> There have been a few changes regarding insertion speed. Even if one
> has 500 rules (see that URL), they can probably be optimized using
> IPMARK or chaintrees. 

I was thinking more along the lines of >100k rules. Iptables
can easily handles those numbers at the moment, it's just a bit
awkward to deal with.

By chaintrees I presume you mean trees of iptables chains and not
some sort of tool named this way?

> Also, one should use iptables-restore for
> updates, at least when changing more than one rule in a go. Lots of
> people fail to actually use it.

To be sure, but I am also interested in improving the time required
to find to correct chain given 1000s or 10000s of ip to chain mappings
and of course the usability of a construct like that.

