Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10B07145B07
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Apr 2024 10:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829874; cv=none; b=Nzkp8qqejJt35MiIwVG0LqBE1Cwod4UpHTA1oIav9umWuCnLbPsYpg535SUPFpUOBkItG3YtlSTzmb6dLhyEYip0zby36xFGfpehz2FRr8s5tFMlDOxmhQVLpJk0CdLEA/gwSmLo3N6TDLxXnKA6+LiVK9l1VZsfnXu+XYiM/4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829874; c=relaxed/simple;
	bh=MhMW5MM68EFqnSHCF1xcqeGRl42+lOIqpJNyd3zT0sA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IKYXU3A/DZiTc+ZAK+GU2sQVZGwmoOEBbhidpr7EFlVgpimGeRr/dgHt4wt+8WsoD62m+vVSwHBui7ri0J2kF52SQZOIgsdmekeBgeVofjFNY42U4G/SS7ept7Pysdsbv0pyxMG7P5naGckCC8tAwC4Jy3x26mccTKIh66Ul180=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Thu, 11 Apr 2024 12:04:28 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ziyang Xuan <william.xuanziyang@huawei.com>
Cc: kadlec@netfilter.org, netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nft 1/2] netfilter: nf_tables: Fix potential data-race in
 __nft_expr_type_get()
Message-ID: <Zhe1rNYaJ2ehkFOt@calendula>
References: <cover.1712472595.git.william.xuanziyang@huawei.com>
 <15ed198f9be877a704af51b906cf2fd655d8590b.1712472595.git.william.xuanziyang@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <15ed198f9be877a704af51b906cf2fd655d8590b.1712472595.git.william.xuanziyang@huawei.com>

On Sun, Apr 07, 2024 at 02:56:04PM +0800, Ziyang Xuan wrote:
> nft_unregister_expr() can concurrent with __nft_expr_type_get(),
> and there is not any protection when iterate over nf_tables_expressions
> list in __nft_expr_type_get(). Therefore, there is pertential
> data-race of nf_tables_expressions list entry.
> 
> Use list_for_each_entry_rcu() to iterate over nf_tables_expressions
> list in __nft_expr_type_get(), and use rcu_read_lock() in the caller
> nft_expr_type_get() to protect the entire type query process.

Applied to nf, thanks
