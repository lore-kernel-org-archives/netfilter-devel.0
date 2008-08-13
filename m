From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] [PATCH] fix sleep in read-side lock section
Date: Wed, 13 Aug 2008 15:28:25 +0200
Message-ID: <48A2E179.4050608@trash.net>
References: <20080807100803.8036.8684.stgit@Decadence> <20080807100825.8036.88782.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42422 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbYHMN21 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Aug 2008 09:28:27 -0400
In-Reply-To: <20080807100825.8036.88782.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Fix allocation with GFP_KERNEL in ctnetlink_create_conntrack() under
> read-side lock sections.
> 
> This problem was introduced in 2.6.25.

Applied, thanks.
