From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH 0/4] fix rule flush operation
Date: Thu, 3 Oct 2013 13:22:49 +0200
Message-ID: <20131003112249.GA16200@localhost>
References: <1380755288-17587-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60785 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629Ab3JCLW5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Oct 2013 07:22:57 -0400
Content-Disposition: inline
In-Reply-To: <1380755288-17587-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 03, 2013 at 01:08:04AM +0200, Eric Leblond wrote:
> 
> Hello,
> 
> Here's a small patchset which fixes rule flushing. A command
> like:
>  nft flush table ip6 nat 
> was not flushing the rules at all. Patch 4 fixes the problem
> and patch 3 limit the scope of the flush which was not limited.

All applied, thanks Eric.
