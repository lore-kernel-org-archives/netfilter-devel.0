From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: conntrack: don't deliver events for racy packets
Date: Mon, 16 Mar 2009 15:07:08 +0100
Message-ID: <49BE5D0C.90807@trash.net>
References: <20090225025334.4646.98606.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45801 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbZCPOHL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 10:07:11 -0400
In-Reply-To: <20090225025334.4646.98606.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch skips the delivery of conntrack events if the packet
> was drop due to a race condition in the conntrack insertion.

Applied, thanks.
