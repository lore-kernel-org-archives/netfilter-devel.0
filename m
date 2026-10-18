Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7DD1CAA6C;
	Sun, 18 Oct 2026 11:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792323913; cv=none; b=tzxMsCuhtkwAmrtkJikIhm9tRs1G25uKztF/RLoneHhe9x/TPiPYmucXOXMaX0/F18KMMxV01daCtqsz6nAXiUeS9cRkqqPpokcR+vCG2C67ytNPrS9UV3kwTUAOyN3zOJ/Ke8yekHsVgXezbrSIe+j2RjDd7UGB/AhQsodJC/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792323913; c=relaxed/simple;
	bh=Yw3j4GCVu5FumtK2jSX2GK8q+e05M1dQ2IWsdTeHlis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YaaNHRH40f9Gzq/OQ9t8zvLGd6Qoy9K0F6Xrb0gtfT46SEFSSP60ghTfEXnyi/rC96WQw2A1YJWqOrm3ERCCU4owmVrU0WHQimxt6Yxz0yvVh+9fizGLiGYRabE9kQzuFZ2KPw5UXvtyKgSnDxkeJJYXhueHTTgUz8bENVs2Vlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 345E460327; Sun, 18 Oct 2026 13:45:08 +0200 (CEST)
Date: Sun, 18 Oct 2026 13:45:07 +0200
From: Florian Westphal <fw@strlen.de>
To: Tamaki Yanagawa <ty@000ty.net>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf v2] netfilter: ipset: don't mask the element in place
 in mtype_test_cidrs()
Message-ID: <atSxQ6ZgJtcM_UAW@strlen.de>
References: <20261018052340.29588-1-ty@000ty.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261018052340.29588-1-ty@000ty.net>

Tamaki Yanagawa <ty@000ty.net> wrote:
> mtype_test_cidrs() masks the element under test in place with
> mtype_data_netmask() while walking the cidr array from the most to the
> least specific prefix. Since the walk is restarted on concurrent cidr
> array updates, the IPSET_NET_COUNT == 1 types (hash:net, hash:net,port,
> hash:ip,port,net, hash:net,iface) rescan with an element already masked
> to the widest prefix tried, so a lookup can wrongly match a more specific
> entry at the network base address (e.g. 10.200.3.4 matching 10.0.0.0/29).
> Work on a local copy of the element that is reinitialised on every scan
> instead.

LGTM.
