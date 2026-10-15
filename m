Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EA6502790;
	Thu, 15 Oct 2026 10:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792060672; cv=none; b=CCawW84/VHyHVC+OIkrXpwHdL2D8sFM+WObjuRIF15dxAybjAKcZhfImFCpP4xkpCeM1pK2ysBKA7AIEqh7OuUbyQhuTEv+c59hCjZz9Wz8a77f21yFsIiRGwV7sYP6WNpiTIVVHpWU1Hkn2YuMS8iwoOOpZmzmR6SOa+ryuats=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792060672; c=relaxed/simple;
	bh=pi1spHJrkmpthoLfYy09/FDeB23hvcdEhXdU/TPtt+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L9XDB1ehHB7Bl8MlY8Fbn0fBwquHmkr9puzzGgGutfJtQop0sOdIoZYVkspsmRcbLlMs24CwU2qRhPY1oI5cHrigZHH76fEpgdCDrTsRvbPsF2peTFt6lD3WqEq/2NuQDrOciKEkxPmgtpoBCD+RnZ7kF7qRA3LXOam/83X59yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gh2+J9kB; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gh2+J9kB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792060668;
	bh=x1hTOdx9HBwQjS6C/jhkTLQ0ZT4WclQ+JGizpYah/yI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gh2+J9kBcDUzR6Em3XBL8H7KwQoVn2ySnfvdMZ0CfcTSOU8jqCIg9UzZYEOGpceEi
	 N4864J4TR8KVbA+9KLp5+Rt2O08n68WsZ/fqsGQbiP/ZxT7gCnZGiSjpxCZIoEgcEc
	 hoxGs4LqNWytQzxWrZUhA3JeSlVdjZaUtNb1MiMAuYdAlL5MK79OSdLjmWSsJRSRWR
	 4Lt6sc+mTO6FbZuBIs8Pi7bigLeczAMqtKHMx5/TNI5YS7VLUn12VjR680cHN5VV92
	 +17LgCKnL8z/XC4nYThooGpvXA7rg8Vf97PEZYcNVs7usqM+ng4izf32O1gGrgdDem
	 OexN5VZ9ATNQg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id EEFEF60074;
	Thu, 15 Oct 2026 12:37:47 +0200 (CEST)
Date: Thu, 15 Oct 2026 12:37:45 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Julius Bairaktaris <julius@bairaktaris.de>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, kadlec@netfilter.org,
	phil@nwl.cc, horms@kernel.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	shuah@kernel.org, razor@blackwall.org, idosch@nvidia.com,
	ericwouds@gmail.com, dqfext@gmail.com, netdev@vger.kernel.org,
	coreteam@netfilter.org, linux-kselftest@vger.kernel.org,
	bridge@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf-next v7 1/2] netfilter: flowtable: tear down direct
 xmit flows when the fdb entry moves
Message-ID: <atCs-U_AXIyvvpKd@chamomile>
References: <20261014235628.197976-1-julius@bairaktaris.de>
 <20261014235628.197976-2-julius@bairaktaris.de>
 <atCsGx2IRecQNK3r@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <atCsGx2IRecQNK3r@chamomile>

On Thu, Oct 15, 2026 at 12:34:06PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Oct 15, 2026 at 01:56:26AM +0200, Julius Bairaktaris wrote:
[...]
> > @@ -183,6 +185,11 @@ static int nft_dev_path_info(struct net_device_path_stack *stack,
> >  			case DEV_PATH_BR_VLAN_KEEP:
> >  				break;
> >  			}
> > +			/* dev_fill_forward_path() adds the bridge port after
> > +			 * the bridge.
> > +			 */
> > +			info->bridge_ifidx = stack->path[i + 1].dev->ifindex;
> > +			info->bridge_vid = path->bridge.vlan_id;
> 
> Why do we need this new bridge_vid field? This is stored in info->encaps.
> 
>                 case DEV_PATH_BR_VLAN_TAG:
>                                 if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX)
>                                         goto err_out;
>  
>                                 info->encap[info->num_encaps].id = path->bridge.vlan_id;
> 
> My understanding is that this is need to know if this vlan coming from
> bridge vlan filtering (not vlan device), but it is possible to track
> this in a local variable while walking over the path stack?

A new flag might be need, but there is room for new flags to annotate
this VLAN header came from bridge filter filtering, I understand
info->encap is not enough.

> >  			info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
> >  			break;
> >  		default:
