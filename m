Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793274046;
	b=W2xOChIVo1Cj/Y6dVPxsDTm455RiVD2Rq51v9N/2LbJ0GhGvIF0BQyClxNN6cvQUwrqL
	 kdYEKLNqjUMBMR7O0eTRYA0DLnxlHea+10RidvJFKHqQx/m16oHKAmE2WQI9101g91UHY
	 kAABP4KhUMA13Z42DpvLVrndRLVIm1lvVd7NfVd4HdlgI/GyK9Zcl0LKCpsrN4me86sWZ
	 O/gY5sAwkoXHz7cvn6hJ5wMVnRNvKswaDgptNBEpazylsIU4PmNKN+Y20l3tz+pGmCzb4
	 +IG1w0NM8pF3pgVK1ZIMdJftv61cicRzQB8nbNpPumcrMQv2cLbSTOgBUi0vCTLeeVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793274046;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=p2IOW7MFPGgqDFtAmA0JqmlzkchXS/NcWe2itULZTHc=;
	b=PkoSyIscUkZ2d7ndyu/ySm73ADgekYGMSLEtABm7xq/Ug0NinQqd1Ml9z8JF0GkSVebK
	 v07Esz7B+sHbVToSLDEag+c1/X//p7GLd31BXfxPT8H0qRf2HhHuxMIUOJNIIWk8fTxdN
	 KfMv+4xTcfji/aBpi4U0ukDJLZBgaXGgDOvJnh5LLdl8ORu4OnwXZz3+PKM/PJf9NpXcD
	 nl53XNRRYXXfX90fLyecuw5Soh9XFgcqWYCvr1ZV2hgn5Av7Rj9b2icD5sqIRpHRIOQ2q
	 GameO9ARy3TTZmf7IouIQQkIHYxuJ+tkIbF6z0+dQZribpuGBj4Xvhw01ClHuQ5m2LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=L6PKQjAx;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 115CB606A31A
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 11:40:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 115CB606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=L6PKQjAx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793274044;
	bh=p2IOW7MFPGgqDFtAmA0JqmlzkchXS/NcWe2itULZTHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L6PKQjAxILBOjPSfYvXA9SLZR00wkEb4IkRcNoIBlK60zYDAmBM6hJODhrDPSpRvo
	 7BVky0p9GAmyjYybk7BtSYpukT9cFvYeRNg4ZSlKKwRPm3R43xSeVFSvAVl7s51B0q
	 T3FRt+1YxNw2L11Rpcv9MW+kC/Vz8uw/iGbKT+953hSAWyBgi268X0Nhi0bSayI5De
	 DUncaSQM31zEedNV6wFOeQCV7qXv5x/YGG4nYf8mgL919hpffoNOypCz3WhrVRaU5b
	 h7b6Fzszouh5p6P56+vI2Dq3NHDvqL1Ocu1rFUcVeeyN9OEDzq0F1Gw9fG4rRnP0wX
	 MGbv9CwtGH/Eg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 313DF60082;
	Thu, 29 Oct 2026 12:40:44 +0100 (CET)
Date: Thu, 29 Oct 2026 12:40:41 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: netfilter-devel@vger.kernel.org, nbd@nbd.name
Subject: Re: [PATCH nf-next,v2 1/2] netfilter: flowtable: retrieve stats on
 flow deletion
Message-ID: <auMwuTTFuVLYKvOE@chamomile>
References: <20261029113405.180889-1-pablo@netfilter.org>
 <auMwW3OirtvvRYE-@lore-desk>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <auMwW3OirtvvRYE-@lore-desk>

On Thu, Oct 29, 2026 at 12:39:07PM +0100, Lorenzo Bianconi wrote:
> I guess you can add even the patch below.

Thanks, more driver updates are good :-)
> 
> Regards,
> Lorenzo
> 
> From c13752f12d74e35685f427f28659e8cd632d028b Mon Sep 17 00:00:00 2001
> Message-ID: <c13752f12d74e35685f427f28659e8cd632d028b.1793273803.git.lorenzo.bianconi@oss.qualcomm.com>
> From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
> Date: Thu, 29 Oct 2026 12:35:23 +0100
> Subject: [PATCH] net: airoha: update stats on flow deletion
> 
> Update this driver to use the new approach to fetch stats on flow
> deletion, introduced by ("netfilter: flowtable: retrieve stats on flow
> deletion").
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
> ---
>  drivers/net/ethernet/airoha/airoha_ppe.c | 31 +++++++++++++++---------
>  1 file changed, 19 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
> index 92611802801e..35750b61028b 100644
> --- a/drivers/net/ethernet/airoha/airoha_ppe.c
> +++ b/drivers/net/ethernet/airoha/airoha_ppe.c
> @@ -1285,6 +1285,23 @@ static int airoha_ppe_flow_offload_replace(struct airoha_eth *eth,
>  	return err;
>  }
>  
> +static void airoha_ppe_flow_update_stats(struct airoha_eth *eth,
> +					 struct flow_cls_offload *f,
> +					 struct airoha_flow_table_entry *e)
> +{
> +	u32 idle = airoha_ppe_entry_idle_time(eth->ppe, e);
> +
> +	f->stats.lastused = jiffies - idle * HZ;
> +	if (e->hash != 0xffff) {
> +		struct airoha_foe_stats64 stats = {};
> +
> +		airoha_ppe_foe_entry_get_stats(eth->ppe, e->hash, &stats);
> +		f->stats.pkts += (stats.packets - e->stats.packets);
> +		f->stats.bytes += (stats.bytes - e->stats.bytes);
> +		e->stats = stats;
> +	}
> +}
> +
>  static int airoha_ppe_flow_offload_destroy(struct airoha_eth *eth,
>  					   struct flow_cls_offload *f)
>  {
> @@ -1295,6 +1312,7 @@ static int airoha_ppe_flow_offload_destroy(struct airoha_eth *eth,
>  	if (!e)
>  		return -ENOENT;
>  
> +	airoha_ppe_flow_update_stats(eth, f, e);
>  	airoha_ppe_foe_flow_remove_entry(eth->ppe, e);
>  	rhashtable_remove_fast(&eth->flow_table, &e->node,
>  			       airoha_flow_table_params);
> @@ -1342,24 +1360,13 @@ static int airoha_ppe_flow_offload_stats(struct airoha_eth *eth,
>  					 struct flow_cls_offload *f)
>  {
>  	struct airoha_flow_table_entry *e;
> -	u32 idle;
>  
>  	e = rhashtable_lookup(&eth->flow_table, &f->cookie,
>  			      airoha_flow_table_params);
>  	if (!e)
>  		return -ENOENT;
>  
> -	idle = airoha_ppe_entry_idle_time(eth->ppe, e);
> -	f->stats.lastused = jiffies - idle * HZ;
> -
> -	if (e->hash != 0xffff) {
> -		struct airoha_foe_stats64 stats = {};
> -
> -		airoha_ppe_foe_entry_get_stats(eth->ppe, e->hash, &stats);
> -		f->stats.pkts += (stats.packets - e->stats.packets);
> -		f->stats.bytes += (stats.bytes - e->stats.bytes);
> -		e->stats = stats;
> -	}
> +	airoha_ppe_flow_update_stats(eth, f, e);
>  
>  	return 0;
>  }
> -- 
> 2.56.0
> 


