From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: improve chain name validation
Date: Sun, 3 Nov 2013 21:23:23 +0100
Message-ID: <20131103202323.GA31399@localhost>
References: <20131005163315.GA16881@home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34529 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210Ab3KCUX2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Nov 2013 15:23:28 -0500
Content-Disposition: inline
In-Reply-To: <20131005163315.GA16881@home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Oct 05, 2013 at 09:33:15AM -0700, Phil Oester wrote:
> As pointed out by Andrew Domaszek, iptables allows whitespace to be included in
> chain names.  This causes issues with iptables-restore, and later iptables
> actions on the chain.  Attached patch disallows whitespace, and also consolidates
> all chain name checking into a new function.
> 
> This closes netfilter bugzilla #855.

Applied, thanks Phil.

I have mangled this patch to include the ip6tables.c chunk, let me
know if you find any problem with it.
