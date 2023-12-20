Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C756E48CC9
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 21:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="FJT46v13"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=imf8/6WC9FTtpyPXFqBgRzMjEFw3RXJLJVRenxFZPfA=; b=FJT46v138jUyl7zwlYGo/mfK2x
	KY6UNYCkqgjr2itzAVYja2eImSaCbbzYMxxyCrfKjEeB6N8HSpV/NQwcV4vnUe3IBwNjxRWBkh2dr
	IjK920QAZlnSkKQBW4oWcn/9Z6wqxVwfD5sPJIELmjgyytnThbi+v54Jqov96zpg+9Y2AU8NAvVao
	47UjbN8NcHKe+fo0F6Zqpk7GH7qxg+FErt8tQpWJWbERn+zm7+UXVUqky/z3z/l9GkwYMtYaWeguH
	uTeo97Xi5THAaeeOW/BiJ9UjburYGxZ9jXw0eSi8LYlUMHOo//GvB1/7O6tZUTNF79G1bA6GbFWRA
	2MhRO3tg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rG46s-0008CQ-Hy; Wed, 20 Dec 2023 22:28:10 +0100
Date: Wed, 20 Dec 2023 22:28:10 +0100
From: Phil Sutter <phil@nwl.cc>
To: Jan Engelhardt <jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 02/23] libxtables: xtoptions: Support XTOPT_NBO
 with XTTYPE_UINT*
Message-ID: <ZYNcag8fj42t8ykG@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
References: <20231220160636.11778-1-phil@nwl.cc>
 <20231220160636.11778-3-phil@nwl.cc>
 <oo3101r0-0oq7-7589-nsp2-73np31n82291@vanv.qr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <oo3101r0-0oq7-7589-nsp2-73np31n82291@vanv.qr>

On Wed, Dec 20, 2023 at 08:07:41PM +0100, Jan Engelhardt wrote:
> 
> On Wednesday 2023-12-20 17:06, Phil Sutter wrote:
> > {
> > 	const struct xt_option_entry *entry = cb->entry;
> >+	int i = cb->nvals;
> >
> >-	if (cb->nvals >= ARRAY_SIZE(cb->val.u32_range))
> >+	if (i >= ARRAY_SIZE(cb->val.u32_range))
> > 		return;
> 
> `i` should be unsigned (size_t) because ARRAY_SIZE is,
> else you get -Wsigned warnings at some point.

Oh, right! I'll make it uint8_t to match typeof(cb->nvals).

Thanks, Phil
