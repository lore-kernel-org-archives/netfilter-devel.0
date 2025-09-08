Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A492DE6ED;
	Mon,  8 Sep 2025 21:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757365582; cv=none; b=MSmp4Uldi4mWxtMechxxwrJXj+2yTu/z0Ccj33PGIJXQH09/Z+RjZ1r1gWjJMAfsWFmykoOO+CjLyf51dV1nfX5czd9OUAqTHWsAh4oTebjt4D3BWlYh3XoVqNd5mmY0N8ojLFe35/PRuIzB0ZGld/RAbWbPDrS1LXegXinGyY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757365582; c=relaxed/simple;
	bh=skMd7msa/+1SKj63XnhhBq4ol3lcANpfSVnZq7Mzbcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f51PKuNvM9XD1LcsyfCRCnqvBTShO6jS8vuDROGHD4IpzuhQNnoQTRyNAfS5Ky2562XQmcL7KypoesYEf5X8WzvlNAvzyOB5E5e6y0L8ykwG2OI6jlhygu2Y61FJa3mrvLGWw2SMFJRhy9T4F5NgmZCVqNy4lp1N86NxhMoVOvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IVEOjJEo; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TptDO3T1; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IVEOjJEo";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TptDO3T1"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 6BB0E602C3; Mon,  8 Sep 2025 23:06:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757365576;
	bh=10XXWkBGzx4kz8xLsmRTsu71MTe4Hm/S5vyY8l5rJdg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IVEOjJEopylyIxT3wo3yC4QoRtsoyuu6mb/dfzaDNWVCvP1kVJaNqIhWStjtUZehQ
	 WPNEAp5O23c4p3k+5CY7vrt/PRF5YRl8ffztrAbCEdn17PHVVRVNCPkjcm8oSqACnt
	 zwaKCsiq3zCy00TOJ/SmLhMAFc5SvsIrkLt6QGRm9M6H/RchMDQ7D+ONNsY2V8PHYP
	 3w8FQKLLO5guPOnsV+c9r8Ivco1KIy6GB4Fmr3qGQoSqNRXjqGvDKrZKJIKRINl5vq
	 6SoG4oYYjMWt+kpjtJIIKGRgUcf2mdmXyPQnuQNmSYTs9XhfpZ6cciF2U197sTtAK1
	 BH+ao4A3QECog==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1DEB1602C3;
	Mon,  8 Sep 2025 23:06:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757365574;
	bh=10XXWkBGzx4kz8xLsmRTsu71MTe4Hm/S5vyY8l5rJdg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TptDO3T1M5DJ3qdCsnFn5z2+apdieQ6PPcMlI6BV+XzUskl7fGvprQyRINEmSOC6y
	 XNfVhebUjSe29mvc40hcEzM3Tf45rtMSM2yGckoRgKg+goPDnqNcIjoMNHlLExwvar
	 VAoyGZ8yvp/s9BQv19wIJ+NAaBcMAuUGWZx9XLTEve7Md7tPh6V54HaDogbqZMKoJQ
	 7nVLN2L7QlQ3Z7ZSFKwjAvbKW3bq9dMrDAf/RXfq614w1NNerZBOVI/Rys+BxX2Hnu
	 8MuwMMeYBzjZLkpoqcP+PRl6S7wR6WUE524QXjXSstTQbeAtdUammZr1Omdnd1+bn9
	 FzndmVGityOaQ==
Date: Mon, 8 Sep 2025 23:06:11 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 nf-next 3/3] netfilter: nf_flow_table_ip: don't follow
 fastpath when marked teardown
Message-ID: <aL9FQ47keDNxygQw@calendula>
References: <20250617070007.23812-1-ericwouds@gmail.com>
 <20250617070007.23812-4-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250617070007.23812-4-ericwouds@gmail.com>

On Tue, Jun 17, 2025 at 09:00:07AM +0200, Eric Woudstra wrote:
> When a flow is marked for teardown, because the destination is not valid
> any more, the software fastpath may still be in effect and traffic is
> still send to the wrong destination. Change the ip/ipv6 hooks to not use
> the software fastpath for a flow that is marked to be teared down and let
> the packet continue along the normal path.
> 
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> ---
>  net/netfilter/nf_flow_table_ip.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> index 64a12b9668e7..f9bf2b466ca8 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -542,6 +542,9 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
>  	dir = tuplehash->tuple.dir;
>  	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
>  
> +	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags))
> +		return NF_ACCEPT;

nf_flow_offload_lookup() already checks for this bit, I don't a
benefit from this re-check.
