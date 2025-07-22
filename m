Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFEE1B4242
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Jul 2025 01:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753149243; cv=none; b=RhZBumhVLH2tJ0uJy+dipzasrMEQ2RUeTMgj0bNaUnn2/0jXSDj2MWVdsMgV2xH+Ya2d7x1bukVTkcugFZ8eIRnTu/sjytksxyFAo7LLbs2dKCnZNypWfwSrEUYExpg8axhnqLIIQ72BNp+fk7NmofY0gSdN4l24JwZsDibrFEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753149243; c=relaxed/simple;
	bh=5Y6sk6JvvtvioBqDj3FWG7xZicHdBT1j86xFxhTHPwI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AdVC6IvTfnLF1HMHo1NNxTpnD9U/w7M58e0amxkvgApVnlsXOws/8KCVtjcJakdQwxFHsF6IYo9ZG1YixvApq4JEvO00tCLtVNJfJl9eyiC37KNCLP6XwaBxcJQq+fd0xBt9Ag2VXt5n6D811IWddpoebx5bhXknQlQBVH5Pc8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QVMBTBPC; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FjfZyUqM; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QVMBTBPC";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FjfZyUqM"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 152456027F; Tue, 22 Jul 2025 03:53:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753149232;
	bh=qe+vUQdtGDIOAxDWs804KThAJWJ0H+HYiZ1Oo4syPoE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QVMBTBPCidzb24Pbt2CH7QHZK5HdzLOa1ebrTHnxDsHyczLNbqqgWGcv2m907rkJF
	 3c2ClxAqzI9vrtIvz+/TC+0p+uaIMc1tVNubC20yO8GPHP8t3ACgi7D9wkaS1CZ4iQ
	 biV6siuwFbetDESxO/Eoa0EL4/3/75S5ZlGIjfqZL2MJsHdvUmgjsq1UU8lYZaoNAB
	 W4fET3l6lB1OXbKsoeGOber+vBmSH/0fUMEaBl/XQVwB67IDuptoTYXdDbSNqGPJRj
	 WGuJjaJt+/E/Cov2QVCuncWeZJMoLaFa3rz7gawgRbUhplp2qhTQEW8NElYHtljOv4
	 lnTtqg34vC4CA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7B79E6027F;
	Tue, 22 Jul 2025 03:53:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753149230;
	bh=qe+vUQdtGDIOAxDWs804KThAJWJ0H+HYiZ1Oo4syPoE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FjfZyUqMqB9irjdrMX+9w0EDKSZsFVrZvDvl50lb584FxeuDS9iMH8YOYosAOuvao
	 dLGRztPN78EtxrIadx/hPOsy0LZcm1Grbv/tn7iU3WbiXpSokU0m5r+caoHK3y13fi
	 Y/qeXoGRyqGuv0eUu9GOO7OHX1qqDa6EdiWcbLNtbdIZ/phkW+l1wwN6z/eXIATmFe
	 dvx4b7msJt5lkDDqPy3uj990iWjxj/i6H94VUbm+kXnHGIQPuGccVcAw8w9NW6A+xB
	 dMA8QrTVBZ3b6OZ6ENw2DCHrG1aqVrPECO4H1CLPkG2TP89AjoKgBeJxHy2wcdYpb6
	 lNRtPWSkBx38Q==
Date: Tue, 22 Jul 2025 03:53:46 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] parser_json: reject non-concat expression
Message-ID: <aH7u7N4VQzIh-4zb@calendula>
References: <20250721110959.10322-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250721110959.10322-1-fw@strlen.de>

On Mon, Jul 21, 2025 at 01:09:55PM +0200, Florian Westphal wrote:
> Before "src: detach set, list and concatenation expression layout":
> internal:0:0-0: Error: Concatenation with 0 elements is illegal
> 
> After this change, expr->size access triggers assert() failure, add
> explicit test for etype to avoid this and error out:
> 
> internal:0:0-0: Error: Expected concat element, got symbol.
> 
> Fixes: e0d92243be1c ("src: detach set, list and concatenation expression layout")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
