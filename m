Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171825F84F
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Apr 2024 10:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712055417; cv=none; b=pB8fPxrTKZHkGOANyG/OYJTnfETVrXKM1uDtaJdKBQH9iySYcXiO+rby+LqL8/KVONswlNF1yX9BYD8w1tilcrrl27XCB1Jq8IaE6QmFdlrqNg1aCaKmaWssnFHb8G25yPd8X4EG8O5EvtJUgBzFzfQa83ynqt/iZhxEJBfAhEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712055417; c=relaxed/simple;
	bh=9kSLg2Ry1gsAD9ti1W0SBxrGBNBMklXXJWFUie/vsPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SrPVZFCqqV1PeTxH4doUrslpq7BPM3/uILhXEvNOY5ttyEzPqzyhFUAzC0fzy8a+PNvZbvxEtpKTcMHEJ1DvqUUfSPGPNUuolaXq7TQyHwjyMs7tfRpJmEWKBwmksKUPcK9WH45x+uV7mO8RqFL0t0GgVokIOLUnEcegHJMDRUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rrboo-00051K-MN; Tue, 02 Apr 2024 12:56:42 +0200
Date: Tue, 2 Apr 2024 12:56:42 +0200
From: Florian Westphal <fw@strlen.de>
To: Ziyang Xuan <william.xuanziyang@huawei.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] netfilter: nf_tables: Fix pertential data-race in
 __nft_flowtable_type_get()
Message-ID: <20240402105642.GB18301@breakpoint.cc>
References: <20240401133455.1945938-1-william.xuanziyang@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240401133455.1945938-1-william.xuanziyang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Ziyang Xuan <william.xuanziyang@huawei.com> wrote:
> nft_unregister_flowtable_type() within nf_flow_inet_module_exit() can
> concurrent with __nft_flowtable_type_get() within nf_tables_newflowtable().
> And thhere is not any protection when iterate over nf_tables_flowtables
> list in __nft_flowtable_type_get(). Therefore, there is pertential
> data-race of nf_tables_flowtables list entry.
> 
> Use list_for_each_entry_rcu() with rcu_read_lock() to Iterate over
> nf_tables_flowtables list in __nft_flowtable_type_get() to resolve it.

I don't think this resolves the described race.

> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>  net/netfilter/nf_tables_api.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index fd86f2720c9e..fbf38e32f11d 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -8297,10 +8297,14 @@ static const struct nf_flowtable_type *__nft_flowtable_type_get(u8 family)
>  {
>  	const struct nf_flowtable_type *type;
>  
> -	list_for_each_entry(type, &nf_tables_flowtables, list) {
> -		if (family == type->family)
> +	rcu_read_lock()
> +	list_for_each_entry_rcu(type, &nf_tables_flowtables, list) {
> +		if (family == type->family) {
> +			rcu_read_unlock();
>  			return type;

This means 'type' can be non-null while module is being unloaded,
before refcount increment.

You need acquire rcu_read_lock() in the caller, nft_flowtable_type_get,
and release it after refcount on module owner failed or succeeded.
