Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADA33B27E2
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2026 14:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790345363; cv=none; b=YY0xz37ApXKhevW0OkfiMGfJzrziHyiTs5ym6WaTzC/OqO6uitJ47Tn1+JxSACBnkW7DM/3BeiaqpxRgx8XvjWVywO0UWnvFw5Oq2zhzNa7IsUrMXnuDOjcRo1SXOWXobEO0+9OGp7t9xClQQQtWmvUdhyzNJITUzxhLaNans4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790345363; c=relaxed/simple;
	bh=F59pXC3CI4cBhdCinL55QC54DJn4u/kBt+YaMDBnfWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DPlJfw1OQ/bPi8NpnB4CK0WI+k2Ajs6bdnZbOAsuds3Atk4ZJx2cTqFXY3hNrb+qRo8WBtXPkBBQ6HNohOEeXu4fexmUnf4AcbBJZan4E63GaKmLWZUpcrvfkusRfBFOSCAEKsqk/Vj9t/56MNHaBFbMe/ubGeS5C94ZvwCOoIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7531760344; Fri, 25 Sep 2026 16:09:11 +0200 (CEST)
Date: Fri, 25 Sep 2026 16:09:10 +0200
From: Florian Westphal <fw@strlen.de>
To: Antonio Ojea <antonio.ojea.garcia@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	Dan Winship <danwinship@redhat.com>
Subject: Re: nf_queue: hook changes drop or re-queue packets waiting in any
 nfqueue
Message-ID: <araAhumrNKQ48-Re@strlen.de>
References: <CABhP=tYtCyr-qzL==98nkmDVZr6x+f8E26V1AAOpMXgZgt0vAQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABhP=tYtCyr-qzL==98nkmDVZr6x+f8E26V1AAOpMXgZgt0vAQ@mail.gmail.com>

Antonio Ojea <antonio.ojea.garcia@gmail.com> wrote:
> deleting an nftables base chain drops every packet that is waiting for
> a verdict in any nfqueue of the network namespace, including packets
> queued by hooks of other tables and other families. Adding a base chain
> in front of the one that queued a packet makes the packet traverse the
> queuing hook again after the verdict, so userspace sees it twice.
> 
> We found the first problem in kube-network-policies and kindnet
> (Kubernetes network policy and CNI agents built on nfqueue) [1]. Their
> nftables sync did "add table; delete table; add table" to replace the
> ruleset, and every sync lost the connections being evaluated at that
> moment. The userspace symptom is the verdict for the dropped packet
> failing asynchronously with -ENOENT:
> 
>   "Could not receive message"
>   error="netlink receive: no such file or directory"
> 
> The add/delete/add idiom was my mistake. The documented way to replace
> a ruleset atomically is "flush table" (or "flush chain") in the same
> transaction, which keeps the base chains and their hooks, and we need
> to change that. However, it does not cover upgrades. A table written by an
> older version may have a chain and/or sets the new version
> no longer uses. Removing them still requires deleting the table, or
> the chain, at least once at startup, with the same effect on every
> nfqueue in the namespace. Suggestions on how to handle that case are
> welcome.
> 
> Independently of fixing it in our projects, any other component will
> trigger the same problem that applies to any nfqueue consumer.

I don't think this is fixable.  You could tell your coding assistant
to pass const struct nf_hook_ops *reg down into nf_queue_nf_hook_drop().

If thats not NULL, then pass it to a new nfqnl_cmpfn() that only
drops skbs when the struct nf_queue_entry shares same pf and
same hooknum as the one in nf_hook_ops arg.

That would limit the impact a bit.
