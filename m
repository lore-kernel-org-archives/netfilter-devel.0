Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C084470426;
	Fri,  4 Sep 2026 10:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788519336; cv=none; b=EwX2lGSJKsCzbk5T5cR8uZzeye18RsI+yOOiR8OaC9GnlbsULlmUWEEJBHlG5DiS/EYlDsPUN956SMlxDgwyCvjUWGPx1GHbbTf7OOB+dxhTlnCHnIuEjdfpyFQ7DkSZ+LWxRaEHuU2HybsKyEWP9xJBzT2AR68ad+CWob41bxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788519336; c=relaxed/simple;
	bh=DHBScs3P9eKwN1GFKWiqw2JN0X+r/jYPl5lQUXpTIBE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oAsTzbhsJQI8skvGBta3wEDDNQ0gDDDiXmu4oU5O7t9psp8YazrACPYlYPtXfJIC3fPvTfD297xgfjA6WENwMPx7alEHGK9hl26IUaL7fUGEiQFF5iJrR9do+zY6D06lNTmgfiViK+bpjGpNoe/nTQ0g0THtpo1AEofjxsZN9wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hR0wzeME; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hR0wzeME"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788519324;
	bh=n2A79gNBiGBmqqsneEW5PVa4+WHIOnioedeu6qUJmKA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hR0wzeMEUugWVdJLmOIM0jceW1YOKnLVxuvsm1XY1x9sJH32IuSoHIgO+ZdvYz4Z0
	 pHpRbGeBHIHZW3z3V832pX0ikPVxmOnsDTw6kndts0DXXGZjrQnv2JX7+3xtp15qvY
	 rGZe9BnKI/tLef+trJScQIZyrXW9C4+s7gqBItQLKbt+gkASxvJd7Unwokmpcmzos9
	 Fzyf+UP9e54bK2ZNw+ljHAlrSXcdyZxS9/XNRJ8xxx750ykNPS/OmqL02nAT5E+FcW
	 oYk0hvDYlz2UpgkF/Pd4hcBsV4oCJY8Dy8up4atjtFm4cfXS2w5GD04VJiX/+q6SLb
	 S1L3nc6iY7yDg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id C83CF60411;
	Fri,  4 Sep 2026 12:55:24 +0200 (CEST)
Date: Fri, 4 Sep 2026 12:55:22 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
	edumazet@google.com, horms@kernel.org, ja@ssi.bg
Subject: Re: [PATCH net 00/12] Netfilter/IPVS fixes for net
Message-ID: <apqjmkrJm94S4ayw@chamomile>
References: <20260903004149.1037028-1-pablo@netfilter.org>
 <20260903190425.332cd930@kernel.org>
 <appds8dn7fuqOvHw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <appds8dn7fuqOvHw@strlen.de>

On Fri, Sep 04, 2026 at 07:57:07AM +0200, Florian Westphal wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> > On Thu,  3 Sep 2026 02:41:37 +0200 Pablo Neira Ayuso wrote:
> > > netfilter pull request 26-09-03
> > 
> > I think the AI is now going too far claiming the patches don't fully
> > close the issue and/or the commit message isn't 100% accurate.
> > But we missed the net PR today, already, so why not confirm..
> 
> Pablo, I suggest you drop all my patches from this batch and resend.

I can skip, then pick them up for you to address the issues and
resubmit.

Just let me know, thanks!
