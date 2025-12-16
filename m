Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D953396E4
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Dec 2025 16:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765901203; cv=none; b=eRbn7ttMEcisOxDF22ANJga81IPNX8ZKIDV3fzs43uu2uMIDhNM7sZIox4sMQSvIIVvN3WwXz/RNGXel8KFtz5I/XwXDXtm0wvNXizi7XbpSYIJLbWIRewTIobiTxsbNzruSGvPTdnOy9QBdrqqVuC9Rww/z5K0YxW8pGkalras=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765901203; c=relaxed/simple;
	bh=vGl57ZlnFpw1jFc92hgVM2oojG3zdDYuctdzJIavcBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CF6TQwi/a3crmtU7k11gIw4ZE2NKeWI7hUT1KPMM7Wl91vmce3BBmixD141h9Sp2bw2liyL+X+kUnztp+9KcvusjwtojXbN53L0+t37nzbLwAZaa4n2mJL5jyzlDjPESCJe/gwGNiOiA72XG57V5UpUx2/KW6RxI/7wKZRgKqY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D6E166035A; Tue, 16 Dec 2025 17:06:35 +0100 (CET)
Date: Tue, 16 Dec 2025 17:06:35 +0100
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	Aleksandra Rukomoinikova <ARukomoinikova@k2.cloud>
Subject: Re: [PATCH nf] netfilter: nf_conncount: increase connection clean up
 limit to 64
Message-ID: <aUGDi689H9HnDOv9@strlen.de>
References: <20251216122449.30116-1-fmancera@suse.de>
 <aUFgyOkfh8e8vx_Z@strlen.de>
 <3f651847-9a0e-4007-8790-ffacd90f6e32@suse.de>
 <aUF59KJs9ghiGBdR@strlen.de>
 <4c702f96-99bd-457c-881d-48402c4015c3@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c702f96-99bd-457c-881d-48402c4015c3@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> On 12/16/25 4:25 PM, Florian Westphal wrote:
> > Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> > > 	if ((u32)jiffies == list->last_gc && (list->count - list->last_gc_count) >=
> > > CONNCOUNT_GC_MAX_NODES - 1)
> > > 	goto add_new_node;
> > 
> > Won't that rescan the same entries for as long as the condition
> > persists?
> > 
> > That was the reason for the move-to-tail, so we start with something
> > that we did not scan yet.
> > 
> 
> I do not follow here. AFAICT, the current loop is only breaking if collect
> is greater than CONNCOUNT_GC_MAX_NODES. That means, the loop must find 8
> closed connections or 8 errors (very unlikely) while trying to find the
> connection. If no connection is closed, the whole list is scanned.

What I mean is that:

188         /* check the saved connections */
189         list_for_each_entry_safe(conn, conn_n, &list->head, node) {
190                 if (collect > CONNCOUNT_GC_MAX_NODES)
191                         break;
192
193                 found = find_or_evict(net, list, conn);
194                 if (IS_ERR(found)) {
195                         /* Not found, but might be about to be confirmed */

The loop always starts with the beginning of the lists.
For existing scheme, we rescan every 1 jiffy.

With revised condition, we scan n times.  Without moving scanned
entries to the tail, we therefore query same list entries again.

I had proposed moving them off to the tail to avoid this, so when
doing another scan we start with an element that hasn't been scanned
yet.  This would also allow to alter the early-break conditions, e.g.

if (collected > CONNCOUNT_GC_MAX_NODES || jiffies != time_start)

or similar (wrt. your comment of triggering softlockup due to long
lists).

> I tested this quickly and seems to solve the problem too for a huge amount
> of connections (20000+). As the new adds while skipping the GC will never be
> bigger than what we are able to clean up during a GC.

OK, if its really good enough then lets do it, but I don't see how it avoids
any of the problems mentioned, in particular wrt. softlockup fears.
