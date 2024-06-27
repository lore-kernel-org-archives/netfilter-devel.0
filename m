Received: from smtp2-kfki.kfki.hu (smtp2-kfki.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A836195F22
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2024 14:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719497710; cv=none; b=CF7MmCd2a1+FVeFkulr+NuvbyNOXBdRPjpETNcMNh78HefS1x0Y1k4x8e1C4OI66vQvXfgnNH4fJVPvcPWFI2hKslIYjsdANcmrqF/wHI9re/8gMlO+BqGyUHpECkE7wWOlj2SLvCa7t++VAwJg4OjA9znmfsXImaPwsmP0j6L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719497710; c=relaxed/simple;
	bh=H3Ggetyk+BQDcqc4/m4tZc0F2Mx6Ld1wb9ZMfpi1fTQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=fod6c7ckg/lv6RB3dq5kG8ZYQSJI6WLfef2Qpklnw8XAtACB/CKKXmiWAwlOXvF1IZDs7z1HVW4D/+wp4Cs4xS9fpyIGt+bgNnfy/z1jnGC4t1n53Jwnbze8SS/svW52ieHK7EmSukr1aIFuOAyPqbGjCRs6nbLVsezIWoPOUpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 9C3FFCC00FF;
	Thu, 27 Jun 2024 16:05:52 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Thu, 27 Jun 2024 16:05:49 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 82E1FCC00E6;
	Thu, 27 Jun 2024 16:05:49 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 653FF34316B; Thu, 27 Jun 2024 16:05:49 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 643BB34316A;
	Thu, 27 Jun 2024 16:05:49 +0200 (CEST)
Date: Thu, 27 Jun 2024 16:05:49 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [ipset PATCH 0/3] Two fixes and fallout
In-Reply-To: <20240627081818.16544-1-phil@nwl.cc>
Message-ID: <6ccd1b19-9dd8-c1fb-1b97-684ea0ca053a@netfilter.org>
References: <20240627081818.16544-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII

Hi Phil,

On Thu, 27 Jun 2024, Phil Sutter wrote:

> Fix two cases of illegal memory access and speed up the testsuite while
> waiting for results.
> 
> Phil Sutter (3):
>   lib: data: Fix for global-buffer-overflow warning by ASAN
>   lib: ipset: Avoid 'argv' array overstepping
>   tests: Reduce testsuite run-time

All patches are applied in the ipset git tree, thanks!

Best regards,
Jozsef

>  lib/data.c              |  3 +++
>  lib/ipset.c             |  4 ++--
>  tests/resize.sh         |  4 ++--
>  tests/resizec.sh        | 32 +++++++++++++--------------
>  tests/resizen.sh        | 49 ++++++++++++++++++++---------------------
>  tests/resizet.sh        | 40 ++++++++++++++++-----------------
>  tests/setlist_resize.sh |  4 ++--
>  7 files changed, 69 insertions(+), 67 deletions(-)
> 
> -- 
> 2.43.0
> 
>

-- 
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
           H-1525 Budapest 114, POB. 49, Hungary
