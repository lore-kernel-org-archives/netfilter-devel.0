From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/2] netfilter updates for davem's net tree
Date: Thu, 13 Oct 2011 16:41:26 -0400 (EDT)
Message-ID: <20111013.164126.620193113278061001.davem@davemloft.net>
References: <1318440772-21058-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:41321 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab1JMUmd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Oct 2011 16:42:33 -0400
In-Reply-To: <1318440772-21058-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: pablo@netfilter.org
Date: Wed, 12 Oct 2011 19:32:50 +0200

> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Hi Dave,
> 
> The following patches are two bugfixes for your net tree. One
> regarding the conntrack event infrastructure with GRE traffic
> and one fix to resolve one deadlock in the IPVS state
> synchronization.
> 
> You can pull these changes from (my nf branch):
> 
> git://1984.lsi.us.es/net nf

Thanks Pablo, I'll pull this as soon as Linus takes in my most recent
pull request.  I don't want new changes appearing in my tree outside
of those I told him would be there in my pull request, that tends to
upset him. :-)
