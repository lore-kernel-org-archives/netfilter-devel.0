Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF46635335A;
	Wed, 20 Aug 2025 00:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755649456; cv=none; b=CyKtB9monIZhGCYnjQF1w6Rvwt6o6uSDxHh5Ath1TO2bXZk2MFjcy3pE69ECqrZDkmSLm7Prvz2+HIibFY4oahXZ8BwR2Q6ANi/z3WIN1TNFDa1K8VrCw8DOSNQJnwFFZ/uSklXtX/oKWBPJ4t93Su2h/ohA+sNPQci6PMxXHHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755649456; c=relaxed/simple;
	bh=VOnp+I7EggjylKUeMhz7MG70tAy33IjQHjNKQKjZYVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ooA9lK2C4OLES/34vIgdCrvHwbDD0iQp93uNOpDc3kwF2f8GFqRx08cSNIV6n6vggex08upsClDTwFfuiwyGrGlVLtuidGWKhXj2FZ4SaiDVbbyrQ/T8swArBdjXcYmsBzCuvGZd/oFpk31m7YrGvG898erF767bRYYsWZiiqco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9383760329; Wed, 20 Aug 2025 02:24:11 +0200 (CEST)
Date: Wed, 20 Aug 2025 02:24:11 +0200
From: Florian Westphal <fw@strlen.de>
To: Qingjie Xing <xqjcool@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: conntrack: drop expectations before freeing
 templates
Message-ID: <aKUVqxJVrGgRJZA4@strlen.de>
References: <aKTCFTQy1dVo-Ucy@strlen.de>
 <20250819232417.2337655-1-xqjcool@gmail.com>
 <aKUUBsFYBYOu2xu-@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aKUUBsFYBYOu2xu-@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> Qingjie Xing <xqjcool@gmail.com> wrote:
> > With an iptables-configured TFTP helper in place, a UDP packet 
> > (10.65.41.36:1069 → 10.65.36.2:69, TFTP RRQ) triggered creation of an expectation.
> > Later, iptables changes removed the rule’s per-rule template nf_conn. 
> > When the expectation’s timer expired, nf_ct_unlink_expect_report() 
> > ran and dereferenced the freed master, causing a crash.
> 
> Sorry, I do not see the problem.
> A template should never be listed as exp->master.
> 
> Can you make a reproducer/selftest for this bug?
> 
> I worry we paper over a different bug.

Or maybe this will provide a clue (not even compile tested).

@@ -299,6 +302,9 @@ struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me)
 {
        struct nf_conntrack_expect *new;

+       if (WARN_ON_ONCE(nf_ct_is_template(me)))
+               return NULL;
+
        new = kmem_cache_alloc(nf_ct_expect_cachep, GFP_ATOMIC);
        if (!new)

