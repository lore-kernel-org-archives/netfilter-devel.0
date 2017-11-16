From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] netfilter: add ifdef around
 ctnetlink_proto_size
Date: Thu, 16 Nov 2017 10:50:41 +0900 (KST)
Message-ID: <20171116.105041.804470304446588046.davem@davemloft.net>
References: <20171115172821.8451-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        arnd@arndb.de
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:37964 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933677AbdKPBuo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Nov 2017 20:50:44 -0500
In-Reply-To: <20171115172821.8451-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed, 15 Nov 2017 18:28:21 +0100

> From: Arnd Bergmann <arnd@arndb.de>
> 
> This function is no longer marked 'inline', so we now get a warning
> when it is unused:
> 
> net/netfilter/nf_conntrack_netlink.c:536:15: error: 'ctnetlink_proto_size' defined but not used [-Werror=unused-function]
> 
> We could mark it inline again, mark it __maybe_unused, or add an #ifdef
> around the definition. I'm picking the third approach here since that
> seems to be what the rest of the file has.
> 
> Fixes: 5caaed151a68 ("netfilter: conntrack: don't cache nlattr_tuple_size result in nla_size")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Applied.
