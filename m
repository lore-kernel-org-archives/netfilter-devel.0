From: David Miller <davem@davemloft.net>
Subject: Re: [patch net-next 1/2] ip6_output: fragment outgoing reassembled
 skb properly
Date: Mon, 11 Nov 2013 00:47:19 -0500 (EST)
Message-ID: <20131111.004719.2265882672434354794.davem@davemloft.net>
References: <20131108075201.GA2455@minipsycho.orion>
	<20131108.144915.635810300359291522.davem@davemloft.net>
	<20131109110053.GA2447@minipsycho.orion>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, pablo@netfilter.org,
	netfilter-devel@vger.kernel.org, yoshfuji@linux-ipv6.org,
	kadlec@blackhole.kfki.hu, kaber@trash.net, mleitner@redhat.com,
	kuznet@ms2.inr.ac.ru, jmorris@namei.org, wensong@linux-vs.org,
	horms@verge.net.au, ja@ssi.bg, edumazet@google.com,
	pshelar@nicira.com, jasowang@redhat.com,
	alexander.h.duyck@intel.com, fw@strlen.de
To: jiri@resnulli.us
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:52454 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab3KKFrW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Nov 2013 00:47:22 -0500
In-Reply-To: <20131109110053.GA2447@minipsycho.orion>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jiri Pirko <jiri@resnulli.us>
Date: Sat, 9 Nov 2013 12:00:53 +0100

> I hope I cleared this out. 

Thanks for the explanation, I see now.
