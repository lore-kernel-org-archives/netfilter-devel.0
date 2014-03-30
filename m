From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: Add {ipt,ip6t}_osf aliases for xt_osf
Date: Sun, 30 Mar 2014 13:33:46 +0200
Message-ID: <20140330113346.GA5593@localhost>
References: <1395830279.3601.2.camel@tkhai>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Kirill Tkhai <ktkhai@parallels.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42870 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbaC3Ldw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Mar 2014 07:33:52 -0400
Content-Disposition: inline
In-Reply-To: <1395830279.3601.2.camel@tkhai>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 26, 2014 at 02:37:59PM +0400, Kirill Tkhai wrote:
> There are no these aliases, so kernel can not request appropriate
> match table:
> 
> $ iptables -I INPUT -p tcp -m osf --genre Windows --ttl 2 -j DROP
> iptables: No chain/target/match by that name.
> 
> setsockopt() requests ipt_osf module, which is not present. Add
> the aliases.

Applied, thanks.
