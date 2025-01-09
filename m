Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 077AE217738;
	Thu,  9 Jan 2025 12:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736426429; cv=none; b=eW0uWxyi5Gg0zy70oBfscRuaXabeGWyDUtxaYuwCZAfeMu1DtCWaZsps4sq745h1gCaN2csaEYNENoKzRQFiywGHnOOt1uhu6NhXy3rw7ygYicx5MUJ7bh/GU6495L7jP0ZVRojImduKxSD82gtJJV440+RAdVOu2o1sTo09Xj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736426429; c=relaxed/simple;
	bh=ca1aQYRAYVg2nybTJXCZNG7yhLWpXlj2vmLSszRn/fM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LryQX8vXJICNdzJB5T6yN3gM9KdVYwLXzH2iNDYq48onw2W8OQMmZ5/hYtYTjEf6FV195pskTFZt6Fzynsdr76T5f0HoNvJiIlq7/YC348sKiuSV4m9CnAsDAWpmYAfuA42/6sZ7pMO0RE3UGRrSA+WAjuP8pCv/CeNiGx2Ycfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Thu, 9 Jan 2025 13:40:22 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, fw@strlen.de
Subject: Re: [PATCH nf] netfilter: conntrack: clamp maximum hashtable size to
 INT_MAX
Message-ID: <Z3_DtkT6hfSoPn5d@calendula>
References: <20250109123532.41768-1-pablo@netfilter.org>
 <20250109123532.41768-2-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250109123532.41768-2-pablo@netfilter.org>

On Thu, Jan 09, 2025 at 01:35:30PM +0100, Pablo Neira Ayuso wrote:
> According to 0708a0afe291 ("mm: Consider __GFP_NOWARN flag for oversized
> kvmalloc() calls"), use INT_MAX as maximum size for the conntrack
> hashtable. Otherwise, it is possible to hit WARN_ON_ONCE in
> __kvmalloc_node_noprof() when __GFP_NOWARN flag is unset when resizing.
> 
> Note: hashtable resize is only possible from init_netns.

Please, ignore this duplicated patch with incorrect [nf] tag that
slipped through this submission. Sorry for the inconvenience.

Thanks.
