From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nefilter: nfnetlink: add nfnetlink_set_err and use it
 in	ctnetlink
Date: Mon, 23 Mar 2009 13:21:47 +0100
Message-ID: <49C77EDB.9070605@trash.net>
References: <20090323100701.14405.49966.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37351 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbZCWMVx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2009 08:21:53 -0400
In-Reply-To: <20090323100701.14405.49966.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch adds nfnetlink_set_err() to propagate the error to netlink
> broadcast listener in case of memory allocation errors in the
> message building.

Applied, thanks.
