Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25C0B664
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Mar 2025 09:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742376548; cv=none; b=Y2iM1IEYyRrO4YaznY0uwK12c9vHc9x6ES2rKmiV7pQ6xaWnSxOGlgBZ0Myevoav3qX9eygtcsuAAo9ViXsyyKaS7AhLoNN7lVckgfFJ1zfIU9NTPDujQ0MUJ8lBd+/cAs8zsX4lz6SIx4EJHE/SwxefLnYH/eXHe1NvIZCVDms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742376548; c=relaxed/simple;
	bh=wCxhvEIOQtcDo9+4Qx8/WLOux5bQBk5HbMp/0bB8qgI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DGe5iszVgZdnh5AzdfONhgxttqH8N/LZ9GSjbUeaJcsQSB+4gnHCdgS1hTizWArhVmj0zbKxmgl2IVOw3/UHd4acsk1qQH4gHFjP2rRUUuSX4jdJRIMx7oF+ZD+dLlmzQ8wqJ2yxBZ/IT/CXMoQdxedropB6n32VLMYTQEeCLp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=M6g2Osa6; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=re5T4baU; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="M6g2Osa6";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="re5T4baU"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B7ECE6037B; Wed, 19 Mar 2025 10:28:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742376537;
	bh=qIcwDexVnE8fH6uuovqyJcqUUvDRdjKWVVr7dcew5ZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M6g2Osa6nQui3jEYuA2gtb2SvZ5cuhlHYBaReSorSjfupedBmzyy3x2j0qseowQjr
	 JV/UXVpukgcDqmajhGCdbKb2LiJHv4+Pn/eqJXmHr8uqkrqNMzMQ3LMuDiuJvjd6a8
	 OXC4kFwxhiYbhQqJh7lFsGmQPmJur4CKFRzhG9OQp12eMQplimY5L8/8/FikZzXA0A
	 TAmx/dfudLUzBM9b8MLKd2W3bJB4t9MxoU0OEtDDpnuEoHzKExglqPGx9B20u71Kin
	 CfLuflFc69vZu8S2sKpFvVlTU/ghvNXa70NoKfJAmhRiXa6daPW0aP02RNnw1NC06j
	 4xxo/sqJPZYhg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BC17060372;
	Wed, 19 Mar 2025 10:28:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742376535;
	bh=qIcwDexVnE8fH6uuovqyJcqUUvDRdjKWVVr7dcew5ZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=re5T4baUDZ8UXqU3Boja78KMOoRMT7XX4/L4jo4rmICxF5+v2iogBxANZanP9WKYT
	 RTOY7H7s9mDLwyEiZGAAbuiogc5Ll3dnRGBPnsqfmFy0jEhEZkWS8qFNte8MX3pspo
	 9MPEfngco+esg3Nm6KkE5LY+WhO0cJW0O1QhKm6/37lYd+CDaYjVPYJGQayYYm39A0
	 CdHQnma80DAQO3jtY5q3PNpwF7tO8nuwlGAUzzyM1E9HzhteyS584bO9cEj9iDs5PD
	 x4RCKDKAPunc1Ikz9am+IrwexsYteI+uaD/QSgXvv12D1lQlCi2lZFaG9uK8hnw9Gw
	 R/c3t5VTVX2eQ==
Date: Wed, 19 Mar 2025 10:28:52 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Duncan Roe <duncan_roe@optusnet.com.au>
Cc: netfilter-devel@vger.kernel.org, ged@jubileegroup.co.uk
Subject: Re: [PATCH libnetfilter_queue] src: doc: Re-order gcc args so
 nf-queue.c compiles on Debian systems
Message-ID: <Z9qOVEObhFzmVKx6@calendula>
References: <20250319005605.18379-1-duncan_roe@optusnet.com.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250319005605.18379-1-duncan_roe@optusnet.com.au>

On Wed, Mar 19, 2025 at 11:56:05AM +1100, Duncan Roe wrote:
> Change the order of gcc arguments following the discussion starting at
> https://www.spinics.net/lists/netfilter-devel/msg90612.html.
> While being about it, update the obsolete -ggdb debug option to -gdwarf-4.
> 
> Reported-by: "G.W. Haywood" <ged@jubileegroup.co.uk>
> Fixes: f0eb6a9c15a5 ("src: doc: Update the Main Page to be nft-focussed")
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
>  src/libnetfilter_queue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
> index f152efb..99799c0 100644
> --- a/src/libnetfilter_queue.c
> +++ b/src/libnetfilter_queue.c
> @@ -86,7 +86,7 @@
>   * nf-queue.c source file.
>   * Simple compile line:
>   * \verbatim
> -gcc -g3 -ggdb -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
> +gcc -g3 -gdwarf-4 -Wall nf-queue.c -o nf-queue -lnetfilter_queue -lmnl

I am going t remove -g3 and -gdwarf-4, so it ends up with:

gcc -Wall nf-queue.c -o nf-queue -lnetfilter_queue -lmnl

to keep this example as simple as possible.

>  \endverbatim
>   *The doxygen documentation
>   * \htmlonly
> -- 
> 2.46.3
> 
> 
