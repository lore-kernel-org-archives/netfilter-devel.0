Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768B519DF44
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Mar 2025 15:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743090935; cv=none; b=VsNIGtuGtbcvMMZ9ng/gL4gH3TBNeadV2P15DRkxGjvfXv/ww9RkjoO7bJUiXpEJ0FCoeqiLmUNw+orGuunXusCzGgl6hgMP286RDmhQRPiTiBvjyxpavtKGbOu/QsJKNjKy4nh1+7un6H6ClA+FUoljA5bFohSIYlxyOCNKg+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743090935; c=relaxed/simple;
	bh=hE5FnnjUw7GOj2yMNDxw3Qxr3i1FJlsMKj+RSEA5gBw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PDyKw1u36MN4r6yV+JWUPIbjUG3/DtudMg04USR03vtCPPaHJzDeJhCXbxzNaqxzqXUZxHMS7x9JNmqQEJg6MXRMrQmdT3OvKi0rz5TFPgU4WIYwf7fwd4HSLF9Si6NnzHOOCSz8lgypZOmgUNYe07HC6tuooYi9ReQJNnS/MEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1txpZr-0007sH-IC; Thu, 27 Mar 2025 16:55:31 +0100
Date: Thu, 27 Mar 2025 16:55:31 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: tolerate empty concatenation
Message-ID: <20250327155531.GC21843@breakpoint.cc>
References: <20250324115301.11579-1-fw@strlen.de>
 <Z-Vv1R-OmC2QukpS@calendula>
 <Z-VxdrgTRO1RTdBq@calendula>
 <20250327154910.GB21843@breakpoint.cc>
 <Z-V0NMf-ym2FKUr1@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-V0NMf-ym2FKUr1@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I think assertion are still useful to denote something is very broken
> if we get to the evaluation step with an empty concatenation.

OK, then please push put your fix then.
