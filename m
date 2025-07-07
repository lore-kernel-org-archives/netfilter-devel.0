Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC46224B0E
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Jul 2025 19:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751916515; cv=none; b=Ic3XsxLTDm/jc1Dgjmp/bSqBgSQBti4IWBo/A46fyL08poA9vTKWXCMVebD+hYccIKBfL+iKORYUlRe55Vtn7qWBFcLQZV4oyR/f1UIjZ7bYr15HK0hWN6ohEZ4dQdupIWg8zKnh/e7rbudy06ZxUy5kiwR+daE0jk0k58kblDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751916515; c=relaxed/simple;
	bh=T9HJC5JpKVnimhkB+MbdBKuvPy4DArclEB5szoFUkCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E6SE8AQK41yus/pIpI7dF5gw6cV3wvf4+zePcLERfGxkhHY/lu2IUtTH6kMGCW4oYO7tZc4+fSv6bCW/sQ9tUkSYP3Gbq6VCKtrLi/0ejiuh3Rjm/pvvg2K3iqSm0fvnFARmEpjG0m5i0mdFQutGG7ZNJw1y58pttiWN+Qn6iwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D9A63604C6; Mon,  7 Jul 2025 21:28:29 +0200 (CEST)
Date: Mon, 7 Jul 2025 21:28:29 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 0/2] src: add conntrack information to trace monitor
 mode
Message-ID: <aGwf3dCggwBlRKKC@strlen.de>
References: <20250707094722.2162-1-fw@strlen.de>
 <aGwZ4MKAhUQWuGiL@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGwZ4MKAhUQWuGiL@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Jul 07, 2025 at 11:47:12AM +0200, Florian Westphal wrote:
> > First patch is a preparation patch that moves the trace code
> > from netlink.c to the new trace.c file.
> > 
> > Second patch adds the ct info to the trace output.
> > 
> > This patch exposes the 'clash' bit to userspace.
> > (Technically its the kernel counterpart).
> > 
> > If you dislike this, I can send a kernel patch that removes
> > the bit before dumping ct status bits to userspace, let me
> > know.
> 
> If this is intentional, then
> 
> +             SYMBOL("clash",         IPS_UNTRACKED_BIT),
> 
> hiding clash bit is probably a good idea.

Currently the existence of 'clash' entries are a kernel-internal
implemenation detail.

Neither /proc or ctnetlink exposes them, the dump handlers only
emit ORIGINAL direction, but the clash entries are only inserted
into the hashes for the reply tuple.

Hence, they are not visible so far.
With this change however, a packet that matches a clash entry (reply
dir), will have skb->_nfct set to a 'clash' entry and so its ct->status
and ID are exposed to userspace.

This isn't a problem, but it does mean that the IPS_UNTRACKED_BIT is
set in ct->status.

IPS_UNTRACKED isn't used anymore in the kernel, it has been re-purposed
to flag the clash entries (IPS_NAT_CLASH_BIT = IPS_UNTRACKED_BIT, but
the former constant isn't exposed via UAPI).

Thats the reason for this awkward

  SYMBOL("clash",         IPS_UNTRACKED_BIT),

> Just hide it from userspace nftables in this series, later I'd suggest
> you proceed with the kernel update.

If I remove this line from the patch, then I can skip/ignore the value
in userspace, e.g.:

diff --git a/src/trace.c b/src/trace.c
index b270951025b8..b3b2c8fdf1b9 100644
--- a/src/trace.c
+++ b/src/trace.c
@@ -264,7 +264,7 @@ static struct expr *trace_alloc_list(const struct datatype *dtype,
        for (i = 0; i < 32; i++) {
                uint32_t bitv = v & (1 << i);

-               if (bitv == 0)
+               if (bitv == 0 || i == IPS_UNTRACKED_BIT)
                        continue;

and remove the IPS_UNTRACKED_BIT from the symbol table.

Then followup with a kernel patch that removes IPS_UNTRACKED_BIT before
dumping ct->status.

Does that sound ok?
If so, I'll apply the first patch in this series before resending 2/2.

Thanks!
