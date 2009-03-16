From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] netfilter: ctnetlink: move event reporting for new
 entries outside the lock
Date: Mon, 16 Mar 2009 15:28:45 +0100
Message-ID: <49BE621D.9070800@trash.net>
References: <20090305160714.13755.83435.stgit@Decadence> <20090305160759.13755.64802.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46556 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbZCPO2t (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 10:28:49 -0400
In-Reply-To: <20090305160759.13755.64802.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch moves the event reporting outside the lock section. With
> this patch, the creation and update of entries is homogeneous from
> the event reporting perspective. Moreover, as the event reporting is
> done outside the lock section, the netlink broadcast delivery can
> benefit of the yield() call under congestion.

Applied, thanks.
