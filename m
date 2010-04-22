From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/2] nefilter: use pr_devel instead of pr_debug
Date: Thu, 22 Apr 2010 03:55:11 -0700 (PDT)
Message-ID: <20100422.035511.207886963.davem@davemloft.net>
References: <1271856071-32179-1-git-send-email-jengelh@medozas.de>
	<1271856071-32179-2-git-send-email-jengelh@medozas.de>
	<4BD02914.9030100@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: jengelh@medozas.de, netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58795
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753916Ab0DVKzG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Apr 2010 06:55:06 -0400
In-Reply-To: <4BD02914.9030100@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 22 Apr 2010 12:46:44 +0200

> Jan Engelhardt wrote:
>> Netfilter traditionally used debug prints that were omitted unless
>> someone explicitly defined DEBUG. Recently that has no longer been the
>> case (see explanation in commit v2.6.30-rc2-184-g4ccb457). Switch our
>> pr_debug calls to pr_devel.
> 
> The intention of CONFIG_DYNAMIC_DEBUG is exactly to make those debug
> statements available dynamically. I presume the mentioned distribution
> had a reason to enable that option. Why should we undermine that by
> turning debug statements into "devel" statements?

Right, there is no reason to do this.
