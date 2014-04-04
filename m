From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH RFC 0/9] socket filtering using nf_tables
Date: Fri, 04 Apr 2014 11:24:32 -0400 (EDT)
Message-ID: <20140404.112432.523364323608428978.davem@davemloft.net>
References: <1394529560-3490-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	kaber@trash.net
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:52419 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbaDDPW5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Apr 2014 11:22:57 -0400
In-Reply-To: <1394529560-3490-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 11 Mar 2014 10:19:11 +0100

> The following patchset provides a socket filtering alternative to BPF
> which allows you to define your filter using the nf_tables expressions.

Generally I like this series, but of course you will need to respin
it against the work that went into net-next recently.

I only wonder about the expression implementation module loading
logic when we add an nft filter to a socket.

It seems that if the module doesn't exist, we return -EAGAIN, drop the
mutex, and retry.  I see nothing which breaks this loop, it seems like
it can run forever if a module is simply not present.

Thanks.
