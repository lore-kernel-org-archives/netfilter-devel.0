From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/8] [PATCH] get rid of module refcounting in ctnetlink
Date: Mon, 17 Nov 2008 16:01:13 +0100
Message-ID: <49218739.2010205@trash.net>
References: <20081117083924.11368.38741.stgit@Decadence> <20081117084011.11368.82960.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45750 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbYKQPBT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:01:19 -0500
In-Reply-To: <20081117084011.11368.82960.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch replaces the unnecessary module refcounting with
> the read-side locks. With this patch, all the dump and fill_info
> function are called under the RCU read lock.
> 
> Based on a patch from Fabian Hugelshofer.

Applied, thanks.
