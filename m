From: Patrick McHardy <kaber@trash.net>
Subject: Re: [LIBNL 07/09]: Split up nfnetlink_log into log and msg objects
Date: Mon, 21 Jan 2008 10:45:14 +0100
Message-ID: <479469AA.2070302@trash.net>
References: <20080118165514.13385.44695.sendpatchset@localhost.localdomain> <20080118165524.13385.49205.sendpatchset@localhost.localdomain> <47945254.5000008@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tgraf@suug.ch, netfilter-devel@vger.kernel.org
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47788 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758242AbYAUJp1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 04:45:27 -0500
In-Reply-To: <47945254.5000008@snapgear.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Philip Craig wrote:
> Patrick McHardy wrote:
>> commit c566db4405200994482d36fac45089aba4e2360a
>> Author: Patrick McHardy <kaber@trash.net>
>> Date:   Fri Jan 18 17:52:41 2008 +0100
>>
>>     [LIBNL]: Split up nfnetlink_log into log and msg objects
>>     
>>     Split the nfnetlink_log code into two seperate objects, "netfilter/log"
>>     to represent logging instances and "netfilter/log_msg" to represent
>>     log messages. Also perform some function name unification for consistency
>>     with other libnl object types, mainly renaming nfnl_log_build_*_msg
>>     to nfnl_log_build_*_request.
>>     
>>     This changes the API in an incompatible way, but since this feature is
>>     new and the libnl netfilter headers haven't been installed so far,
>>     there shouldn't be any users affected by this.
>>     
>>     Signed-off-by: Patrick McHardy <kaber@trash.net>
> 
> Definitely an improvement, thanks. The pf bind/unbind are still handled
> differently, but I guess they are too simple to warrant it and will
> never get more attributes.

Yes, I kept those seperated from the log object because we can
subscribe to multiple families and this really didn't fit the
object model very well. I still hope to get rid of these within
the kernel some day.

> I hadn't noticed the missing headers because my cross compile
> environment has its own custom install target.

I was happy to discover it since this means we can change the
API without annoying users :)
