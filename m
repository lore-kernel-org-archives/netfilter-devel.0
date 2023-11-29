Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="RiNFBHBk"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF5993
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Nov 2023 17:21:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3DxygCv+8aVToKW0D5DA7ZjMhELiaR7Q+J0uNfdyqG4=; b=RiNFBHBku4IvIhIYB3lESn0SbV
	gstmiPUJiQiTMPtAQHYVJrgmtlmKuqmfbUL4j/faoVgyZBX6cjUKDwgdXcXQSNa3z/T5fSsSWjzas
	XLbe+LpCf5Etv29ECGXtxqknNidjz9GTdZU7qxuuBtS/95tlqee6adKJXq8tr4GH4KDABDfduoMXm
	NLjbZX5VHluxPFupylcAKJsYW3rD628AjUpCQ4nu9wQ7cE+8PXU4p4KaW1a0yKNSlF5jLVGL9sP7X
	8AHoC0lbkEPX7UFFkHgWRX881S5z/wv0oBwik7buHpBp/6r/UOewQpU4M0oWR/U2g57zZgUtae5qY
	eQoPYv9g==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r89Gq-0007p9-As
	for netfilter-devel@vger.kernel.org; Wed, 29 Nov 2023 02:21:44 +0100
Date: Wed, 29 Nov 2023 02:21:44 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 0/2] libxtables: Fix two xtoptions bugs
Message-ID: <ZWaSKEVQ5NSzu2BO@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20231128212631.811-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128212631.811-1-phil@nwl.cc>

On Tue, Nov 28, 2023 at 10:26:29PM +0100, Phil Sutter wrote:
> While the first one is clearly a bug in my recent code deduplication
> effort, the second one may be reckoned a missing feature.
> XTTYPE_HOSTMASK is but used in many places and nothing claims the masks
> must be contiguous.
> 
> Phil Sutter (2):
>   libxtables: xtoptions: Fix for garbage access in
>     xtables_options_xfrm()
>   libxtables: xtoptions: Fix for non-CIDR-compatible hostmasks

Series applied.
