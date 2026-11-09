Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794191671;
	b=RZ91KOAttDddoPtFLfLyyaR2bZT9KfeXqt93O20AjUr0soLMYik64+9rVF9Jzi2YR6xU
	 1CIUXLNLLdnP9E7JPQwq2LKptlWEgXjIUB2IH2rsfbWm+aOyNQlElSpvs8yrR8cv8jmf6
	 COXXRwd0y8wUNIaBB9Yp2xt4WNfzFH3zC8FiAszVy45a4CUpcbo8biV/zwh9sft6/FH4x
	 U/CoMPD6+rdx6Skm/nIP3xTF99VxLVfnnkanvvshc6FujUiO2aTJm1nw+Nwb6JVavuGPd
	 83BGPb6Vl+rxX0lbG5JP2zTp7Mvc5w6DGzojh2Ff/tQ5JDK4q7H0VFVt5DAVw/PwDug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794191671;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=yaOg5jE0A5OJDKzqYaU0N0tlT5DHTRA+lI5J6+ouIOE=;
	b=nwZPjPLXDN7xqFFUeMtnPKpN/CV1VMBC0Aym+xSLfYJ2b7XtTEH89ukbHfJJIQNoj1Nq
	 5GnBxGipOLxUvPZUU5tEDPSaY+heeOqYzHDANy8uVBMHKVEMbh0UkiJrd6RKHHvT+zoB3
	 xxGd/w3AKaWnBRxxxDkOTaIZH7RKJbP0/FIIXQ+VMIy8yERmVBVU+59wkTVt8iEmfgsaF
	 YBE622xFKZjUDMJ7XIrq/pie83EptzDTvkzPFATgvuNkTbJMvrUKTUJmYIMkhOdamQnkj
	 3Ji85ga3sBt1XhLqyUyDEd2hKrciFtx1fRHOk+ebmwXz6v4VcbteeQMTZhpIwyWiH7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9DE606A320;
	Mon,  9 Nov 2026 02:34:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E9DE606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3DB7160490; Mon, 09 Nov 2026 03:34:21 +0100 (CET)
Date: Mon, 9 Nov 2026 03:34:20 +0100
From: Florian Westphal <fw@strlen.de>
To: Noah Weinberger <NoahWeinberger2003@proton.me>
Cc: "pablo@netfilter.org" <pablo@netfilter.org>,
	"kadlec@netfilter.org" <kadlec@netfilter.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] netfilter: nft_dynset: reject DELETE op when set lacks
 ->delete
Message-ID: <avExLOsc3ZWRF5hh@strlen.de>
References: <5aybqcVfq3WxYdpbT0Ea6bEWamp-4x10J9FF_5La7SSXJ57a4j176x_t3zUW8Ii2r84MsPX8xx_vNashO2PRWvuO9yNsaxS8YV_4TLc-QHU=@proton.me>
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
In-Reply-To: <5aybqcVfq3WxYdpbT0Ea6bEWamp-4x10J9FF_5La7SSXJ57a4j176x_t3zUW8Ii2r84MsPX8xx_vNashO2PRWvuO9yNsaxS8YV_4TLc-QHU=@proton.me>

Noah Weinberger <NoahWeinberger2003@proton.me> wrote:
> Hello,
> 
> nft_dynset_init() checks that the referenced set implements ->update,
> but for NFT_DYNSET_OP_DELETE the packet path calls set->ops->delete
> unconditionally. Today the only set type with ->update (nft_set_hash)
> also implements ->delete, so the call is always valid - but any future
> set type implementing ->update without ->delete turns a rule evaluation
> into a NULL function call.
> 
> Reject the DELETE op at init time when ->delete is missing, next to the
> existing ->update check.
> 
> Affected version/commit: mainline fa4ad798f6f681031775266044ba1b0cf3c670bd (v7.4-rc1, 2026-11-07), net/netfilter/nft_dynset.c:98-101 (eval), 209-217 (init).
> Longstanding asymmetry.
> 
> This was found during an assisted (AI-supported) static source review of
> mainline fa4ad798f6f681031775266044ba1b0cf3c670bd (v7.4-rc1, 2026-11-07); every code path cited below was re-verified by the
> reporter against that tree. The patch below has NOT been compiled and has
> NOT been runtime tested, and no reproducer was produced - the triggering
> conditions are described above instead. Please treat this as a report for
> verification rather than a battle-tested fix.

This would have been fine 1 year ago but we no longer have resources
and time to reproduce and verify such "fixes".

Ask your LLM for a reproducer, run it, show a minimal backtrace.
We have LLMs too and we can use them to create enough usless and
time-consuming tasks as-is.

I have a db of +1k reports just like this one.
