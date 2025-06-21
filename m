Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2B4E56A;
	Sat, 21 Jun 2025 14:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750517646; cv=none; b=VJo3PnYorZ+o49RdaRkn7knnRe7ceqV+3EHVziRGhGVxcJUNlhc5F3LNtax5YBXzAoVroyTKWr1A6z0y9rYAgnGQKWRhqB2nHvRsbasffls4RDVK+66Fc/D0JYpO8Ud7WkePMp05wiSnqGv6X3u6al/hvnqXdSjniIL12x6IhI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750517646; c=relaxed/simple;
	bh=Q8FDZihT0rIgE8dqYjKRtD5Nrn5OypH+gWUtZ6hkqw4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=BcnvKc+yXJiV/ofT9HkFfjNUC4hgukTrwhRFnaiUTrF/sFU/5081C/M43U4eVRYaBsrcEcJm2TbTiW8/6CnyTfO7076bx4dD6KLtm3+usu7ciNbrUnK0OCpODCNok44FH+94IJEUTtZv5Eqn0JHQKIVXbG+1+Tpi11HONEsqhxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4bPcZb0xXWz3sb80;
	Sat, 21 Jun 2025 16:45:11 +0200 (CEST)
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id Yr-XXvThqecK; Sat, 21 Jun 2025 16:45:09 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (unknown [148.6.192.8])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id 4bPcZY1q8fz3sb7s;
	Sat, 21 Jun 2025 16:45:09 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 1C0ED140EA3; Sat, 21 Jun 2025 16:45:09 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 17F4F140184;
	Sat, 21 Jun 2025 16:45:09 +0200 (CEST)
Date: Sat, 21 Jun 2025 16:45:09 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: RubenKelevra <rubenkelevra@gmail.com>
cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org, 
    coreteam@netfilter.org, netdev@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: ipset: fix typo in hash size macro
In-Reply-To: <20250620092053.180550-1-rubenkelevra@gmail.com>
Message-ID: <11f4f9cd-e818-099e-b8b2-782608862eb5@netfilter.org>
References: <20250619151029.97870-1-rubenkelevra@gmail.com> <20250620092053.180550-1-rubenkelevra@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1275113213-1750517109=:3235"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1275113213-1750517109=:3235
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello,

On Fri, 20 Jun 2025, RubenKelevra wrote:

> Rename IPSET_MIMINAL_HASHSIZE =E2=86=92 IPSET_MINIMAL_HASHSIZE in
> ip_set_hash_gen.h, matching the header typo-fix.
>=20
> Signed-off-by: RubenKelevra <rubenkelevra@gmail.com>

Patch is applied in the ipset git tree, thank you.

Best regards,
Jozsef
> ---
>  include/linux/netfilter/ipset/ip_set_hash.h | 2 +-
>  net/netfilter/ipset/ip_set_hash_gen.h       | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/include/linux/netfilter/ipset/ip_set_hash.h b/include/linu=
x/netfilter/ipset/ip_set_hash.h
> index 838abab672af1..56e883661f857 100644
> --- a/include/linux/netfilter/ipset/ip_set_hash.h
> +++ b/include/linux/netfilter/ipset/ip_set_hash.h
> @@ -6,7 +6,7 @@
> =20
> =20
>  #define IPSET_DEFAULT_HASHSIZE		1024
> -#define IPSET_MIMINAL_HASHSIZE		64
> +#define IPSET_MINIMAL_HASHSIZE		64
>  #define IPSET_DEFAULT_MAXELEM		65536
>  #define IPSET_DEFAULT_PROBES		4
>  #define IPSET_DEFAULT_RESIZE		100
> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipse=
t/ip_set_hash_gen.h
> index 5251524b96afa..785d109645fed 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -1543,8 +1543,8 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, stru=
ct ip_set *set,
> =20
>  	if (tb[IPSET_ATTR_HASHSIZE]) {
>  		hashsize =3D ip_set_get_h32(tb[IPSET_ATTR_HASHSIZE]);
> -		if (hashsize < IPSET_MIMINAL_HASHSIZE)
> -			hashsize =3D IPSET_MIMINAL_HASHSIZE;
> +		if (hashsize < IPSET_MINIMAL_HASHSIZE)
> +			hashsize =3D IPSET_MINIMAL_HASHSIZE;
>  	}
> =20
>  	if (tb[IPSET_ATTR_MAXELEM])
> --=20
> 2.49.0
>=20
>=20

--=20
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef=
@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
--8323329-1275113213-1750517109=:3235--
