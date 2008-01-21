From: Patrick McHardy <kaber@trash.net>
Subject: Re: [LIBNL 08/09]: Support conntrack add/delete/query requests
Date: Mon, 21 Jan 2008 11:55:42 +0100
Message-ID: <47947A2E.9060506@trash.net>
References: <20080118165514.13385.44695.sendpatchset@localhost.localdomain> <20080118165525.13385.47304.sendpatchset@localhost.localdomain> <47945A5E.2070201@snapgear.com> <479469E5.3080205@trash.net> <47947997.7030301@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tgraf@suug.ch, netfilter-devel@vger.kernel.org
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49179 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758153AbYAUKzy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:55:54 -0500
In-Reply-To: <47947997.7030301@snapgear.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Philip Craig wrote:
> Patrick McHardy wrote:
>> nfnl_ct_query doesn't perform a full dump, so this still looks useful.
> 
> Will this do a full dump?
> nfnl_ct_query(handle, nfnl_ct_alloc(), NLM_F_DUMP);

Yes, but the query function expects a conntrack object with tuples
etc. to build the message, so its unnecessary complicated to use
it for a full dump.

> I'm okay with leaving it in there, I just didn't want to keep functions
> that none of the other objects in libnl have if they aren't really needed.

In this case I think its preferrable to keep it around.
