From: Rick Jones <rick.jones2@hp.com>
Subject: Re: [PATCH 0/6] iptables: read/write lock elimination (v0.4)
Date: Thu, 29 Jan 2009 15:39:13 -0800
Message-ID: <49823E21.1050608@hp.com>
References: <20090129191239.483204605@vyatta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>,
	Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:31453 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbZA2XjW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Jan 2009 18:39:22 -0500
In-Reply-To: <20090129191239.483204605@vyatta.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Stephen Hemminger wrote:
> This is an update to last round of patches, using Eric's suggestion
> to move the sequence count to top level per cpu variable. Also encapsulated
> the counter manipulation.

Is this version one you would like me to toss into the crucible of the 32-core 
setup, or do you want it to have more eyeball time first?

rick jones
