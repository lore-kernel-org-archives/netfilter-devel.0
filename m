From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 7/8] [PATCH] dynamic calculation of event message size
 for ctnetlink
Date: Mon, 17 Nov 2008 00:44:13 -0800 (PST)
Message-ID: <20081117.004413.90628236.davem@davemloft.net>
References: <20081117083924.11368.38741.stgit@Decadence>
	<20081117084141.11368.26975.stgit@Decadence>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45226
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752664AbYKQIoO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2008 03:44:14 -0500
In-Reply-To: <20081117084141.11368.26975.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 17 Nov 2008 09:41:42 +0100

> This patch adds dynamic message size calculation for ctnetlink. This
> reduces CPU consumption since the overhead in the message trimming
> is removed.
> 
> Based on a suggestion from Patrick McHardy.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Nice patch.
