From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] libnftables: Get rid of explicit cache flushes
Date: Thu, 26 Oct 2017 20:15:40 +0200
Message-ID: <20171026181540.GA4669@salvia>
References: <20171025092515.GB350@salvia>
 <20171025114029.22043-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55170 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932343AbdJZSPp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Oct 2017 14:15:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7C975E3A03
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Oct 2017 20:15:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6DBB9DA390
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Oct 2017 20:15:43 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171025114029.22043-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 25, 2017 at 01:40:29PM +0200, Phil Sutter wrote:
> In the past, CLI as a potentially long running process had to make sure
> it kept it's cache up to date with kernel's rule set. A simple test case
> is this:
> 
> | shell a		|	shell b
> |			|	# nft -i
> | # nft add table ip t	|
> |			|	nft> list ruleset
> |			|	table ip t {
> |			|	}
> | # nft flush ruleset	|
> |			|	nft> list ruleset
> |			|	nft>
> 
> In order to make sure interactive CLI wouldn't incorrectly list the
> table again in the second 'list' command, it immediately flushed it's
> cache after every command execution.
> 
> This patch eliminates the need for that by making cache updates depend
> on kernel's generation ID: A cache update stores the current rule set's
> ID in struct nft_cache, consecutive calls to cache_update() compare that
> stored value to the current generation ID received from kernel - if the
> stored value is zero (i.e. no previous cache update did happen) or if it
> doesn't match the kernel's value (i.e. cache is outdated) the cache is
> flushed and fully initialized again.

Applied, thanks Phil.
