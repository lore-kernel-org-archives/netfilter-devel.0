From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft] strange behaviour
Date: Wed, 23 Sep 2015 00:24:54 +0200
Message-ID: <20150922222454.GA4740@salvia>
References: <5601a0c8.vTjiOdyXOkEgHeZy%littlesmilingcloud@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, dau@sunlink.ru
To: littlesmilingcloud@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35030 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759458AbbIVWSG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Sep 2015 18:18:06 -0400
Content-Disposition: inline
In-Reply-To: <5601a0c8.vTjiOdyXOkEgHeZy%littlesmilingcloud@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 22, 2015 at 09:41:12PM +0300, littlesmilingcloud@gmail.com wrote:
> Hello.
> 
> I have try to add the subnet element to the named set, and nft has closed unexpectly.
> I use the 4.2 stable kernel and latest stable release of libnftnl and nftables from git.
> 
> Reproduce of the strange behaviour.
> --------------------------------------------------------------------------------------
> nft> list ruleset;
> nft> add table ip filter;
> nft> add set ip filter addr_list { type ipv4_addr; }

This should be instead:

nft> add set ip filter addr_list { type ipv4_addr; flags interval; }

> nft> add element ip filter addr_list { 192.168.1.1 }
> nft> add element ip filter addr_list { 192.168.10.0/24 }
> BUG: invalid data expression type prefix
> nft: netlink.c:326: netlink_gen_data: Assertion `0' failed.

We should be showing a better error on this, so the user knows the set
was not defined to have intervals.

Anyway, even after the missing flags there on top, you'll hit another
EEXIST bug that we currently have in the kernel.
