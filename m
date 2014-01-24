From: David Miller <davem@davemloft.net>
Subject: Re: [README] bug fixes only...
Date: Fri, 24 Jan 2014 01:18:00 -0800 (PST)
Message-ID: <20140124.011800.1437880947731667846.davem@davemloft.net>
References: <20140123.162408.681541949851852312.davem@davemloft.net>
	<20140124083927.GA3153@minipsycho.orion>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: jiri@resnulli.us
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:36290 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaAXJSD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Jan 2014 04:18:03 -0500
In-Reply-To: <20140124083927.GA3153@minipsycho.orion>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jiri Pirko <jiri@resnulli.us>
Date: Fri, 24 Jan 2014 09:39:27 +0100

> Fri, Jan 24, 2014 at 01:24:08AM CET, davem@davemloft.net wrote:
>>
>>I want to see zero feature and/or cleanup patches submitted at this
>>time.
>>
>>net-next is now frozen and I'm going to let it sit for a day before
>>I try to merge it to Linus.
>>
>>Thanks for your understanding.
> 
> Hi Dave.
> 
> Please do not forget about the patch named "rtnetlink: remove
> IFLA_BOND_SLAVE definition" which is currently in patchwork.
> It would not be good if the definition got from net-next into linus's tree.

I applied it before you wrote this. :-)
