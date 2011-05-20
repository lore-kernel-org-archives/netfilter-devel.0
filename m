From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/2] netfilter: ipset: remove unused variable from
 type_pf_tdel()
Date: Fri, 20 May 2011 14:57:44 -0400 (EDT)
Message-ID: <20110520.145744.1956400397641902387.davem@davemloft.net>
References: <1305917503-14427-1-git-send-email-kadlec@blackhole.kfki.hu>
	<1305917503-14427-2-git-send-email-kadlec@blackhole.kfki.hu>
	<1305917503-14427-3-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:59479 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933899Ab1ETTAx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 May 2011 15:00:53 -0400
In-Reply-To: <1305917503-14427-3-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date: Fri, 20 May 2011 20:51:43 +0200

> Variable 'ret' is set in type_pf_tdel() but not used, remove.
> 
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Acked-by: David S. Miller <davem@davemloft.net>
