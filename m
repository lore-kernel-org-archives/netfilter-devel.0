From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/2] netfilter fixes for net
Date: Tue, 26 Feb 2013 17:24:53 -0500 (EST)
Message-ID: <20130226.172453.430508326485431658.davem@davemloft.net>
References: <1361886320-9492-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:43254 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab3BZWYz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:24:55 -0500
In-Reply-To: <1361886320-9492-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: pablo@netfilter.org
Date: Tue, 26 Feb 2013 14:45:18 +0100

> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Hi David,
> 
> The following patchset contains two bugfixes for netfilter/ipset via
> Jozsef Kadlecsik, they are:
> 
> * Fix timeout corruption if sets are resized, by Josh Hunt.
> 
> * Fix bogus error report if the flag nomatch is set, from Jozsef.
> 
> You can pull these changes from:
> 
> git://1984.lsi.us.es/nf master

Pulled, thanks Pablo.
