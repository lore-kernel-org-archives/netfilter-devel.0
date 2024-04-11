Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DD871422C4;
	Thu, 11 Apr 2024 10:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829831; cv=none; b=AGnF3CIEx1+yUustyxjfM5DpM5ApRZTOpDK+ZiMe9nwXiGgUXsnSw8MVUr5wNq5OoB+f+iAMqYQMwF1XRvAOkjNvOhfQBRL3l1WOLeDfv9QhZaajBY+qYrvdQpRRQeAcc5LhrMBbNY5jxywnGyJfYnUScK2zjWjtK1aFner4vLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829831; c=relaxed/simple;
	bh=ML3zBeybpOgQWCGzh24R6m3eTl5ZHxEvxjsSpW92R84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I7A2VqW+5tDD8ccrStpnUynsHayRN3aY8muLKEBn0fLP0JQp8cYJ3vyKoFjhXfCakb+tvIjXYZ2egcCcwyCaY3WUDaR0L8B7aYjSwMSGH0L+5gxkU8J5byWX6T2yQ0dP1ooIGgGNbN5kynxFfcgABXlgCoWRMOgptSrUH+mgzuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Thu, 11 Apr 2024 12:03:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com
Subject: Re: [PATCH net 5/6] netfilter: nf_tables: Fix potential data-race in
 __nft_flowtable_type_get()
Message-ID: <Zhe1f1yfaFQDnLvM@calendula>
References: <20240404104334.1627-1-pablo@netfilter.org>
 <20240404104334.1627-6-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240404104334.1627-6-pablo@netfilter.org>

On Thu, Apr 04, 2024 at 12:43:33PM +0200, Pablo Neira Ayuso wrote:
> From: Ziyang Xuan <william.xuanziyang@huawei.com>
> 
> nft_unregister_flowtable_type() within nf_flow_inet_module_exit() can
> concurrent with __nft_flowtable_type_get() within nf_tables_newflowtable().
> And thhere is not any protection when iterate over nf_tables_flowtables
> list in __nft_flowtable_type_get(). Therefore, there is pertential
> data-race of nf_tables_flowtables list entry.
> 
> Use list_for_each_entry_rcu() to iterate over nf_tables_flowtables list
> in __nft_flowtable_type_get(), and use rcu_read_lock() in the caller
> nft_flowtable_type_get() to protect the entire type query process.

Applied to nf, thanks
