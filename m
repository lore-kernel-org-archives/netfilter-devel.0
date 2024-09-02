Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638E42B9BB
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Sep 2024 06:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725259420; cv=none; b=DsoAQXCavpfBkmrmtCWm4qwFliCc3VIJZlkobZn9r8U4aZCkwLVQTLDSwv/3MVJNF097dyMmAAfqItz9JHE+Syn1GvSiXYnEC02cqQldIec9aYT3Nxi0gAC66+Ds4Ll9GT6EZsug6qmXV0J56jphH6SKjtaw6dTijIi2k/RPZSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725259420; c=relaxed/simple;
	bh=vwmvdtIJgm9q9Kq7qxemj0FWsejOb4A+vZ42e2DBzZo=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=OkaMoCLe4gt7P7hR1NaGa1zJKSskqdVoy/wFA7mFSz8UolQAgfMq5j84KEDLzU1kIzO+/Iim7AAfzR6oGIqNG4v44pDWCqb56GAgGmrlNuEnRAEQt1spBhjk5Kvg4wANU1ZUENVS6GvVnDuaapycXLtHC3mo6KkVcJ8MujN6eFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=qeaQ/K1V; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="qeaQ/K1V"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id D5A3D3C80106;
	Mon,  2 Sep 2024 08:33:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1725258814; x=1727073215; bh=oNZwbHuFRV
	sjGxP40h8mM2jUMQNAwxJIsEoqtN6hf98=; b=qeaQ/K1VEQlPpf4wUDFTU3ZAb7
	znqejzFjB3dga1PakVvX9cfgyL2LqwQbOzTIbJadmI1LrAjpaO/Ti8bLSf8t9Dz6
	nnKUg4if2vzPj1CCgmt0Li8ObN3uxRvoP+YtNZJ3y1W719YmMtv/9SuU5mrmb/Gx
	ro9s74kHwNGZwvv20=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id xBfk-oBy0ep6; Mon,  2 Sep 2024 08:33:34 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp1.kfki.hu (Postfix) with ESMTP id DA7893C800FF;
	Mon,  2 Sep 2024 08:33:33 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id D4B6F343166; Mon,  2 Sep 2024 08:33:33 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id D40E4343165;
	Mon,  2 Sep 2024 08:33:33 +0200 (CEST)
Date: Mon, 2 Sep 2024 08:33:33 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Mike Pagano <mpagano@gentoo.org>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] ipset: Fix implicit declaration of function basename
In-Reply-To: <20240830153119.1136721-1-mpagano@gentoo.org>
Message-ID: <80f6a981-94bf-795c-f0d5-ffa8cd038e69@blackhole.kfki.hu>
References: <20240830153119.1136721-1-mpagano@gentoo.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi Mike,

On Fri, 30 Aug 2024, mpagano@gentoo.org wrote:

> From: Mike Pagano <mpagano@gentoo.org>
>
> basename(3) is defined in libgen.h in MUSL.
> Include libgen.h where basename(3) is used.

Patch is applied in the ipset git tree, thank you.

Best regards,
Jozsef
> Signed-off-by: Mike Pagano <mpagano@gentoo.org>
> ---
> src/ipset.c | 1 +
> 1 file changed, 1 insertion(+)
>
> diff --git a/src/ipset.c b/src/ipset.c
> index 162f477..d7733bf 100644
> --- a/src/ipset.c
> +++ b/src/ipset.c
> @@ -15,6 +15,7 @@
> #include <config.h>
> #include <libipset/ipset.h>		/* ipset library */
> #include <libipset/xlate.h>		/* translate to nftables */
> +#include <libgen.h>
>
> int
> main(int argc, char *argv[])
> -- 
> 2.46.0
>
>
>
