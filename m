Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133F31B3937
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Aug 2025 11:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754567875; cv=none; b=Z0Z7UWoHhBvPMg5Ioe/oenuuTZ1sO2OT3pCQAMe4/BXx+SS8utERZkC73sluxXxU6qdx25Si/LhSDkD2K7Xhx5kLnmBGB6xGaTMcg8QlFfYZC6ey44iBacE8GArKrhk58Tiq0cbzP1umneDJb3mtYrpHChBJr0+rEIHrB9Yv1QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754567875; c=relaxed/simple;
	bh=gnUi7FizBgUK8t6/MQXweUlSSoPEF9wPvZ9jQt4sRUM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TXID2T5VFtSTnDKsL7/CH33/Dt90rhLHu6cruCr1OoVw4Qpherd4LuyibkpJ0/0P9PNHe/enV6y+EEsNQhNK63MdoeUx0j9twfkCG9LwsmYYMz8B39Fy0rle0yxZxDCwnGxl6mzkaJEKiOXd78P3H0viXmexBemzIa13V8/md9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jC2aogmC; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jC2aogmC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jC2aogmC";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jC2aogmC"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 93B8560A4C; Thu,  7 Aug 2025 13:57:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754567872;
	bh=leySaraM7sVXc3e60smvC0W4eo0K2vadlY4nbBNjY+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jC2aogmCUPVhDcUXFEA/HibBdzdtFAJQFZIwxULX0mzsMmzOLuRxm8TE5oWXcT4NK
	 vdSpmnRbxzfeegWMS2rgqLtjeq1+34ktg7vn73aLdnFKn9UqzVThCbD/7HJHgIq+wa
	 +qg64rKSQIeURep84FjqrD5rSr2E6Q/Vxmnw4ZUvg+I/rqeIpexWvEmgEyNcoxMQR1
	 SWWmXSpBwxbVAfntpK0QBWmawi4ofNyeR82diSHx4Ov9E/Hspg5ulG6xjXVaIiPr+h
	 m3gaQStr7TH82Bd8w0WBOhO3Xue1A+Uh40C6CQ01AKW+n2NJXnmBHUhIG1+YxK5+jX
	 5IO33G66LsNIQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id ECE8960A32;
	Thu,  7 Aug 2025 13:57:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754567872;
	bh=leySaraM7sVXc3e60smvC0W4eo0K2vadlY4nbBNjY+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jC2aogmCUPVhDcUXFEA/HibBdzdtFAJQFZIwxULX0mzsMmzOLuRxm8TE5oWXcT4NK
	 vdSpmnRbxzfeegWMS2rgqLtjeq1+34ktg7vn73aLdnFKn9UqzVThCbD/7HJHgIq+wa
	 +qg64rKSQIeURep84FjqrD5rSr2E6Q/Vxmnw4ZUvg+I/rqeIpexWvEmgEyNcoxMQR1
	 SWWmXSpBwxbVAfntpK0QBWmawi4ofNyeR82diSHx4Ov9E/Hspg5ulG6xjXVaIiPr+h
	 m3gaQStr7TH82Bd8w0WBOhO3Xue1A+Uh40C6CQ01AKW+n2NJXnmBHUhIG1+YxK5+jX
	 5IO33G66LsNIQ==
Date: Thu, 7 Aug 2025 13:57:49 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [RFC nf-next] netfilter: nf_tables: remove element flush
 allocation
Message-ID: <aJSUvdpLyFS75wj5@calendula>
References: <20250731154352.10098-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250731154352.10098-1-fw@strlen.de>

Hi Florian,

On Thu, Jul 31, 2025 at 05:43:49PM +0200, Florian Westphal wrote:
[...]
> One way to resolve this is to allow sleeping allocations, but Pablo
> suggested to avoid the per-element-allocations altogether.
> 
> The main drawback vs the initial patch is that in order to support
> sleeping allocations, memory cost of each set element grows by one
> pointer whereas initial sleeping-allocations only did this for the
> rhashtable backend.
> 
> Not signed off as I don't see this as more elegant as v1 here:
> https://lore.kernel.org/netfilter-devel/20250704123024.59099-1-fw@strlen.de/

Not very elegant, maybe it is just incomplete.

> One advantage however is that NEWSETELEM could be converted to use
> the llist too instead of the dynamically-sized nelems array.

Yes.

> Then, the array could be removed again, it seems dubious to keep it
> just for the update case.

For updates, I think the element would need a scratch area to store
the new timeout/expiration until commit phase is reached. For several
updates on the same element in a batch.

> That in turn would allow to remove the compaction code again.

Yes.

> Both DEL/NEWSETELEM would be changed to first peek the transaction list
> tail to see if a compatible transaction exists and re-use that instead
> of allocating a new one.

Right. Would all this provide even more memory savings?

> Pablo, please let me know if you prefer this direction compared to v1.
> If so, I would also work on removing the trailing dynamically sized
> array from nft_trans_elem structure in a followup patch.

I don't remember when precisely, but time ago, you mentioned something
like "this transaction infrastructure creates myriad of temporary
objects". Your dynamic array infrastructure made it better.

Maybe it is time to integrate transaction infrastrcture more tightly
into the existing infrastructure, so there is not need to allocate so
many ancilliary objects for large sets?

There is a trade-off in all this.
