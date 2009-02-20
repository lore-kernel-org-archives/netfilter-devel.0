From: Rick Jones <rick.jones2@hp.com>
Subject: Re: [PATCH] iptables: lock free counters
Date: Thu, 19 Feb 2009 17:18:01 -0800
Message-ID: <499E04C9.4020308@hp.com>
References: <20090218051906.174295181@vyatta.com>	<20090218052747.321329022@vyatta.com>	<20090219114719.560999b5@extreme> <499DEF49.3040602@cosmosbay.com>	<499DF1A2.1030405@hp.com> <20090219170318.3f7d54f2@extreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <dada1@cosmosbay.com>,
	David Miller <davem@davemloft.net>,
	Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:11649 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803AbZBTBSG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Feb 2009 20:18:06 -0500
In-Reply-To: <20090219170318.3f7d54f2@extreme>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>>>Thanks Stephen, thats very cool stuff, yet another rwlock out of kernel :)
>>
>>Do you folks need/want further testing against the 32-core setup?
> 
> 
> It would be good to combine all 3 (iptables-rcu, timer change, and conntrack lock)
> to see what the overhead change is.

Fair enough. Is there a tree somewhere I can pull with all those in it, or do I 
need to go back through the emails and apply patches?

rick jones
