From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrack-utils needs to autoload netlink
Date: Sun, 19 Apr 2009 13:45:14 +0200
Message-ID: <49EB0ECA.1000405@netfilter.org>
References: <alpine.LSU.2.00.0904191307310.31907@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51399 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756889AbZDSLpZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 Apr 2009 07:45:25 -0400
In-Reply-To: <alpine.LSU.2.00.0904191307310.31907@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Hi,
> 
> I observed that running `conntrack -E` does not autoload 
> nf_conntrack_netlink.ko, and as such, does not receive any events. 
> `conntrack -L` on the other hand does autoload it, and subsequent -E 
> works.

Yes, that's a known issue. The problem is the following: with `conntrack
-L', netlink loads nfnetlink when the socket is created, then nfnetlink
receives a message requesting a dump, thus, nfnetlink loads
nf_conntrack_netlink. However, with `conntrack -E', netlink loads
nfnetlink, but nfnetlink does not receive any message from conntrack
since listening to events doesn't require such operation. thus,
nf_conntrack_netlink is not loaded.

I wrote a patch time ago to load nf_conntrack_netlink from user-space
when `conntrack -E' is invoked. I don't see a way to fix this in the
kernel code, so that's the only idea that I can find to fix this
problem. Still, I don't like too much the idea of doing the autoload
from user-space.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
