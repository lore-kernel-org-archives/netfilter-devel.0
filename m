From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: kernel header divergence
Date: Sat, 21 Feb 2009 04:47:29 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902210445050.32599@fbirervta.pbzchgretzou.qr>
References: <20090220163038.5235871d@extreme> <alpine.LSU.2.00.0902210226440.25933@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@vyatta.com>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55438 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbZBUDra (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 22:47:30 -0500
In-Reply-To: <alpine.LSU.2.00.0902210226440.25933@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2009-02-21 02:27, Jan Engelhardt wrote:
>On Saturday 2009-02-21 01:30, Stephen Hemminger wrote:
>
>>The headers in iptables command source (include/linux) are different than
>>the headers produced by the kernel header sanitation process:
>>  make headers_install
>>
>>Has someone looked into rectifying this? 
>
>They were last resynced before the workshop IIRC, and in fact, the 
>headers are allowed to diverge a bit. Is it a large change that gets 
>introduced by resyncing to 2.6.29?

So, I resynced it. The branch is at
	git://dev.medozas.de/iptables header-resync

One thing I noticed was that nf_nat.h lives in
${kernel}/include/net/netfilter/, from which generally no files are
exported (e.g. headers_install) at all. Oh well. So I manually copied
nf_nat.h and hand-edited out the definitely-unneeded parts.
Same goes for include/net/netfilter/nf_conntrack_tuple.h.

As it stands, a number of IPv4 NAT userspace extensions had to be
adjusted here and there a bit because - heh - the iptables headers
still were so old they carried "ip_nat_range" instead of "nf_nat_range".

Closing for today, it's "testers || pull()"; thanks :)
