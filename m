Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82FDC39F191
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2026 06:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791441179; cv=none; b=H9n45bjaC942XLr51ieSIXpQoDOVKvt0C7h4oLVWYDHEaiNIJ6IihmgW9g8LVDuqvsGCQooVplD7USnjw5YPtofKj4MqHEqYlM1MyVEYxnwm9oORXRlbehT/SU08XjxSpkYO4opKZh7LqCmxxXLeo1zZICLqURmQehqypbRnVSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791441179; c=relaxed/simple;
	bh=b68bXUCp8actn0WuvV4dzfG8NfvLMnui9dmvwdIic7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=khvgq/BmtT1A1o9JSE84VCgtxJH54oHMcFdK8KCBPq2O6r2m9FptXgZdRCG29j1jd0IpeUTnFk8xU8O5hE3Kzpq+oP5u6e4gD7ammIwpcAzoV7Mur5kxjIOrrfetJLZ3/QLQ4i3nyWTWdBXwQzXmraeU5YOIsbN8GgtjXQqJEAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A53B36032F; Thu, 08 Oct 2026 08:32:54 +0200 (CEST)
Date: Thu, 8 Oct 2026 08:32:54 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Jeremy.Jean@oss.cyber.gouv.fr
Subject: Re: [PATCH nf] netfilter: nft_set_rbtree: narrow down range
 completion to anonymous sets
Message-ID: <asc5Bsrgv_w7lVOq@strlen.de>
References: <20261007220358.1140284-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261007220358.1140284-1-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> For anonymous sets, when adjacent ranges are found, the end element is
> not added to the set to pack the set representation. Use next start
> element to complete this interval.
> 
> Jérémy Jean says:
> 
> Consider two ranges in a netfilter verdict map:
> * keys 10-19 accept packets, and
> * keys 30-39 jump to chain 'victim'.
> Now, delete the end marker at 20. The lookup array now uses element 30
> as the first range's end, so an INTERVAL_END query for key 15 returns
> element 30, including its jump verdict and chain pointer. This can make
> KASAN reports a UAF after the GC releases reference chain for 30 that
> has expired:

Dumb question: How is it possible to remove an element if the map is
anonymous?
