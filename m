From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 5/7] netfilter: nf_tables: move set handling to the
 transaction infrastructure
Date: Fri, 28 Mar 2014 13:00:40 +0000
Message-ID: <20140328130040.GE7895@macbook.localnet>
References: <1395957197-4899-1-git-send-email-pablo@netfilter.org>
 <1395957197-4899-6-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55458 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaC1NAo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Mar 2014 09:00:44 -0400
Content-Disposition: inline
In-Reply-To: <1395957197-4899-6-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 27, 2014 at 10:53:15PM +0100, Pablo Neira Ayuso wrote:
> This patch reworks the nf_tables API so set updates are moved into
> the same batch that contains rule updates. This speeds up rule-set
> updates we skip a dialog of four messages between kernel and
> user-space (two on each direction).
> 
>  1) create the set and send netlink message to the kernel
>  2) process the response from the kernel that contains the allocated name.
>  3) add the set elements and send netlink message to the kernel.
>  4) process the response from the kernel (to check for errors).
> 
> To:
> 
>  1) add the set to the batch.
>  2) add the set elements to the batch.
>  3) add the rule that points to the set.
>  4) send batch to the kernel.
> 
> The idea is to allocate an internal set ID to the batch that can be
> used when adding set elements and rules that refer to the set in the
> batch.
> 
> Note that this patch doesn't add atomic set element updates, it just
> helps to leave the set configuration in consistent state in case
> that we fail to load the entire batch for some reason.

Looks fine to me. However I'm wondering whether this couldn't be
simplified. Basically all we need is a way to detect sets contained
in the batch for abort/commit, which could be achieved using a single
flag. The sets don't have any direct impact on runtime and they're
not visible to userspace as long as we hold the nfnl. So all we need
to do on abort is kill all the sets with this flag, on commit we
clear the flag and send notifications.

> Backward compatibility has been only retained in userspace, this
> means that new nft versions can talk to the kernel both in the new
> and the old fashion.

And old nftables can't talk to new kernels?
