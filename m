From: Jiri Pirko <jiri@resnulli.us>
Subject: Re: [README] bug fixes only...
Date: Fri, 24 Jan 2014 10:26:12 +0100
Message-ID: <20140124092612.GB3153@minipsycho.orion>
References: <20140123.162408.681541949851852312.davem@davemloft.net>
 <20140124083927.GA3153@minipsycho.orion>
 <20140124.011800.1437880947731667846.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:53811 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaAXJ0Q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Jan 2014 04:26:16 -0500
Received: by mail-ea0-f182.google.com with SMTP id r15so851870ead.41
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Jan 2014 01:26:15 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20140124.011800.1437880947731667846.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fri, Jan 24, 2014 at 10:18:00AM CET, davem@davemloft.net wrote:
>From: Jiri Pirko <jiri@resnulli.us>
>Date: Fri, 24 Jan 2014 09:39:27 +0100
>
>> Fri, Jan 24, 2014 at 01:24:08AM CET, davem@davemloft.net wrote:
>>>
>>>I want to see zero feature and/or cleanup patches submitted at this
>>>time.
>>>
>>>net-next is now frozen and I'm going to let it sit for a day before
>>>I try to merge it to Linus.
>>>
>>>Thanks for your understanding.
>> 
>> Hi Dave.
>> 
>> Please do not forget about the patch named "rtnetlink: remove
>> IFLA_BOND_SLAVE definition" which is currently in patchwork.
>> It would not be good if the definition got from net-next into linus's tree.
>
>I applied it before you wrote this. :-)

Yep, your "applied" message appeared once I sent this :)
