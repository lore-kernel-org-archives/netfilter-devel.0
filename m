From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/3] netfilter fixes for 3.4-rc1
Date: Tue, 03 Apr 2012 19:16:05 -0400 (EDT)
Message-ID: <20120403.191605.915202623387252742.davem@davemloft.net>
References: <1333446658-2335-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:39471 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab2DCXRM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Apr 2012 19:17:12 -0400
In-Reply-To: <1333446658-2335-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: pablo@netfilter.org
Date: Tue,  3 Apr 2012 11:50:55 +0200

> The following patches contain a couple of small fixes for Netfilter:
> 
> * One compilation warning fix for xt_LOG from Jan Beulich.
> 
> * Fix compilation issues of user-land ipset with kernel header file
>   from Jan Engelhardt via Jozsef Kadlecsik.
> 
> * Fix one compilation warning in the recent changes done in xt_CT to
>   support the extended cttimeout infrastracture, spotted by Eric
>   Dumazet.
> 
> You can pull them from:
> 
> git://1984.lsi.us.es/net master

Pulled.
