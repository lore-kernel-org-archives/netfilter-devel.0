Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD10A263C6D
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Mar 2025 21:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741211383; cv=none; b=aTA1+dFhnii7n6S2k1jmL2Jdd7LY65o9KZFA6ukJcz++ggTVaabLLcWTlyaSsWDmOHdUFzqxdmEce70eK3LSbAOeK+F4yVaQb9H7LGa+Ig3lB3a0gvtH8ls9HdTg0YQqCDTeKwkAGtsiRitl3lS5FwNQi3rpb0hA6HKdUN6vr4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741211383; c=relaxed/simple;
	bh=N/d+09OqNMApDTniiKasZDzPfS3qTjZZiDW1HLKVaeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G/wUkhCdO+E9Pti+JUQfkknG+qPal+X/tjDYuaZ6qQRtmMq4WFPkU7cia6YdwexhC8bEdf+pDjYE66UHt2sUoSbXJBXUc+6bWxwl6lsbcG+ypk9Oai2JbxUd4Zb1HuP2wllzZu1HnLTez+1mFSWjLGN5xzWdG2UJ/kwbHcOyujw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rNNFcG/r; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gF9grhWo; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rNNFcG/r";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gF9grhWo"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 51CF360277; Wed,  5 Mar 2025 22:49:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741211378;
	bh=kFaBsHIZECtMwbWys9L9/FAAgFUkjJs2q/9hTMDPMgA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rNNFcG/rqilpTn8PRxU3H3odCnTcSZygCaG02/vasIjuO18vyy8IJmKCnOqycIrpo
	 JZpKNVJzjQpolNYrRu6F6CsBGvzB1c7cablFf/8PimX9lM5Re9LPKhFRU+1/3JxsOj
	 CQXwVru0gwCQpy9PsdzspCGvBshPYPOeJ9ap01xL9aAJb2JxWOZQOD17Ebi3JA++Pw
	 QU/tc8gq3dk/np1PDToBrVwXkvQm8/4pr1mfUaV2MTF3StNpuqX791sDlVTcKgOJMD
	 93giIxirJgCtc55rZGzyiEOukY010l+XoRKBH04XPJwtM5j82GzJ/lxr8hHomQDCWn
	 lE3xBiBTWwmBQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B40EF60277;
	Wed,  5 Mar 2025 22:49:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741211377;
	bh=kFaBsHIZECtMwbWys9L9/FAAgFUkjJs2q/9hTMDPMgA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gF9grhWop086NEK462JE4Roy9ODuLDBuQYd7xngspIWfq03p8Ijg8LDcW9jup6DGN
	 FYi4xB/ymVdxWKcYCX6ONgtqZJF+xBKlQpZeD108LBxyXMbkDzsVWFXV/jRS7xCC1m
	 BL1xTpnLgGABORfNcwxXhyLoi0VxifopqsLSNqnbCv+Zmhv1eRQ3dXq6dTsp/qEWtV
	 t2jbP7a51t2hM737JrT51XM1+TXQoKNveFIVz2dKrcZxPs+HTtRx2On4OM6JohLK7e
	 Kr+Ppvcb+tI/+rnAVVJ6tD/VVCOIa7gzhFoacqkN2Rw0BdwSqc0AViKW7s39GxC/tx
	 AOYwTXx/2sKFA==
Date: Wed, 5 Mar 2025 22:49:35 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: "Jensen, Nicklas Bo" <njensen@akamai.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] Fix bug where garbage collection for nf_conncount is not
 skipped when jiffies wrap around
Message-ID: <Z8jG7xeL0Nm7HZam@calendula>
References: <EC4CB996-F5A1-4368-AAB7-F77E1B2E6A4D@akamai.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <EC4CB996-F5A1-4368-AAB7-F77E1B2E6A4D@akamai.com>

On Thu, Feb 27, 2025 at 01:32:34PM +0000, Jensen, Nicklas Bo wrote:
> nf_conncount is supposed to skip garbage collection if it has already run garbage collection in the same jiffy. Unfortunately, this is broken when jiffies wrap around which this patch fixes.
> 
> The problem is that last_gc in the nf_conncount_list struct is an u32, but jiffies is an unsigned long which is 8 bytes on my systems. When those two are compared it only works until last_gc wraps around.
> 
> See bug report https://bugzilla.netfilter.org/show_bug.cgi?id=1778 for more details.

Applied as:

        ("netfilter: nf_conncount: garbage collection is not skipped when jiffies wrap around")
