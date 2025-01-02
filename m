Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188613FE4;
	Thu,  2 Jan 2025 12:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735820620; cv=none; b=SLAMCZ+isEm5BJHqNy56Ea2tj89PvqY9ODInSSYbvUzjpHykKDZRBsjv/dGnr3Uu/j2HjBngGVLbhpj9RG39+E0kKs0bIKfdNpRaNrxhnP046m65MhdLK6M9DUn/WQ+VCCF22Vp6VJCGTCacMQqHFFpYBxxo1ews0IdyyQR488c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735820620; c=relaxed/simple;
	bh=jObhsrXukEY0InkVG5HE4HXWGj75fWaFAEOY1PptTgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oY53K5d5g/Gsj+Os9dqb2j5swuHkaepHmc+bss2DHYOelhLKnD6RG9pboslyCaphe7y1zXjupzmxocdzZr9AX3us0OXu/GCgQsZwoKzLTXsyzwwc49ILjtBq/ovac5sNc/t1DR44pjOMFBan9OId73s7p6XuNbNmxoui6ClB1/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tTKEN-0000sJ-2i; Thu, 02 Jan 2025 13:23:15 +0100
Date: Thu, 2 Jan 2025 13:23:15 +0100
From: Florian Westphal <fw@strlen.de>
To: David Laight <david.laight.linux@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, egyszeregy@freemail.hu,
	pablo@netfilter.org, lorenzo@kernel.org, daniel@iogearbox.net,
	leitao@debian.org, amiculas@cisco.com, kadlec@netfilter.org,
	davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: uapi: Merge xt_*.h/c and ipt_*.h which has
 same name.
Message-ID: <20250102122315.GA3344@breakpoint.cc>
References: <20250101192015.1577-1-egyszeregy@freemail.hu>
 <20250101224644.GA18527@breakpoint.cc>
 <20250102075502.3b8fbc95@dsl-u17-10>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250102075502.3b8fbc95@dsl-u17-10>
User-Agent: Mutt/1.10.1 (2018-07-13)

David Laight <david.laight.linux@gmail.com> wrote:
> On Wed, 1 Jan 2025 23:46:44 +0100
> Florian Westphal <fw@strlen.de> wrote:
> 
> > egyszeregy@freemail.hu <egyszeregy@freemail.hu> wrote:
> > >  /* match info */
> > > -struct xt_dscp_info {
> > > +struct xt_dscp_match_info {  
> > 
> > To add to what Jan already pointed out, such renames
> > break UAPI, please don't do this.
> 
> Doesn't the header file rename also break UAPI?

Sure, thats what Jan already pointed out, plus a suggestion
on how to do this correctly.
