Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535CC331A6E
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 14:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786630615; cv=none; b=ov5pSAy4ta83LRt4AYG2TNfMrVwrtkaBlKCulo//64ehuYhr8ibtCiXYgsiHuRpFf+RFUEBIR/1peNkfDNYuSRCPd1NOBGjM0bSJH7lJs9iQiAtW9xHx52EzdfD4ZqaCfKH9XRh3G1rMhV5d0wYrb9O+7KCgcrJwPUUq+Uk09wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786630615; c=relaxed/simple;
	bh=cmtHHzWEJTP2j+852Z+8KrndeSocfaEz/In+fFF2VbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jd8pgsNs72ayFwjuabxfm748ikR8rLCztDK8flhsPBc/QyX4SX3clWxdXETLXRR8Zyg4SUPnkr0m1Auj2yaoXlAkcilis7n04n+mIKoqwVupHxqjCa9CLYSgjuuUFa769d2RolFc8/JGwOGNjhVfN5nb4tm3+jAq2g67rNBLHn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PMMz03WI; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PMMz03WI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786630610;
	bh=QzWUJzFP4BEXNEX1uhB7DdFj1Ngz9+fIOn+4Fv6fWMM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PMMz03WIbkgLSb13qQCRTE9OhFAozq+YjWjkr7Wrfk6NeKxDc2HJYPg+dEMRCbKot
	 kLBSmnCMslq8u0uuwj6l/j90Z5kSgHea8dJE5hOYKZG71zqpnCCtT4E+WeRssgx/ax
	 nzmRCp73YOLDXNCgH+hT5gBuJhHIVDGkRo5O6ewq/ASaxAqN1qTGcUqLKOr4+d6hn6
	 NtG79ZGS6R6RAsfqZwV3MJ30QzWlbo8dfk+JOGmCPt437OTiLgUwdb0C8Qo+O/ztUG
	 GfFEchnwVG/JxlOhtsDOl8iqHEKMTbAUQghqUUJxvgFc2mdsM5WK3Bvo8dpoCVgMoj
	 8pAuuAT+3ArCQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 8807E60074;
	Thu, 13 Aug 2026 16:16:50 +0200 (CEST)
Date: Thu, 13 Aug 2026 16:16:47 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Joas Antonio <joasantonio108@gmail.com>
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH] netfilter: nf_conntrack_h323: fix OOB read in
 get_bitmap()
Message-ID: <an3Rz-1v5OwV8myG@chamomile>
References: <CAOCBhwFzYNuxGQtjRNaisQt_aTNgst_u+FX5PCjWT0mcGqbKDQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOCBhwFzYNuxGQtjRNaisQt_aTNgst_u+FX5PCjWT0mcGqbKDQ@mail.gmail.com>

On Thu, Aug 13, 2026 at 11:10:54AM -0300, Joas Antonio wrote:
> --- a/net/netfilter/nf_conntrack_h323_asn1.c
> +++ b/net/netfilter/nf_conntrack_h323_asn1.c
> @@ -228,7 +228,8 @@ static unsigned int get_bitmap(struct bitstr *bs,
> unsigned int b)
>   v |= (unsigned int)(*bs->cur++) << shift;
> 
>   if (l < 32) {
> - v |= (unsigned int)(*bs->cur) << shift;
> + if (l & 7)
> + v |= (unsigned int)(*bs->cur) << shift;
>   v <<= bs->bit;
>   } else if (l > 32) {
>   v <<= bs->bit;

Dup:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260722125714.1389705-1-kudo3228@gmail.com/
