From: Patrick McHardy <kaber@trash.net>
Subject: Re: [LIBNL 08/09]: Support conntrack add/delete/query requests
Date: Mon, 21 Jan 2008 10:46:13 +0100
Message-ID: <479469E5.3080205@trash.net>
References: <20080118165514.13385.44695.sendpatchset@localhost.localdomain> <20080118165525.13385.47304.sendpatchset@localhost.localdomain> <47945A5E.2070201@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tgraf@suug.ch, netfilter-devel@vger.kernel.org
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47796 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758177AbYAUJqY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 04:46:24 -0500
In-Reply-To: <47945A5E.2070201@snapgear.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Philip Craig wrote:
> Patrick McHardy wrote:
>> commit 5d2b826674d411f99e571fd35ad5722fed077e5e
>> Author: Patrick McHardy <kaber@trash.net>
>> Date:   Fri Jan 18 17:53:14 2008 +0100
>>
>>     [LIBNL]: Support conntrack add/delete/query requests
>>     
>>     Signed-off-by: Patrick McHardy <kaber@trash.net>
>>
>> diff --git a/include/netlink/netfilter/ct.h b/include/netlink/netfilter/ct.h
>> index 965b869..f554017 100644
>> --- a/include/netlink/netfilter/ct.h
>> +++ b/include/netlink/netfilter/ct.h
>> @@ -39,6 +39,15 @@ extern void		nfnl_ct_put(struct nfnl_ct *);
>>  
>>  extern int		nfnl_ct_dump_request(struct nl_handle *);
> 
> This was just a quick and dirty dump request.  nfnl_ct_query covers this now,
> so we can delete it.

nfnl_ct_query doesn't perform a full dump, so this still looks useful.
