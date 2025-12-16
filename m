Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F3435CBA4
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Dec 2025 15:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765898746; cv=none; b=K/pdM/1eVHoBbK0ZLUg5RqU7yPWkx7GHf7Bak2IOaU81rd0pflbbug7fVuC1sdBI0BhrKIo5Z1r+D3R5pYEDNK0TmWDHIhSG9PDw0+fbTnExOPcDmDVAbIZ0tWbbfEXtMIJjaUZAw376cLmp6lPzeTB35kb1Qjcwx/sW5ybxA6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765898746; c=relaxed/simple;
	bh=b+H45Z3rRKbCMUEatXy6y3e0uj34LF8RW9HptA2/1ns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K58Ne6lKY9GpNI53eI6baU1/9rQ2tVHTE8WovvawYqMTsb7mM6ttCoeGfz5mvQMp+eLobjHC9pSVZs6beWc+ID2AkzGdzb/Rt96qbRAjB9v/Nxraw3drWiL3zj+bWkKLoPkh2AEiqMZxMugOrv0XXMd17abVK9+cvakFlmk8m64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 12C856035A; Tue, 16 Dec 2025 16:25:41 +0100 (CET)
Date: Tue, 16 Dec 2025 16:25:40 +0100
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	Aleksandra Rukomoinikova <ARukomoinikova@k2.cloud>
Subject: Re: [PATCH nf] netfilter: nf_conncount: increase connection clean up
 limit to 64
Message-ID: <aUF59KJs9ghiGBdR@strlen.de>
References: <20251216122449.30116-1-fmancera@suse.de>
 <aUFgyOkfh8e8vx_Z@strlen.de>
 <3f651847-9a0e-4007-8790-ffacd90f6e32@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f651847-9a0e-4007-8790-ffacd90f6e32@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> This sounds quite expensive to me. What about the following solution?
> 
> 1. In nf_conncount_list, add "unsigned int last_gc_count"
> 2. In __nf_connncount_add the optimization would look like this:
> 
> 	if ((u32)jiffies == list->last_gc && (list->count - list->last_gc_count) >=
> CONNCOUNT_GC_MAX_NODES - 1)
> 	goto add_new_node;

Won't that rescan the same entries for as long as the condition
persists?

That was the reason for the move-to-tail, so we start with something
that we did not scan yet.

> 3. After gc, we update the list->last_gc_count.
> 
> This way we make sure the optimization is not done if 7 or more connections
> were added to the list.

How many entries could be expected per seconds?  I think "tens of
thousands" is possible. If not, then just increasing the GC_MAX_NODES
would work.

If we can't make this work, no choice but to add a destructor callback
to conntrack... I very much dislike that idea.

> It should ensure that the list does not fill up. For
> better optimization, we can increase the number to 64 as I proposed. The
> solution you proposed works too but I am worried that it will trigger a CPU
> lockup for a big amount of connections..

You could add "start = jiffies" and break on "jiffies != start",
which would split the gc over multiple add requests.
