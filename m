Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CB53B3899;
	Wed, 11 Mar 2026 16:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773245659; cv=none; b=c3A0PFNxg9dyNgKdh0oVpBLi1ObB6I4sDyUy00Mi+e5ynpZKX/BLahbveYwhT50CT18gZjchMZcUDUNK5FtE7anIZbNgFJnK7du7w3cHmkNEPWh/CfUknHVYXutaXKoPOHwdGmDJeAX84LVY4in1xt2E/kRFEv2VGH5W5WjYqKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773245659; c=relaxed/simple;
	bh=c7bYE+nsB8kK50pfsuWbSTwKuW3mYLg8nIK36+IfBxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NpLhRuis6o1wt1lKMeQuABeZPUU/QZ+lfmes813zC87wxUrB0VYfoVQs0yu9WNIHFmg6Aae65PcxHfcKcfnDViKuJmXutKZ1dPBioGgESpmifb5NnplwDK+6tBX7YYU+bNrkEjb1/EfQjn108PNShaWNyKFK2fQA5rfq34iDMz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BNqDAJlY; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BNqDAJlY"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 35DFD60269;
	Wed, 11 Mar 2026 17:14:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773245654;
	bh=83pLPwEbopjSQv9qsfkD5DuxYCyEX12drI0Wxk/9Zt8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BNqDAJlYMPK8KdINpz1XeYElfGw1i2sS3cowaQmcndO+sDg43tJO7vgGzDtdY22gi
	 oQAtADvtME9fxvQNBFT2jaF+JEMvOYdtV/BU3Cdk5gUwnmpJyyKOUwD6A52X2p/hle
	 LLm+dqms2Rj7gFcDUtwHIvkAOHYP3euVThTwCPptBiGbNEj6bTedVBqBRBcf2bo1mQ
	 XdlquenKQ3djkCY+aBGqNRqNt+iHnKiFe1WJKmgakpiHSWJvtW6vlo00hFIQ4SQRey
	 j01+J68IBgWpsLhgAruHgVCQ7HzDVNYP8zbgMZeThUtfJF104geQ7PabeD5KZeTubj
	 Z6y/1e7he7uHw==
Date: Wed, 11 Mar 2026 17:14:11 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_flow_table_ip: reset mac header before
 vlan push
Message-ID: <abGU022ZrScARsiO@chamomile>
References: <20260310143933.354257-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260310143933.354257-1-ericwouds@gmail.com>

On Tue, Mar 10, 2026 at 03:39:33PM +0100, Eric Woudstra wrote:
> With double vlan tagged packets in the fastpath, getting the error:
> 
> skb_vlan_push got skb with skb->data not at mac header (offset 18)
> 
> Call skb_reset_mac_header() before calling skb_vlan_push().

Fixes: c653d5a78f34 ("netfilter: flowtable: inline vlan encapsulation in xmit path")

> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

> ---
> 
> This patch replaces:
> 
> "netfilter: nf_flow_table_ip: Introduce nf_flow_vlan_push()"
> 
>  net/netfilter/nf_flow_table_ip.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> index 3fdb10d9bf7f..fd56d663cb5b 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -738,6 +738,7 @@ static int nf_flow_encap_push(struct sk_buff *skb,
>  		switch (tuple->encap[i].proto) {
>  		case htons(ETH_P_8021Q):
>  		case htons(ETH_P_8021AD):
> +			skb_reset_mac_header(skb);
>  			if (skb_vlan_push(skb, tuple->encap[i].proto,
>  					  tuple->encap[i].id) < 0)
>  				return -1;
> -- 
> 2.53.0
> 
