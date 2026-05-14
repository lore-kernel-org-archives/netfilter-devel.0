Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2921542315D
	for <netfilter-devel@vger.kernel.org>; Thu, 14 May 2026 15:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778773505; cv=none; b=Ago+Wg479svW12VkdFU3td0CQFK3Y60Qpfz4A/3Bc4MaHzcacdWnvGmDeMUViR905o7eFlDrQfsbdizYih0Fr2xSzFEybZxoY5kXrpKWyCx9++JTF1/VhXFdNImPxf4VqlPtCVlS/7YqrC/or9xFtO/E0MQu6BbBW4tK3LFQ26U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778773505; c=relaxed/simple;
	bh=/dcj/g55MVSIBV449Ee4wt3lCSfxKm+oZk9uZKCKMJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AOYbFbzMdyVZoIVekyxA/HjcBee3pikh0K+/D5EgqxKD8vaFUhaQcPU5nteD3rUGZxzAYPXYtREGMh0DmuEQk+FDfNlM6dMxhgMnWuhbTMhYTu6unNXSvdwYY73N1QhlcY2is6LQCKgn5HQXRx2cqOhlrt4/bcZQ/vOL4KLT9dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 30EEB6099C; Thu, 14 May 2026 17:44:59 +0200 (CEST)
Date: Thu, 14 May 2026 17:44:58 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v2] netfilter: conntrack: add dead flag to helpers
Message-ID: <agXt-m9yN-oayY1G@strlen.de>
References: <20260514143016.874811-1-pablo@netfilter.org>
 <agXfhQb8Dcl9p5ce@strlen.de>
 <agXl-3NDpK3YUZiF@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agXl-3NDpK3YUZiF@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, May 14, 2026 at 04:43:17PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Add a new NF_CT_HELPER_F_DEAD helper flag to notify the packet path that
> > > this helper is going away. Thus, helpers are effectively disabled and no
> > > new expectations are created while removing the expectations created by
> > > this helper as well as unhelping the existing conntrack entries.
> > > 
> > > Add the check for NF_CT_HELPER_F_DEAD in the packet path to:
> > > - Conntrack confirmation path which invokes the helper callback.
> > > - Propagation of helper to conntrack via expectation.
> > > - OVS ct helper invocation.
> > 
> > Not sure this is enough.  New conntracks are not in any hash table /
> > unreachable, and synchronize_rcu() doesn't guarantee they get confirmed
> > (can get queued).
> 
> nf_ct_iterate_destroy() calls nf_queue_nf_hook_drop() for each netns.

But is that enough?  Consider:

cpu0						cpu1
						recieves verdict
						unlink from nfqueue list
drop_queued_packets (misses unlinked)
						... going on ..

I think to properly resolve this, there is a need to check
for this new dead flag after queueing to userspace (after its on list)
and again when receiving the verdict.

Arguably this is kind of different bug, because this comment is wrong:

/* a skb w. unconfirmed conntrack could have been reinjected just
 * before we called nf_queue_nf_hook_drop().
 *
 * This makes sure its inserted into conntrack table.
 */
 synchronize_net();

(it could have been requeued).

I think a more generic fix is to add a seqcnt to nf_queue_entry.
When queueing, record current seqcnt.

On reinject, drop if unconfirmed and seqcnt_now != entry->seqcnt.
Not nice, but I don't see a better way ATM.

The seqcnt can be pernet and it can be restricted to nfnetlink_queue.

Any better idea?
