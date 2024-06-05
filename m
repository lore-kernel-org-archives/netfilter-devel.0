Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E3E149C60
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Jun 2024 15:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717600776; cv=none; b=M2XU45fBHir47qM/l8a3BvH0dpAacyB/86iZaCdQk49sJ0nW9P/UaiI4TyTtUsYvfmyRCTsVySwHekCc0r8uQki7kPypfhgPQYDvK8HsU2Eu/dpWqqimgTI2fBK9wux3+vjf1NdrXWqJ4AkRRCHVZDDkGiFEPNuoemciQHI8vqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717600776; c=relaxed/simple;
	bh=zzQ5HSt88dkpIe3QNlPUUrcaJPTRoivac0WVzLm2Qck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YUuN4vpdFFnIbsZ7TsFIprqobRhjtQg2Hbu55mn5EuMUg7YeZQxYDFDnyL43WpX8s9xR6iLTnv2gB6xWntgyHc//P7r9mr9vITJ9SP8zh9SYEno1et6vhjJTqYu8PBZ0kK0zrVrsPXi9jBfT8ZcvXPan0xoZtWgdJJbYm4n55sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [46.222.11.164] (port=3844 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sEsQ8-00AgcW-H7; Wed, 05 Jun 2024 17:19:26 +0200
Date: Wed, 5 Jun 2024 17:19:23 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Duncan Roe <duncan_roe@optusnet.com.au>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue] Stop a memory leak in nfq_close
Message-ID: <ZmCB-walvbM9SnX7@calendula>
References: <20240506231719.9589-1-duncan_roe@optusnet.com.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240506231719.9589-1-duncan_roe@optusnet.com.au>
X-Spam-Score: -1.7 (-)

Hi Duncan,

On Tue, May 07, 2024 at 09:17:19AM +1000, Duncan Roe wrote:
> 0c5e5fb introduced struct nfqnl_q_handle *qh_list which can point to
> dynamically acquired memory. Without this patch, that memory is not freed.

Indeed.

Looking at the example available at utils, I can see this assumes
that:

        nfq_destroy_queue(qh);

needs to be called.

qh->data can be also set to heap structure, in that case this would leak too.

It seems nfq_destroy_queue() needs to be called before nfq_close() by design.

Probably add:

        assert(h->qh_list == NULL);

at the top of nfq_close() instead to give a chance to users of this to
fix their code in case they are leaking qh?

Thanks

> Fixes: 0c5e5fb15205 ("sync with all 'upstream' changes in libnfnetlink_log")
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
>  src/libnetfilter_queue.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
> index bf67a19..f152efb 100644
> --- a/src/libnetfilter_queue.c
> +++ b/src/libnetfilter_queue.c
> @@ -481,7 +481,13 @@ EXPORT_SYMBOL
>  int nfq_close(struct nfq_handle *h)
>  {
>  	int ret;
> +	struct nfq_q_handle *qh;
>  
> +	while (h->qh_list) {
> +		qh = h->qh_list;
> +		h->qh_list = qh->next;
> +		free(qh);
> +	}
>  	ret = nfnl_close(h->nfnlh);
>  	if (ret == 0)
>  		free(h);
> -- 
> 2.35.8
> 
> 
