Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F7A1DF240
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Feb 2025 11:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738929287; cv=none; b=lBGUn8+iWFoQ08ykBmU5zxOqW6VpLx+KixnM/3+2sCbvS9QAV4h0znRkYqPgjOlUyiCn4A0Rs2q2qoD10BmOPnwfQAS6i1NGC9itVbqarG/7f/fIjmAb54xXdoZp3P2qplOZYLhgsiw2J5UNfN5uKWwU6urQ+z3WoT53CeNc1FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738929287; c=relaxed/simple;
	bh=aQMpMcUj+jl3RHmyun7kIYFB/mw3+qCwE0ntQmclnuM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R6HXJcXOPvufq32+eD+UEIN6ik9p3OkZs/OweY41sGYIx/qcby8HxM/BU2xMkFKeHQ8MWv8+Ifc/RrLs59FRU65PFY8EQUXG6HtVhka7oHgE5TQ+IBa4wThw4N7T8oOGriv6WMyAJmSXYt/SXZthnyEfV90vTdH4V8Lyn5d8FPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=G26CQYXd; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=G26CQYXd; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="G26CQYXd";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="G26CQYXd"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id D021D602AB; Fri,  7 Feb 2025 12:54:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738929280;
	bh=Ty/dZXhkzkLamU7mTR5Epq9OfVv/DjGIdZe0F9JmaBc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G26CQYXdaaee3jRNtzF5IwX0F9r2yHqew63hiddwax4Ah6Pi9+34V1SP1gInNqDP7
	 scL+6hEMm4rcZx39fpPOzuWLoLKEKXfq3yaC5fAvc5KaAHssvennmqoLjEBdESwPbR
	 zC7IMiQhtNjv8xiMWWNV5zNXh9q11PqqpJJkBgYXantcJqMPI34SPiAkdtEBKsvDdl
	 zdL22S54BstAgVEOCDTG8TxbDMgPTqc6ndqfeCc2IuPT39/0YW2TXKg5OWZ9T9T331
	 D6XaJ0tOU9VQufBiSjlB5/x+rJhj7YoDm1hBmj8XCI3slhxWwGNAi95DAExqmYzd/B
	 KTiLsy/ZlQLWA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3C1BA602AB;
	Fri,  7 Feb 2025 12:54:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738929280;
	bh=Ty/dZXhkzkLamU7mTR5Epq9OfVv/DjGIdZe0F9JmaBc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G26CQYXdaaee3jRNtzF5IwX0F9r2yHqew63hiddwax4Ah6Pi9+34V1SP1gInNqDP7
	 scL+6hEMm4rcZx39fpPOzuWLoLKEKXfq3yaC5fAvc5KaAHssvennmqoLjEBdESwPbR
	 zC7IMiQhtNjv8xiMWWNV5zNXh9q11PqqpJJkBgYXantcJqMPI34SPiAkdtEBKsvDdl
	 zdL22S54BstAgVEOCDTG8TxbDMgPTqc6ndqfeCc2IuPT39/0YW2TXKg5OWZ9T9T331
	 D6XaJ0tOU9VQufBiSjlB5/x+rJhj7YoDm1hBmj8XCI3slhxWwGNAi95DAExqmYzd/B
	 KTiLsy/ZlQLWA==
Date: Fri, 7 Feb 2025 12:54:38 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_conntrack 1/2] src: add support for
 CTA_TIMESTAMP_EVENT
Message-ID: <Z6X0fvtcE_dzCvcm@calendula>
References: <20250109131541.5856-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250109131541.5856-1-fw@strlen.de>

On Thu, Jan 09, 2025 at 02:15:36PM +0100, Florian Westphal wrote:
> Allow libnetfilter_conntrack to parse CTA_TIMESTAMP_EVENT attribute.
> This will be included for all ctnetlink events if the kernel has commit
> 
>     netfilter: conntrack: add conntrack event timestamp
> 
> and net.netfilter.nf_conntrack_timestamp sysctl is set to 1.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
