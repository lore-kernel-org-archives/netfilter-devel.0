From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH 2/3] netfilter: nft_rbtree: no need for spinlock from set
 destroy path
Date: Tue, 2 Sep 2014 12:11:57 +0100
Message-ID: <20140902111157.GD6778@casper.infradead.org>
References: <1409650721-9621-1-git-send-email-pablo@netfilter.org>
 <1409650721-9621-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:33329 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbaIBLL6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:11:58 -0400
Content-Disposition: inline
In-Reply-To: <1409650721-9621-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09/02/14 at 11:38am, Pablo Neira Ayuso wrote:
> The sets are released from the rcu callback, after the rule is removed
> from the chain list, which implies that nfnetlink cannot update the
> rbtree and no packets are walking on the set anymore. Thus, we can get
> rid of the spinlock in the set destroy path there.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Reviewied-by: Thomas Graf <tgraf@suug.ch>
