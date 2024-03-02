Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB86879C8
	for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2024 09:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709373282; cv=none; b=LdCw1XL2sILLoVQ+Y5gAZyT64fzjt78+PZcK35CUv7m9+vFvmWkQk9Krz0ls0kmtlA2jPEr5+JyUfv+oMqz048PO4aiagszgqYSZW7DGgm7K/A9uSXFRHx2K7sRd4OXcLKmmtJfW0S2V1EEpowipxA18uPzRvw3rihOPtwjmFPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709373282; c=relaxed/simple;
	bh=/NA8TBDavWzsKFBo8fN0hd9NLx/ADppWMbZVoGsKRUA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FEV+dwyezwoT3e3AEpRBs64z8S+AKe3kXnusId9OWD6sg7yfkulYeriGfSADYBP/AGTJTwkJwpu0fe8WH5p1F/kOvsnE44Eai0oTbh5eG7DQ0CPBmZX5L+SQuAIaMLaYpicY6rv+aSYf3Uv+xrhJcAWbnDZ99A1k2Ovf4OrYAng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=38976 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rgM4h-008pGo-AE; Sat, 02 Mar 2024 10:54:37 +0100
Date: Sat, 2 Mar 2024 10:54:34 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Donald Yandt <donald.yandt@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack-tools 1/3] conntrackd: prevent memory loss if
 reallocation fails
Message-ID: <ZeL3WvMhrir_Lz-s@calendula>
References: <20240301170731.21657-1-donald.yandt@gmail.com>
 <20240301170731.21657-2-donald.yandt@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240301170731.21657-2-donald.yandt@gmail.com>
X-Spam-Score: -1.9 (-)



On Fri, Mar 01, 2024 at 12:07:29PM -0500, Donald Yandt wrote:
> Signed-off-by: Donald Yandt <donald.yandt@gmail.com>
> ---
>  src/vector.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/src/vector.c b/src/vector.c
> index c81e7ce..7f9bc3c 100644
> --- a/src/vector.c
> +++ b/src/vector.c
> @@ -62,11 +62,12 @@ int vector_add(struct vector *v, void *data)
>  {
>  	if (v->cur_elems >= v->max_elems) {
>  		v->max_elems += DEFAULT_VECTOR_GROWTH;
> -		v->data = realloc(v->data, v->max_elems * v->size);
> -		if (v->data == NULL) {

Good catch.

> +		void *ptr = realloc(v->data, v->max_elems * v->size);

Could you declare void *ptr at the top of the function? Following old
style variable declarations?

Thanks.

> +		if (ptr == NULL) {
>  			v->max_elems -= DEFAULT_VECTOR_GROWTH;
>  			return -1;
>  		}
> +		v->data = ptr;
>  	}
>  	memcpy(v->data + (v->size * v->cur_elems), data, v->size);
>  	v->cur_elems++;
> -- 
> 2.44.0
> 
> 
