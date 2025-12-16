Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F29336CDEA;
	Tue, 16 Dec 2025 13:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765892559; cv=none; b=Zb0fTSVLb10/IbuXHmOlTqoBEm6TnwYDlXlSvBNKtPNOt09XMJ/b5yWOpKljaU93jqDFy90JiibNSeUV4YbkuVqkaefHMew6cLDVxJR5uRPvSBZoxlh8EU9NnYbggo36uo8t2UWRW/h9xDVP8oh4XUFxscmn7K7mY6zvlSU7+l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765892559; c=relaxed/simple;
	bh=GRUaZ/lwiFKV79DEXniS5uVdx/Agyvz48jP3F58j52o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mopmcn1zuf0qv9ulU44nIuMJDOQD3Ebx26FqP67d0D/wKgd7FrTSzuvpSnnkgW9m0aUlW5GdHmx2x81MhmkESsrNlQGQxyLl1TKtPPj5RPM0uR6LNL8p+G7GjBrJcp1SLp+GJL1b+wiHIf2uRF0tARpoaqOinvF7xqZqwHpJgKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AA73760218; Tue, 16 Dec 2025 14:42:34 +0100 (CET)
Date: Tue, 16 Dec 2025 14:42:34 +0100
From: Florian Westphal <fw@strlen.de>
To: Ricardo Robaina <rrobaina@redhat.com>
Cc: audit@vger.kernel.org, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	paul@paul-moore.com, eparis@redhat.com, pablo@netfilter.org,
	kadlec@netfilter.org
Subject: Re: [PATCH v7 1/2] audit: add audit_log_nf_skb helper function
Message-ID: <aUFhyhta7EU8i7iu@strlen.de>
References: <cover.1763122537.git.rrobaina@redhat.com>
 <e5a5be5997fc2b8f7cc5f92e48b6d42158aff2c3.1763122537.git.rrobaina@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5a5be5997fc2b8f7cc5f92e48b6d42158aff2c3.1763122537.git.rrobaina@redhat.com>

Ricardo Robaina <rrobaina@redhat.com> wrote:
> Netfilter code (net/netfilter/nft_log.c and net/netfilter/xt_AUDIT.c)
> have to be kept in sync. Both source files had duplicated versions of
> audit_ip4() and audit_ip6() functions, which can result in lack of
> consistency and/or duplicated work.
> 
> This patch adds a helper function in audit.c that can be called by
> netfilter code commonly, aiming to improve maintainability and
> consistency.

Acked-by: Florian Westphal <fw@strlen.de>
