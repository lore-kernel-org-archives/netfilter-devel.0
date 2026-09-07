Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138814657C6
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 18:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788805194; cv=none; b=YsPg5Hp8H9EU+OBFVu2Aa8GkL81dYIB7oMReW9lAPt4h5U6Ugod3RJaKnU1zhwQ/Z4M8RKWedF2tNbwkbAfJJUEsogzMZnCdDhgJPTK9AEhyJzUPHxbT7DRfk0Yhc2jYqzcLIs3T483dtmLyefBOp7rV/X8odgeGqUTsczlfyfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788805194; c=relaxed/simple;
	bh=ld8j1LbkhQ4yMlx+8fPJDd6CeFLLKyblD112CLHA85Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y5z7vK7GMT+9g45sMmboTai2kVYsgKiLafs3yKJRpEa7SL6TrlZdQk3QNaKC/L0QM/3H9f2gRV/TMNxRVKlmuMxLrvGTj2WZ9dfMOuLy5eRY0SwHBE9qte3CiZ8PYOC13Sx0eZMsIHTjRZN+0C+5mxOqj5HtqAfbUOVuM3b+ruQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WXflyt+6; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WXflyt+6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788805189;
	bh=B36RDM4fPTVXnfJE99VpQBSKYvAkjK8ScIvgSlWF5BI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WXflyt+6p3jNggvBwpWFrJly1Jx6cRMlpnYHTELj9V7Pdlmz7vi/8DAUrPnluofoR
	 EasqqpqiUci3nGBH3vR2kV+7oyIls4kqLncBhd1H7lbSSwJcWFA4pduYF/hoI4ch+o
	 3Oy6RY/i/vKZokctI9FHQJShfzT7HRQwrvXby7UgEcm1NUCU7V4XrmPTtYEJBnzU/R
	 nshm7qA6pGGRa0IjR7QhVPmpzciIRz0cFlab4Ye5Np9g3ZlmzhdOCOSdAZCO1Lh0TA
	 FBlKazyAF84NQERvIahvFCIV5iHY2mAxWId+h0iMdLk7reRXjmpWPO6jB4Hgmhid6t
	 7wZSihMHr+kbw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 6A5AE6065B;
	Mon,  7 Sep 2026 20:19:49 +0200 (CEST)
Date: Mon, 7 Sep 2026 20:19:47 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH v3] netfilter: nfnetlink: Fix for interrupted hook
 dumps
Message-ID: <ap8AQ1DCUET8Ggkd@chamomile>
References: <20260904125215.1272252-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260904125215.1272252-1-phil@nwl.cc>

Hi Phil,

On Fri, Sep 04, 2026 at 02:52:15PM +0200, Phil Sutter wrote:
> @@ -338,27 +337,47 @@ nfnl_hook_entries_head(u8 pf, unsigned int hook, struct net *net, const char *de
>  }
>  
>  static int nfnl_hook_dump_nat(struct sk_buff *nlskb,
> -			      const struct nfnl_dump_hook_data *ctx,
> -			      const struct nf_hook_ops *ops,
> -			      int family, unsigned int seq)
> +			      struct netlink_callback *cb,
> +			      const struct nf_hook_ops *ops, int family)
>  {
>  	struct nf_nat_lookup_hook_priv *priv = ops->priv;
> -	struct nf_hook_entries *e = rcu_dereference(priv->entries);
> +	struct nfnl_dump_hook_data *ctx = cb->data;
> +	struct net *net = sock_net(nlskb->sk);
>  	struct nf_hook_ops **nat_ops;
> -	int i, err;
> +	unsigned int i = cb->args[1];
> +	struct nf_hook_entries *e;
> +	unsigned int base_seq;
> +	int err = 0;
>  
> +	base_seq = smp_load_acquire(&net->nf.nat_hook_base_seq);

Maybe annnotate this base sequence in the .start via:

struct netlink_dump_control c = {
        .start = ...;

We should probably start doing this in other nfnetlink subsystems too.

This will help catch an interference between two netlink recv() calls
which results in calling netlink_dump() which calls this function.

Let me know, thanks!
