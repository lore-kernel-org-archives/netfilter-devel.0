From: Patrick McHardy <kaber@trash.net>
Subject: Re: arptables and the generic xtables issues
Date: Thu, 16 Oct 2008 13:55:37 +0200
Message-ID: <48F72BB9.40207@trash.net>
References: <48F69C2A.8010001@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64414 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbYJPLzl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2008 07:55:41 -0400
In-Reply-To: <48F69C2A.8010001@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Hi,
> 
> Currently, we have tagged quite a lot of targets and matches with
> AF_UNSPEC as they are generic for the netfilter supported protocols.
> This is fine if we only think of ebtables, iptables and ip6tables but
> not for arptables, I doubt that all those target and matches can work
> with arptables - even if we still need the userspace support, of course.
> 
> I think that we should fix those, right?

Looking through the list (targets only, arp_tables doesn't support
matches):

- CLASSIFY: OK
- comment: OK
- CONNMARK/CONNSECMARK: no effect
- MARK: OK
- NFLOG: OK
- NOTRACK: no effect
- RATEEST: should be OK
- SECMARK: OK
- TRACE: OK, but currently no effect

So I don't think there really is a problem.
