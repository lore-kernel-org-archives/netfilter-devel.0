From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 00/19] Netfilter/IPVS updates for net-next
Date: Tue, 20 Aug 2013 13:40:49 -0700 (PDT)
Message-ID: <20130820.134049.661722660296186091.davem@davemloft.net>
References: <1376996091-3964-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:46830 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab3HTUku (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Aug 2013 16:40:50 -0400
In-Reply-To: <1376996091-3964-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 20 Aug 2013 12:54:32 +0200

> The following batch contains Netfilter/IPVS updates for your net-next tree.
> More specifically, they are:

Pulled, but I had to resolve a conflict in the TCP conntrack code wrt.
changing the type of a local variable to "s32" in net which I merged
into net-next the other day.

Look at the merge commit I pushed out, you'll see :-)
