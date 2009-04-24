From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_conntrack_proto_udplite
Date: Fri, 24 Apr 2009 15:02:46 +0200
Message-ID: <49F1B876.1000207@trash.net>
References: <200904222106.29497.steven@springl.ukfsn.org> <49F04334.9000905@trash.net> <200904231525.54924.steven@springl.ukfsn.org> <49F0EA9A.3070108@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Steven Jan Springl <steven@springl.ukfsn.org>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44420 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbZDXNCy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Apr 2009 09:02:54 -0400
In-Reply-To: <49F0EA9A.3070108@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Hi Patrick,
> 
> Steven Jan Springl wrote:
>> On Thursday 23 April 2009 11:30:12 Patrick McHardy wrote:
>>> Thanks for the report, it seems the IPv6 udplite protocol was
>>> forgotten during a recent API change.
>>>
>>> Does this patch help?
> 
> We also need it for DCCP. I'm going to send another patch for it.

I already noticed and fixed it as well, thanks.
