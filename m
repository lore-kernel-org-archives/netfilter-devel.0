Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A962040BF;
	Fri, 20 Jun 2025 06:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750402450; cv=none; b=spnvUmZNxX9n6p90odCZyx3NBZ2jZ0SPY+WUtpvFgJz+zO0oFwR+AGAXBs0Q0LMKj81v17mFprBRumiKFE0NMTZaxK3EKBatV3ZielN3Ed0A1Lu7TGPwXZsGTSgbr/j9XavlSnU6NcIVMrQeBYRMRvMmYuqOme5pNWCw+0vI7J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750402450; c=relaxed/simple;
	bh=lgwENIswP6TC+e9bW4gAogyCy5Hbq7Jl3EakK7exmW4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=pTOWYAKKb5KFj9TeoTzTluZQfy3r2yaQ1Yujr25wJRJEkBFHCcTykzDeTJh0w/KVqZU8/KdG0ZxVDFUBRHjNWCIlQykoXo3UhAx+FSDwx1F141dzd6ltxXMKX+AblnouyjVEn7KLeIE580wUGqfeUFZBieII0g/WBfKV9dwUvY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=ATpenuT8; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="ATpenuT8"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4bNnyW340Jz7s854;
	Fri, 20 Jun 2025 08:44:35 +0200 (CEST)
Authentication-Results: smtp012.wigner.hu (amavis); dkim=pass (1024-bit key)
 reason="pass (just generated, assumed good)" header.d=blackhole.kfki.hu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1750401873; x=1752216274; bh=qlN0vM/2kA
	7L+wHurXa4gpLzRVhLapor1sHI9gEcD/I=; b=ATpenuT83DH/8OCovjgncJFnZn
	sbGTiYEY19FV/JBv5zTJpCOneGOHRgrAgZ8AUBNyLcgiYVsjaA63y31E+35ZuBR+
	DJC52YRpTh1gilO+bsHhrXmn2lBZ+M6ZWjAqPAa9eDpUefKSxkQr3fnJsdbZ+gPD
	O5W9ZazMpxMsZExWc=
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id pWl8-2k23QH5; Fri, 20 Jun 2025 08:44:33 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4bNnyT3Z37z7s852;
	Fri, 20 Jun 2025 08:44:33 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 70FC934316A; Fri, 20 Jun 2025 08:44:33 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 6F6F7343169;
	Fri, 20 Jun 2025 08:44:33 +0200 (CEST)
Date: Fri, 20 Jun 2025 08:44:33 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: RubenKelevra <rubenkelevra@gmail.com>
cc: Jozsef Kadlecsik <kadlec@netfilter.org>, 
    Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org, 
    coreteam@netfilter.org, netdev@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: ipset: fix typo in hash size macro
In-Reply-To: <20250619151029.97870-1-rubenkelevra@gmail.com>
Message-ID: <4497e54a-efa0-dcb5-7f37-5de8197b5496@blackhole.kfki.hu>
References: <20250619151029.97870-1-rubenkelevra@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="110363376-1299534835-1750401873=:6759"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-1299534835-1750401873=:6759
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 19 Jun 2025, RubenKelevra wrote:

> Rename IPSET_MIMINAL_HASHSIZE =E2=86=92 IPSET_MINIMAL_HASHSIZE in
> ip_set_hash_gen.h, matching the header typo-fix. Keep a backward-
> compat alias in the header for out-of-tree users.

I don't think there's any need to keep a backward-comptibility alias: the=
=20
macro is absolutely internal and don't even used outside of this file.

Could you resend your patch without it?

Best regards,
Jozsef

> Signed-off-by: RubenKelevra <rubenkelevra@gmail.com>
> ---
> include/linux/netfilter/ipset/ip_set_hash.h | 4 +++-
> net/netfilter/ipset/ip_set_hash_gen.h       | 4 ++--
> 2 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/netfilter/ipset/ip_set_hash.h b/include/linu=
x/netfilter/ipset/ip_set_hash.h
> index 838abab672af1..4f7ce4eff5815 100644
> --- a/include/linux/netfilter/ipset/ip_set_hash.h
> +++ b/include/linux/netfilter/ipset/ip_set_hash.h
> @@ -6,7 +6,9 @@
>
>
> #define IPSET_DEFAULT_HASHSIZE		1024
> -#define IPSET_MIMINAL_HASHSIZE		64
> +#define IPSET_MINIMAL_HASHSIZE		64
> +/* Legacy alias for the old typo =E2=80=93 keep until v6.1 LTS (EOL: 2=
027-12-31) */
> +#define IPSET_MIMINAL_HASHSIZE		IPSET_MINIMAL_HASHSIZE
> #define IPSET_DEFAULT_MAXELEM		65536
> #define IPSET_DEFAULT_PROBES		4
> #define IPSET_DEFAULT_RESIZE		100
> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipse=
t/ip_set_hash_gen.h
> index 5251524b96afa..785d109645fed 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -1543,8 +1543,8 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, stru=
ct ip_set *set,
>
> 	if (tb[IPSET_ATTR_HASHSIZE]) {
> 		hashsize =3D ip_set_get_h32(tb[IPSET_ATTR_HASHSIZE]);
> -		if (hashsize < IPSET_MIMINAL_HASHSIZE)
> -			hashsize =3D IPSET_MIMINAL_HASHSIZE;
> +		if (hashsize < IPSET_MINIMAL_HASHSIZE)
> +			hashsize =3D IPSET_MINIMAL_HASHSIZE;
> 	}
>
> 	if (tb[IPSET_ATTR_MAXELEM])
> --=20
> 2.49.0
>
>
--110363376-1299534835-1750401873=:6759--
