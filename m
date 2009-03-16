From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] netfilter: ctnetlink: cleanup master conntrack assignation
Date: Mon, 16 Mar 2009 15:26:16 +0100
Message-ID: <49BE6188.9020601@trash.net>
References: <20090305160714.13755.83435.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46365 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbZCPO0T (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 10:26:19 -0400
In-Reply-To: <20090305160714.13755.83435.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch moves the assignation of the master conntrack to
> ctnetlink_create_conntrack(), which is where it really belongs.
> This patch is a cleanup.

Applied, thanks.
