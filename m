Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7005464D
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Oct 2025 20:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759870455; cv=none; b=bm9fsRSNz6vU3sweYGr7qBXhukT8QVNC5lAUwV2BCFObOkZQoSoUjPuLWw5KCOMwMIGpQsBZKnp1QfptypyO76UxZCVbrjxegc2rO62f/z9GgB6a2UqRgxhhgN0H9vGkb2MurOQqpWK6QYheohNgUeQiIORijMgttJWI9HaXTUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759870455; c=relaxed/simple;
	bh=5KK12GgJ+jVvBdd7zx+duiyvNb233vep7d5/gyOv4nk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fy8JFDTu8jWHP7ncvObdQ+fLO91d9S2R8Nsx+T95wWBpfGSt11Lx7X66A/tRpMsyvxidLDBiB/mF1WoEO/qUDwu3NWCNHVHLXwTuAdhJbNvsfMQ3XKSPafNVYQNNle24+dtu7xZ90BCeqWeyqy8zcCguYJXp4sIjJ5JipLRy3HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=W0leNicB; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SxWVX4mr; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="W0leNicB";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SxWVX4mr"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 768E560346; Tue,  7 Oct 2025 22:54:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1759870450;
	bh=loj4f4uZ4qbs9zB3oFJkbMEjo79llh9uVjcTcTXZWoU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W0leNicB9BRB3gC/fvW1phHz7ZnDGzpHxv4D2iUVWRe3FPh3VaieqFXrIcGq6SuuB
	 HUZ4SaUvlubTeX/sUU5ItMKxRmikg2sU/NYjflcsCosXIzO/0pCfc9dRpwUH5C6wW3
	 ptZwG/t0DGoL7TXS3rvdYNtyMvNPaQQNgg5fJ5UMukV2dKKzn6xztFZwIfVRsLMX/L
	 a5gnCMr/r1J8sOyvYf1eSTQTlGxIyjUey0ep44ET23Jrw8f/58veRx1BBqnGVVoEjq
	 ECTdSjfJK8NNy+ciT2kxZGckOXUcr+ngW6mxO5qCWI7PuOvx9gnbyOIbBXjQOBodhU
	 0tNky2DGQIhuA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2967060335;
	Tue,  7 Oct 2025 22:54:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1759870449;
	bh=loj4f4uZ4qbs9zB3oFJkbMEjo79llh9uVjcTcTXZWoU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SxWVX4mrlbcdhhCyj4kaNJbKn7ShN2XQM2rAJmqgk8eUjn+LwDXTLiX4uX89SIJeO
	 YWTB2kI7MLCe8O5QO979RCDeEfCPghkHQkkpfkRoJywXxUwU15wG3biXX/duBBTUMX
	 f4HQpQy2X2unD376TubqReTbox06qnllLB9aSxKOHLCyA9WdFpscvBdeLoTqTqjIgJ
	 lBBYzM9vZhhkhPRllnYK6XL8TSHmBZEFiI1LMpjsvzUV3eNKFNUoB98m/QBbkbXOAW
	 EQ/hWQktzWA/GGqegdenEoxrv+4BZAWlyfeOzCyTGH41aQTCAg+CeYBf5aw9W039am
	 qSXt+xMVDYGeg==
Date: Tue, 7 Oct 2025 22:54:06 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, fw@strlen.de,
	Georg Pfuetzenreuter <georg.pfuetzenreuter@suse.com>
Subject: Re: [PATCH nf] netfilter: nf_tables: validate objref and objrefmap
 expressions
Message-ID: <aOV97sV5DA1z1pv9@calendula>
References: <20251004230424.3611-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251004230424.3611-1-fmancera@suse.de>

Hi Fernando,

On Sun, Oct 05, 2025 at 01:04:24AM +0200, Fernando Fernandez Mancera wrote:
[...]
> To avoid such situations, implement objref and objrefmap expression
> validate function. Currently, only NFT_OBJECT_SYNPROXY object type
> requires validation. This will also handle a jump to a chain using a
> synproxy object from the OUTPUT hook.
> 
> Now when trying to reference a synproxy object in the OUTPUT hook, nft
> will produce the following error:
> 
> synproxy_crash.nft:11:3-26: Error: Could not process rule: Operation not supported
> 		synproxy name mysynproxy
> 		^^^^^^^^^^^^^^^^^^^^^^^^

Object maps only store one type of object, ie. all objects are of the
same type.

        if (nla[NFTA_SET_OBJ_TYPE] != NULL) {
                if (!(flags & NFT_SET_OBJECT))
                        return -EINVAL;

                desc.objtype = ntohl(nla_get_be32(nla[NFTA_SET_OBJ_TYPE]));
                if (desc.objtype == NFT_OBJECT_UNSPEC ||
                    desc.objtype > NFT_OBJECT_MAX)
                        return -EOPNOTSUPP;
        } else if (flags & NFT_SET_OBJECT)
                return -EINVAL;
        else
                desc.objtype = NFT_OBJECT_UNSPEC;

I think it should be possible to simplify this patch: From objref, you
could check if map is of NFT_OBJECT_SYNPROXY type, then check if the
right hook type is used.

Thanks.
