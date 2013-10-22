From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] netfilter: ipset: The unnamed union initialization
 may lead to compilation error
Date: Tue, 22 Oct 2013 10:24:02 +0200
Message-ID: <20131022082402.GC20742@localhost>
References: <1382089317-24311-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1382089317-24311-4-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55128 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672Ab3JVIYG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Oct 2013 04:24:06 -0400
Content-Disposition: inline
In-Reply-To: <1382089317-24311-4-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 18, 2013 at 11:41:57AM +0200, Jozsef Kadlecsik wrote:
> The unnamed union should be possible to be initialized directly, but
> unfortunately it's not so:
> 
> /usr/src/ipset/kernel/net/netfilter/ipset/ip_set_hash_netnet.c: In
> function ?hash_netnet4_kadt?:
> /usr/src/ipset/kernel/net/netfilter/ipset/ip_set_hash_netnet.c:141:
> error: unknown field ?cidr? specified in initializer

Applied, thanks.
