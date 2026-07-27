Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E256038551A
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2026 14:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785162320; cv=none; b=deae+ANspKQgPgJEMMDU7RGds0v6ZLg+J57yp5oRvah97wI5qBnCZFEo8sRFrdPxRlkQX2tKgTEFr5j590iupJvLe1JY/6HMJSqV8MiccniifmFpZGwHqrv+QUJ3S3U0wyjUpDpGxK6S4S36Oy8TZSK2yJUYZVNJXyVHlu0lImo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785162320; c=relaxed/simple;
	bh=TTlXnb+1tSdYOrkJ1UBEcVw6mApjsFyNdHKvgIkdAjs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O3vqxmsxkUHh6akNSjOyQIx6NLj3cFGyc/dz3Dg6ZX62D45UWnD+TKIvW6602ouRihsnxDE5Sn75SKXXcN+K+tA7hl3uEFaDx16OTp2kLh+MfP1YNF5BWYQvnNbrmw2XRI+dEMPdqw6siNfQfcePmGhnlPXrljltT/3/3bDGu2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BScwIYaA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BScwIYaA"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id E291C6018F;
	Mon, 27 Jul 2026 16:25:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785162316;
	bh=F6PRm+YdxJZs8Z1vju4cuI5PD7588NX7lXiJpW16kKs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BScwIYaAepo3wXyqc/PPAi5hfkYfJCjy2N9gbi6pgxTRle5fHgA5N9Tu+EaD7d5dK
	 WCEs9c3H888fid1oVycZJqvYi334yD27IU/eascuQu5vIQUp8auLYXYyL9OUS6Lq4d
	 juK2YQAuNlPKu3lmFBSyTjCnXPfDUvUR1ncthkJaJBFXvpTrFoAG0EnDvazyYrWEt8
	 2A4rrcmNTTkj4QnMuYbZ+I2rcXOUSF009yizbeCBr6qWeZGKrnBPK09KkO//bPMH5W
	 cmocs9kc+Z8WNhjnfKM5jzngG986rVBRBanwuEeUYbKkXxoFMSg9dWFt4gWczyHZJj
	 YCjuh0qMN6CVw==
Date: Mon, 27 Jul 2026 16:25:12 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next,v2 3/5] net: do not advance stack index from
 dev_fwd_path()
Message-ID: <amdqSFbQNIl863xq@chamomile>
References: <20260727115932.88335-1-pablo@netfilter.org>
 <20260727115932.88335-3-pablo@netfilter.org>
 <amdSK06EPRaTk4Ra@lore-desk>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <amdSK06EPRaTk4Ra@lore-desk>

On Mon, Jul 27, 2026 at 02:42:19PM +0200, Lorenzo Bianconi wrote:
[...]
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index c1c1be1a6962..ca65d1dcd604 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -742,9 +742,9 @@ EXPORT_SYMBOL_GPL(dev_fill_metadata_dst);
> >  
> >  static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
> >  {
> > -	int k = stack->num_paths++;
> > +	int k = stack->num_paths;
> >  
> > -	if (k >= NET_DEVICE_PATH_STACK_MAX)
> > +	if (k + 1 >= NET_DEVICE_PATH_STACK_MAX)
> 
> nit: do we really need k in this case? (ignore the comment if you do not
> need to repost).

Yes, I can do that. I will have to repost anyway, sashiko did not kick in.
