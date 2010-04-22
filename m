From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] nefilter: use pr_devel instead of pr_debug
Date: Thu, 22 Apr 2010 13:04:53 +0200
Message-ID: <4BD02D55.8070903@trash.net>
References: <4BD02914.9030100@trash.net>	<alpine.LSU.2.01.1004221248010.31972@obet.zrqbmnf.qr>	<4BD02C48.6060904@trash.net> <20100422.040113.179187181.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: jengelh@medozas.de, netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63220 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab0DVLEy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Apr 2010 07:04:54 -0400
In-Reply-To: <20100422.040113.179187181.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David Miller wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Thu, 22 Apr 2010 13:00:24 +0200
> 
>> I've noticed you already included a few pr_devel() statements in a
>> recent submission. I'd rather convert those to pr_debug()
> 
> Agreed, don't start going down this silly pr_devel() road.

I've converted them to pr_debug().
