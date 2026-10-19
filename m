Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2124D0A05;
	Mon, 19 Oct 2026 10:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792405865; cv=none; b=I/NKs0Z5ckO40MrnTg9gPKLi46iZD8BPbaovlQgSgiQfMqLct6uWqs5H2fyaYEQwRnaj4IPRcJ77F5qgfzNtz5dyUMI8ne+He6RDtLPdTbEUYlkXPQcYDYClRty+LAORNfvjBnhCaRAoGApYTJQPtfHnr2LpH/EPGfmSUPg8Ky8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792405865; c=relaxed/simple;
	bh=WQZlI0/sH+8IkLVfZU7CMtqfMOyABytUBHzPenU7Sew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L1+2wvQ4mu7HuAAUpA26iw81y2UKXPX91lD3UIx5ENmHwNtxn2k5oiNlApLwsLvRddhe45SDfyPJq1vHh4VuOsWG5aKXFwsm86eFkUDPXQSIbbQbVNHy9c3xWnwG4GWkvvHe8G/Nz6RNEWrUwa1x6pfh1UDgiB7jJTxEUjGeYeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NekOM6fW; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NekOM6fW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792405859;
	bh=xbdQdXfKvFLcY5vmWZj6WKHa1gFtQmvLf1E0ZBvhzhU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NekOM6fWP8THWtr5fwuqSNYf1Y8lyMcPn2QG3WPqSdBXkvrGBSg+Oll7nffSAPijQ
	 DqDdTOcWKo1M4d8OF1wOY/BsJWlaPF6UpKgByz9WpVSwhAnbJhz5fVl7JLNJBztlM6
	 Tkm/69Vl8s9Lw2vYS8pwq2EnYQmaajm28yKzA/0Tyv3un/N84epKrrgbym8WeTlIdL
	 BPB57sXxfN2aZdk0zOv2ygwxgBHu19VAIuz+Dwv+Qhb0HqYUqmpDydkRIwn/V3svbj
	 5zx4QGTQ+NgVZCFeSIhFM9DDPoyWHB3dJMxdsfp2+lSTHF9SVCZsmB3ZXMK36DA7vD
	 8nNQ2iuweTgcw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 8EB2A60094;
	Mon, 19 Oct 2026 12:30:59 +0200 (CEST)
Date: Mon, 19 Oct 2026 12:30:56 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Julius Bairaktaris <julius@bairaktaris.de>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc,
	coreteam@netfilter.org, netdev@vger.kernel.org, wenxu@ucloud.cn,
	saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com
Subject: Re: [PATCH nf v2 1/2] netfilter: flowtable: fill the vlan key from
 the outermost tag only
Message-ID: <atXxYLFOijwbFXqB@chamomile>
References: <20260906141947.480524-1-julius@bairaktaris.de>
 <20260913104251.648421-1-julius@bairaktaris.de>
 <20260913104251.648421-2-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260913104251.648421-2-julius@bairaktaris.de>

On Sun, Sep 13, 2026 at 12:42:50PM +0200, Julius Bairaktaris wrote:
> The else branch of the second encapsulation block stores encap[1] in
> the vlan key whenever the first block left it unfilled. The first
> block skips encap[0] when the switch strips it, and also when it is
> not 802.1Q. In the second case, an 802.1ad tag outside an 802.1Q tag,
> encap[0] is still the first tag on the frame and the key describes
> the inner tag as the outer one.

There are only checks for ETH_P_8021Q in this codepath, no 8021.ad.

> Store encap[1] in the vlan key only when encap[0] is stripped. The
> 802.1ad case then gets no vlan key, as a single 802.1ad tag does
> today. The action list is unchanged.

How does this work?

        if (tuple->encap_num > 0 && !(tuple->in_vlan_ingress & BIT(0)) &&
            tuple->encap[0].proto == htons(ETH_P_8021Q)) {

in this case, FLOW_DISSECTOR_KEY_VLAN is filled up using
tuple->encap[0].

On top of this:

        if (tuple->encap_num > 1 && !(tuple->in_vlan_ingress & BIT(1)) &&
            tuple->encap[1].proto == htons(ETH_P_8021Q)) {

in this case, FLOW_DISSECTOR_KEY_CVLAN should be fill up, if KEY_VLAN
was filled up.

> Fixes: 3e1b0c168f6c ("netfilter: flowtable: add vlan match offload support")
> Assisted-by: Claude:claude-fable-5-1
> Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
> ---
>  net/netfilter/nf_flow_table_offload.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 801a3dd9ceea..19adc6c7725f 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -137,7 +137,7 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
>  			nf_flow_rule_vlan_match(&key->cvlan, &mask->cvlan,
>  						tuple->encap[1].id,
>  						tuple->encap[1].proto);
> -		} else {
> +		} else if (tuple->in_vlan_ingress & BIT(0)) {
>  			NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_VLAN,
>  					  vlan);
>  			nf_flow_rule_vlan_match(&key->vlan, &mask->vlan,
                        match->dissector.used_keys |=
                                BIT_ULL(FLOW_DISSECTOR_KEY_VLAN);

IIRC, in_vlan_ingress means "skip" because pvid has been hardware offload.

Why this new check for tuple->in_vlan_ingress & BIT(0)?
