Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648245D8F8
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2024 08:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712131312; cv=none; b=qAp7mXc4ipnw1ZdOAjbXPXxb0D8H99Sw30kvBw49ZJ+sZAozp2c8zS2qoEXnFVFByLp7Q/yjgvXCcCUpVEWjjWKcmeRXL7CyxhN6hC0NJBesy9uLxMHCBBg3QiOtvmIf60+oK9oYNtWGvm5iZE3xCBwdY00wdllxlnkfkxD74UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712131312; c=relaxed/simple;
	bh=XIhZa1yU/PRgkEeQZaxzV7QFRAejVwFp+43Gz/HU68k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lRm8dXrwCaVXzKJESAAonmbPjLd9fw6Jl85y3VRGCKZ2dCI8bZZHfMhzXdBUiWfIBRRzbzik1xY5DlwwsnA2zUz/nUPFE8DQWJqVdTtmFaCqkB4J/hT+QJCYCz22SLX6PZoOL6Y+vn9kpjAmxZT3parxvaI6ep3iPpjExeVFqO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rrvZ2-0005Wq-F3; Wed, 03 Apr 2024 10:01:44 +0200
Date: Wed, 3 Apr 2024 10:01:44 +0200
From: Florian Westphal <fw@strlen.de>
To: Ziyang Xuan <william.xuanziyang@huawei.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2] netfilter: nf_tables: Fix pertential data-race in
 __nft_flowtable_type_get()
Message-ID: <20240403080144.GC26310@breakpoint.cc>
References: <20240403072204.2139712-1-william.xuanziyang@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240403072204.2139712-1-william.xuanziyang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Ziyang Xuan <william.xuanziyang@huawei.com> wrote:
> nft_unregister_flowtable_type() within nf_flow_inet_module_exit() can
> concurrent with __nft_flowtable_type_get() within nf_tables_newflowtable().
> And thhere is not any protection when iterate over nf_tables_flowtables
> list in __nft_flowtable_type_get(). Therefore, there is pertential
> data-race of nf_tables_flowtables list entry.
> 
> Use list_for_each_entry_rcu() to iterate over nf_tables_flowtables list
> in __nft_flowtable_type_get(), and use rcu_read_lock() in the caller
> nft_flowtable_type_get() to protect the entire type query process.

Reviewed-by: Florian Westphal <fw@strlen.de>

Would you be so kind to send followup patches for the other two types
Pablo pointed out?

static LIST_HEAD(nf_tables_expressions);
static LIST_HEAD(nf_tables_objects);

It looks like they have same issue.

Thanks!

