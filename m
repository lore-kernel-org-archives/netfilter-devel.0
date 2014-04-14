From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/3] Netfilter fixes for net
Date: Mon, 14 Apr 2014 19:00:32 -0400 (EDT)
Message-ID: <20140414.190032.1844010181476508083.davem@davemloft.net>
References: <1397515415-5477-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:59922 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaDNXAe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 19:00:34 -0400
In-Reply-To: <1397515415-5477-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 15 Apr 2014 00:43:32 +0200

> The following patchset contains three Netfilter fixes for your net tree,
> they are:
> 
> * Fix missing generation sequence initialization which results in a splat
>   if lockdep is enabled, it was introduced in the recent works to improve
>   nf_conntrack scalability, from Andrey Vagin.
> 
> * Don't flush the GRE keymap list in nf_conntrack when the pptp helper is
>   disabled otherwise this crashes due to a double release, from Andrey
>   Vagin.
> 
> * Fix nf_tables cmp fast in big endian, from Patrick McHardy.

Pulled, thanks a lot Pablo.
