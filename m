Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8D0455611;
	Fri,  2 Oct 2026 21:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790977466; cv=none; b=U4sm/oSwDiYjWRUotfWUZEEbB6eAywtnuxfyLD9sQHv3P6YWnnPHFpoK6sknNgW4Lj2tuJ56Uq1fq0kEsYil04RBTGLut77ZP0h/JReJciBG0L9LR7We43l9BpCwRnU+SjcqY5kiVqn0EVobDojSuy/TaaczhkpSFfx+rBndHII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790977466; c=relaxed/simple;
	bh=9RGTRpNPd/6X0sypx+Yr5sGDj4lXG4j5EEHzCi/zjmU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ct7M15d1fSrJ0vS0HQVxegRaZFMf1x4wHDbTHZtK+IbjbiDoOxO+X4N4Fc15IknLq9NUqrbKW4kPVTIpWNLLdLB1VyJgGwVHjUhs0nRxvwEp4eWoZSr7SEcuI5I7Icl993heJmK4gSmoIfkhkvsP3AXnq26WNg4/2rnjcd2gJpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YVWe7Oki; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YVWe7Oki"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790977461;
	bh=hdVyv/40uQ4naL3CAjN+tX/9jkvgOZ+b/3RwURBmVVk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YVWe7OkiYL3SZNsIufi1QgjrqmP11JErPZ5pi0igL5K8j6TmtJfvFOIxdQVIkt/vs
	 yjVzas7dVNsCz1luqdJ50pRdtBOLXDx9F65PlOpdX6k1JgQTtsf5FdEPB9msqJWhDk
	 L+RIrFeeipN6pWipnwNx18B3tbm6kHv5Knir+SjzaDXCNVrFr1khUaumlFqokd3+a4
	 L9r4o2nEn8lLxBgm+ULb6q6/nN0qhPCKAcNsWILRWJkF91EoVX4Yqp7N30wTYscDFx
	 s6J8ytFxTTDoYPg/PEfcNsfqU6nc/nlKI/RdZg1mF2K0RNZffT9dHXv/jQlYhRkzy2
	 gZONLTDbRhQ6A==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id DA7C160055;
	Fri,  2 Oct 2026 23:44:20 +0200 (CEST)
Date: Fri, 2 Oct 2026 23:44:18 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	stable@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ma Xinmeng <1564938642@qq.com>
Subject: Re: [PATCH 6.1 1/2] netfilter: nf_tables: allow to create netdev
 chain without device
Message-ID: <asAlssf9FAAFi4m_@chamomile>
References: <ar4d_JbuojZJuazs@chamomile>
 <tencent_3EF2E566E214C1068698C581DE374E1E3C09@qq.com>
 <2026-10-02-1-daily-reply-0008-re-nf-tables-netdev-chain-6-1@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2026-10-02-1-daily-reply-0008-re-nf-tables-netdev-chain-6-1@kernel.org>

Hi,

On Fri, Oct 02, 2026 at 05:10:34PM -0400, Sasha Levin wrote:
> > This is a 6.1 backport of upstream commit 207296f1a03b; the hunk for
> > nft_delchain_hook() is dropped since that function is not present in 6.1.
> 
> This series only brings in the prerequisites. The UAF fix itself isn't
> in it:
> 
>   fc0133428e7a ("netfilter: nf_tables: Tolerate chains with no remaining hooks")
>   375f222800bc ("netfilter: nf_tables: Simplify chain netdev notifier")
> 
> 2/2 also adds b9703ed44ffb ("netfilter: nf_tables: support for adding
> new devices to an existing netdev chain") to 6.1 without the later
> fixes for it, none of which 6.1 has:
> 
>   043d2acf5722 ("netfilter: nf_tables: drop module reference after updating chain")
>   7eaf837a4eb5 ("netfilter: nf_tables: Fix a memory leak in nf_tables_updchain")
>   1e1fb6f00f52 ("netfilter: nf_tables: reject table flag and netdev basechain updates")
>   216e7bf7402c ("netfilter: nf_tables: skip netdev hook unregistration if table is dormant")
>   688c15017d5c ("netfilter: nf_tables: don't unregister hook when table is dormant")
>   4ffcf5ca81c3 ("netfilter: nf_tables: use rcu chain hook list iterator from netlink dump path")
> 
> It also needs the netdev chain parts of a6134e62dba2 ("netfilter:
> nf_tables: join hook list via splice_list_rcu() in commit phase") and
> cf5fb87fcdaa ("netfilter: nf_tables: reject duplicate device on
> updates"); 6.1 only has their flowtable parts. Without 043d2acf5722,
> every base chain update that carries a hook leaks a reference on the
> chain type module.
> 
> Could you send a single 6.1 series in upstream order: the two
> prerequisites, the fixes above, then fc0133428e7a and 375f222800bc?
> Please start each patch with its "commit <sha> upstream." line and add
> a cover letter. An ack from Pablo or Florian would help too.
> 
> 5.15 and 5.10 have the same UAF. Are you planning to cover them as well?

Yes, I am collecting backport patches and preparing a batch for you.
