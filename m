From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] netfilter: ctnetlink: cleanup conntrack update	preliminary
 checkings
Date: Mon, 16 Mar 2009 15:27:56 +0100
Message-ID: <49BE61EC.7030503@trash.net>
References: <20090305160714.13755.83435.stgit@Decadence> <20090305160736.13755.30397.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46422 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbZCPO17 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 10:27:59 -0400
In-Reply-To: <20090305160736.13755.30397.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch moves the preliminary checkings that must be fulfilled
> to update a conntrack, which are the following:
> 
>  * NAT manglings cannot be updated
>  * Changing the master conntrack is not allowed.
> 
> This patch is a cleanup.

Applied, thanks.
