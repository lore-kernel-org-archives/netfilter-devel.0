Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4161FBCAD
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Apr 2025 12:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744980955; cv=none; b=JMz3v6q9nVAQxWqkYrmP+27Lr1+2sJ++Hnt88JJfnlc6B87DQfkyQth7AOJTdWmUIz85PhmVWO2Z/7Xz5jPhgCoYEx2ziFD9ufjONksOJviM464PBAJIBn81fTY8PlYqFNXVohTYwlwKIYCHrjP75utLyFFgOvkwV5zCvC9f2gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744980955; c=relaxed/simple;
	bh=mpFCusoEb1j51s3Roxe0MP9VIrc4aeO4RU5ZoKjsNEM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ULbgNC5miRVlwaC0Hz7D23V/HP9C70GcyKcK+QIiUi90vlKSRKvLEGVdJg5dFWaGdhvUuQFcDc3H8YyTv/mkR5LmEEp9fXE9htuSqtcL2C705Y7MbiLPF0LgYe/QOh1E53TuHwLLJNctghG5BOl7znWtOmwawcJKJ5XS1tHHLqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 1C22419201C9;
	Fri, 18 Apr 2025 14:45:44 +0200 (CEST)
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id d52mTfjc6r2n; Fri, 18 Apr 2025 14:45:42 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (89-148-98-50.pool.digikabel.hu [89.148.98.50])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id 2106C19201A2;
	Fri, 18 Apr 2025 14:45:42 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id DFCAD1411E4; Fri, 18 Apr 2025 14:45:41 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id DBF80140604;
	Fri, 18 Apr 2025 14:45:41 +0200 (CEST)
Date: Fri, 18 Apr 2025 14:45:41 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Jeremy Sowden <jeremy@azazel.net>
cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH ipset 2/2] bash-completion: restore fix for syntax
 error
In-Reply-To: <20250207200813.9657-2-jeremy@azazel.net>
Message-ID: <0c582b07-9403-9525-e7b4-8b6efa0ed15b@netfilter.org>
References: <20250207200813.9657-1-jeremy@azazel.net> <20250207200813.9657-2-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-deepspam: ham 0%

Hi Jeremy,

Sorry for the extremely long delay: your patches were set aside then were 
forgotten. Both of your patches are applied.

Best regards,
Jozsef

On Fri, 7 Feb 2025, Jeremy Sowden wrote:

> There is a syntax error in a redirection:
> 
>   $ bash -x utils/ipset_bash_completion/ipset
>   + shopt -s extglob
>   utils/ipset_bash_completion/ipset: line 365: syntax error near unexpected token `('
>   utils/ipset_bash_completion/ipset: line 365: `done < <(PATH=${PATH}:/sbin ( command ip -o link show ) 2>/dev/null)'
> 
> Move the environment variable assignment into the sub-shell.
> 
> This fix was previously applied in commit 417ee1054fb2 ("bash-completion:
> fix syntax error"), but then reverted, presumably by mistake, in commit
> 0378d91222c1 ("Bash completion utility updated").
> 
> Fixes: 0378d91222c1 ("Bash completion utility updated")
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  utils/ipset_bash_completion/ipset | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/utils/ipset_bash_completion/ipset b/utils/ipset_bash_completion/ipset
> index d258be234806..fc95d4043865 100644
> --- a/utils/ipset_bash_completion/ipset
> +++ b/utils/ipset_bash_completion/ipset
> @@ -362,7 +362,7 @@ _ipset_get_ifnames() {
>  while read -r; do
>      REPLY="${REPLY#*: }"
>      printf "%s\n" ${REPLY%%:*}
> -done < <(PATH=${PATH}:/sbin ( command ip -o link show ) 2>/dev/null)
> +done < <(( PATH=${PATH}:/sbin command ip -o link show ) 2>/dev/null)
>  }
>  
>  _ipset_get_iplist() {
> -- 
> 2.47.2
> 
> 
> 

-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
