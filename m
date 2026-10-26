Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793020486;
	b=tuPvbfXFHUPVAhDjbJgvD8OXn2LiedWM5VObIdL4WHHkumslPZ6PGlddedunHQEY2biP
	 CPqyxBlCsZvrIt1GfrOrq8Cu9ov98pbxW5dN0OeaOMpbN8ApjcTmRmuQVvp8U18S5bZzV
	 GfNQ7FeplM+44s+dvpG5+SlWLUQFtaisgq+qMQY9Tk9d0MyEOkecCEeANu4LmI+NhEbty
	 tGcP+H2TvpW6GjRynfFh9BSddSBhk3he897Ec3tE84tSAw37rszoxuJ44P+yPoWX6K/Au
	 Zu5B4yiGbf0d/JmLPrTlO7c/cPul7OH6MnE5H+/7bVbU4h4I/LSAHepieMeLOtn6+0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793020486;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=AwWJ4z5We8tw8FtwnrIHYZkIJ87KPPmSVapZy9yZJ28=;
	b=z3okPEOM32i7i/0LSdpa5a46gGpJBXSw95lYA4rYeWwTW/6544ApFqu6K4urUx4BxZDa
	 k1P8ojadwPMkWpxQJcFm4CE6JOZulc++6SEBahL8U5TrgJslghL+TEvYFEfcW3R1TwU0e
	 BJ9mAbzi6+IIlnykUjyEU1zUf89KNU5hMYeQM1D+HW+CIgaiCkSuuaS1fVLYlWbY5zM00
	 Y26UG2J/VgwlTb3ETW0CRzvuIeC3amsYieU4r5vgXLkcBPOTaeJ6fy1oydBAZ8akSilEd
	 uhvMztN5UQQT+28dp2u76P03PR1xWpQpz3Ocp8ougjYViXSsw6Dj+Xo1Y3zSXqXv2RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98925606A327;
	Mon, 26 Oct 2026 13:14:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98925606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D9A83603A1; Mon, 26 Oct 2026 14:14:35 +0100 (CET)
Date: Mon, 26 Oct 2026 14:14:00 +0100
From: Florian Westphal <fw@strlen.de>
To: Fang Xieyan <fangxy@xiaopeng.com>
Cc: pablo@netfilter.org, phil@nwl.cc, davem@davemloft.net,
	edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Weibin Liu <liuwb@xiaopeng.com>
Subject: Re: [PATCH] netfilter: xt_policy: add NULL check for skb_dst() in
 output policy match
Message-ID: <at9SGAuHjV3OjFKZ@strlen.de>
References: <20261026125313.14810-1-fangxy@xiaopeng.com>
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
In-Reply-To: <20261026125313.14810-1-fangxy@xiaopeng.com>

Fang Xieyan <fangxy@xiaopeng.com> wrote:
> match_policy_out() accesses dst->xfrm without checking whether
> skb_dst() returned NULL. If no dst entry is attached to the skb,
> this dereference is invalid.

If there is no dst we'd have crashed already:

        return nf_hook(NFPROTO_IPV4, NF_INET_LOCAL_OUT,
                       net, sk, skb, NULL, skb_dst_dev(skb),
                       dst_output);

likewise, okter in ip stack:

        if (lwtunnel_xmit_redirect(dst->lwtstate)) {

there are several other places that don't do NULL checks here.
So either all of those need them or none at all.

