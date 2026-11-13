Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794557593;
	b=aIPVcUZ7/jdKz0wXEb2XAIp5RKSlbCnzublfnJCD856gYYwrerESKjAU56WeegipUQ3+
	 HsW1dH1N7gsLuDoY6p/QJ9fhyvCcW3SUeSHcY2h/hSLrVQv3uHlG3cOGbrnIQpypwzZHV
	 2DC5+UvyvQ56UuDhEK2wO4cZkzix8UVqN4gqjq7YIb6jWp2rGrhBDvVczQy7Q60V8mNsG
	 NgtMe4pGHidQbxTuOHiPvDpix9MoXhFYC00k3puxSQCcwHcL8FEHicmvKUizaYaJiauS+
	 Lkb1K9gHmbU1MtEjh/+nPYU55IA0scDrhfGcVS3G7YHKS+24sMAFa32kkDDCzkaa29Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794557593;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=hUCICzWCjxN0s7ge+i3DKK8sGu+iv6RlOgvSwR9nZec=;
	b=Ys7k753L3MClfTfRzKFVExKmLqOa4R7LE4BuOAtcbplFpk9Gp+PW7J4QOOIAiaXY75+o
	 vHTbFz4U68ufbmNlxghXPBaD0C8+81UpznFTvDLAUWdHkZvH175e3OAVJZdmVAmjC/PPv
	 DNWH46VfAbB4EwReIj3f2fHC4fvdQkNi34phX1srzEuZnkcB2r+VFjn/pKfcxyR79Bre1
	 sCT9bUglLD+tq/GyELC3jTT5zphfw89gTy6f3RUhhEJQo3VVUK1/dT0r2PG38CvuHmgKr
	 MZHID6RU2egj7L1zpwdP6206O7YCJVXgHJGWFsjQ+tgy9ktUPE/AloUmbM5XZ6A08Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB88F606A321
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Nov 2026 08:13:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB88F606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9CB24603FB; Fri, 13 Nov 2026 09:13:10 +0100 (CET)
Date: Fri, 13 Nov 2026 09:13:09 +0100
From: Florian Westphal <fw@strlen.de>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v10 0/6] ipset: replace internal hash table with
 rhashtable
Message-ID: <avbGlZBumFgTJyVY@strlen.de>
References: <20261112143818.30638-1-fw@strlen.de>
 <9a882426-58aa-c14d-fe99-64538c98d293@netfilter.org>
 <avXuJ0GBdzyxK-_w@strlen.de>
 <bbc263cd-5ceb-f183-439b-44909adef4ed@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bbc263cd-5ceb-f183-439b-44909adef4ed@netfilter.org>

Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > I pushed a few of the test updates to ipset.git, but not this 
> > 3-part-series:
> > 
> > https://patchwork.ozlabs.org/project/netfilter-devel/patch/20261111101603.22698-1-fw@strlen.de/
> > 
> > First one passes on either rhashtable branch or main, but I'm not sure
> > it should :-)
> > 
> > Resp. I'm not sure what the contract/expected behavior of net,iface set 
> > type is when the address matches the net/mask entry, but the interface 
> > doesn't.  I followed existing behaviour, so that test would enshrine 
> > that: it stops matching more candidates.
> 
> Hm, it shouldn't. The expected behaviour is as follows: if the net/mask 
> entry matches but the interface not, then the code should continue trying 
> to find matching entries but just with the same mask value and not with 
> other ones. That way the same net/mask entry behind multiple interfaces is 
> supported and matched.

In that case a v11 might be needed; the conversion follows the observed
behavior.

> I'll have a look at it.

Thanks Jozsef!
