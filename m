From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/7] get rid of module refcounting in ctnetlink
Date: Wed, 30 Jul 2008 15:24:24 +0200
Message-ID: <48906B88.20208@trash.net>
References: <48904A6D.3010404@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Fabian Hugelshofer <hugelshofer2006@gmx.ch>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48098 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbYG3NY0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2008 09:24:26 -0400
In-Reply-To: <48904A6D.3010404@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> [PATCH] get rid of module refcounting in ctnetlink
> 
> This patch replaces the unnecessary module refcounting with
> the read-side locks. With this patch, all the dump and fill_info
> function are called under the RCU read lock.
> 
> Based on a patch from Fabian Hugelshofer.

Looks good. Queued for 2.6.28, thanks.
