Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794836361;
	b=xPELSRzWmaaleShNLK/qvnxvbrpq8gQoFtu+OddfenabKpWfNQaOT7lJL66CuewhScCF
	 VDw/yGJmZvQPZ3HYoW+PW+69Cfk2N9KeklUys1eQEx7g00lfsEJeKTDxh2cUq2T9U6eIw
	 YRpfi5TKnl7JXOwNPdSY4AelknTw6I2C09y/1apHQt/TjVWxTdTZTrwrAOyf70k6VwLQa
	 VON1In7z6+xHr3ArTO+NWjJoDtbv04jic9eHHx8nfxzuiDeWXKZF0zOt1MT2Yv/K2yO43
	 OzcVsANC18fGBOx0IR4L0dme3V2OuN3v90Z2xs2gwFrpTXlv+mDwZB040mC9acg9umw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794836361;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=n59qOTV8SxlKRlydmx7eBhuK9SYOiSwbIO+6MI483OY=;
	b=APO5OSd52XvY/Ke4frDDMc73mZc/W+sKYU0VkTuggaZCZW1ugO9M1xibaz+eZ5ztmBcs
	 pt+vQb7lXV8FyRrVHkmd6zHHQqm9hO9L2rL+m9XL+nCGjtxnosNxEbtYeosvDnnF8S4VS
	 Euiqt/diI+1UhGk2QnF95MjsdbTeDlyWQt/L4G+dFhxgLxlfb4xr09HYig5a7n6eIUyXj
	 1PWItRZzQzFPEuktgP3Bx68S6nE1NLAFAUN7nkC5Civdec/NjmjFKK8IYzK8vuLXNCxA8
	 FtDdp3OVfYhl95A2a67hB+v/bKFIxg1pmEWBGQClcmQBOxj/eaOB5GJdAXpSCtB1jYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FBA606A323;
	Mon, 16 Nov 2026 13:39:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1FBA606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 98E0460342; Mon, 16 Nov 2026 14:39:18 +0100 (CET)
Date: Mon, 16 Nov 2026 14:39:16 +0100
From: Florian Westphal <fw@strlen.de>
To: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_dup: unset mac_header on the duplicated
 packet
Message-ID: <avsHhMbvwwfcI6_b@strlen.de>
References: <20261116105113.128791-1-theodorlarionov@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116105113.128791-1-theodorlarionov@gmail.com>

Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com> wrote:
> nf_dup_ipv4() and nf_dup_ipv6() duplicate the packet with pskb_copy(),
> which leaves the headroom uninitialised but keeps the mac_header offset.
> On LOCAL_OUT and POST_ROUTING, an nft payload read of the link-layer
> header of the copy loads those bytes, and a set element can return them
> to userspace:
> 
>   BUG: KMSAN: kernel-infoleak in _copy_to_iter
> 
> Unset the mac header of the copy, as for a locally generated packet.

Why force users to work around this?  I think it would make more sense
to __pskb_copy_fclone() to check if the copied mac_header offset is
now in uninitialised headroom and then resets it.

Otherwise we might have more places that need fixing, resp. will
re-introduce this issue in the future.
