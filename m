Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF0F79C8
	for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2024 09:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709373222; cv=none; b=Dmd+TebhP0tjtnCsrvefYZtSG9v90KcCXkCmfHREFKiZP7z/3vm00E9PTwU3bbGHK6fGx94TObx6QR/+ew0PrEL9/JqHkYiHEcLS0xF2GXyBDKNL/Fo1CSDsJM+uTTVDtoE5sZjeGxG+FtswaikrI57R8IztA/6P3vvF+qFqUzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709373222; c=relaxed/simple;
	bh=lc50YOTWQDJhmBKV0Z1anV+7Rq4JiOoJAEfXGV78ka4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fS8ef50PGIEJrpAVQEdpeuY+BjOOuWZbwtnhvLsfhgkpJSLQTseTeV2TnrlVmyGQLMpz/iZfSIuAjjkunKo0Jmg6DbfDGGmYIAJ8RA0tezqCRMRYuxLgzUWNv/K1vW7g8HwhYnhwJLuYEes346sIALhcAeWB43H7a9cQL2vwJ2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=37364 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rgM3g-008pDf-T0; Sat, 02 Mar 2024 10:53:34 +0100
Date: Sat, 2 Mar 2024 10:53:32 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Donald Yandt <donald.yandt@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack-tools 2/3] conntrackd: use size_t for element
 indices
Message-ID: <ZeL3HJRhC3D8yMlR@calendula>
References: <20240301170731.21657-1-donald.yandt@gmail.com>
 <20240301170731.21657-3-donald.yandt@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240301170731.21657-3-donald.yandt@gmail.com>
X-Spam-Score: -1.9 (-)

Hi,

Could you describe why these are needed?

Thanks!

On Fri, Mar 01, 2024 at 12:07:30PM -0500, Donald Yandt wrote:
> Signed-off-by: Donald Yandt <donald.yandt@gmail.com>
> ---
>  src/vector.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/src/vector.c b/src/vector.c
> index 7f9bc3c..ac1f5d9 100644
> --- a/src/vector.c
> +++ b/src/vector.c
> @@ -23,9 +23,7 @@
>  
>  struct vector {
>  	char *data;
> -	unsigned int cur_elems;
> -	unsigned int max_elems;
> -	size_t size;
> +	size_t cur_elems, max_elems, size;
>  };
>  
>  #define DEFAULT_VECTOR_MEMBERS	8
> -- 
> 2.44.0
> 
> 
