Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F2C2F2C40
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 13:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752671232; cv=none; b=d8Z46g/pv9ILt+tIPVLlmssUxkXTEKDIriOd3VNvsxc313fWqJR7yv3rcAn+kxAn5Kps+0F28ebCpuCouj6uGPRIrBKVsAxGEh37XGr+8P/FWj5RdN2SiIM0bVIP/azhjpYkj/htXsF7PyOAn2Is6X4FRV4WDxEnS6YUltYiOCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752671232; c=relaxed/simple;
	bh=6LhHNW70fiNbBlkX/EizyXizkpOv4uwYQdtRCa0NxuE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qNhjzRZv77ykHp4w/d4KJDoktPekW9w7JWyLjThil2gKEBMoiN2WDaJAnBvzPD2Ctla4ZYLcxlVkLog36XlwzmODfY62/nYndLy3qaBMdP3umzgHltOCL07S01en/0zbPYPtiaiC1LWIBqkz0tV7S7kHYCcJg3NvHxexquAIQ3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=EVkJCrrx; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="EVkJCrrx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Bd6RvM2RzIhkysQ5fTiX59PP8fdba9+ePx3n5BbqUoM=; b=EVkJCrrxt20pmafkLvatNdtOwe
	HRyx3cX7A5x0z66QJaJD9luoEPW/MWIvqc5XgsPsE/UlN4p8wh/NQeKPzPU7+areK5sep2ElLGgLf
	BAEtXnCN7LK7eRaJ8+Iv86tsX/Rjr0CoDptEDYNfHbMcBa4Pqiv2w4Oy0mN6G8g20oNLgJagVDWxU
	DWl057Z8fPVRAqMF4ONhfRHn2rhoh1wuCbhBcdok2va4UpV0rgpG666RmaOJLGPLs0RveYgm5lRaS
	4TLlwpnFuDacblbK7LJl3SxGdoMMVDjHdeSEhvQ69M3+9jR8m+G2iZNWoAfVprlChy6mqZ0Tc2A/H
	06oiPzEQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uc1qn-000000004a8-1By5;
	Wed, 16 Jul 2025 15:07:09 +0200
Date: Wed, 16 Jul 2025 15:07:09 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v3 2/4] mnl: Support simple wildcards in netdev hooks
Message-ID: <aHej_QhOFPK3VUg4@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250716124020.5447-1-phil@nwl.cc>
 <20250716124020.5447-3-phil@nwl.cc>
 <aHegdfoOs5dfm-Jm@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHegdfoOs5dfm-Jm@strlen.de>

On Wed, Jul 16, 2025 at 02:52:05PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > +static void mnl_attr_put_ifname(struct nlmsghdr *nlh,
> > +				int attr, const char *ifname)
> > +{
> > +	int len = strlen(ifname) + 1;
> 
> Nit: size_t len

Ah, and 'uint16_t attr' as well. I'd fix both before pushing the series,
if that's fine and no v4 is needed.

Thanks, Phil
