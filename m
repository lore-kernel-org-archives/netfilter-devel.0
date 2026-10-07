Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991263290D1
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Oct 2026 23:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791416209; cv=pass; b=k0jWVC65FvXfZZrUzGVtZ2REZvRM3yH4TtnKlVDSvWD7AnjcwmIpPdzvZapFELPL0/jqaHkoq3WcSZCigGNnnRKx1hLyySiAAxtI7fEqi8/QZTkwdPPf9gNOtteGjjwhma5wU/W93amoMkcip43NVKkjEsy+iRFd9ID9furseGg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791416209; c=relaxed/simple;
	bh=YW7ppVeoRLVQCLnGvfkZ3DPxaXrIg4n4TYyY9tNYUuU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gRrxfFrSlizar7jHSVSsvS+rjBI1AxEcL7iumSUkkueKHpeb7leTeylMmIR2OouscaHGMxLUNTa1mIES6kWRPFhZInV2WMhU4YBFAzAxm1Yy+6d9WVZMsb1bqz5xd7G+QDY0fpjJKRcPpHp3rjJ+ehpUOJVFPzr7a/++5T/5X1o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qSXDPnFz; arc=pass smtp.client-ip=74.125.224.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qSXDPnFz"
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-66c7e3a2332so3424157d50.2
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Oct 2026 16:36:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791416206; cv=none;
        d=google.com; s=arc-20260327;
        b=VlTA/mKppG4mNreMIU1FrDV7XHUpjRbym1atqqkKtzkRQNtEYSUnGmou/6B3nsb8LO
         B3Sxv4KeXaTYPhTFA/61Tj0/F+I9xRZuLcqXxPx2ukKS5UV4bfDcVDKgocDT7NWUaBzA
         W7J7WqFQUgWrGpm4vtUOfS3HZMn+z1n8ovTb6bH3TCTAv7NMxo5VyR7M61snCTDE1pRM
         O9Nqw8W7GzeGGcvU5X5tJSz8DCw0YTYcICZ+cPIXEKPfHt1Z9LJoF3TQ3f4myjjcZi0R
         iIF3GX4gGGltmqwF/uWKojxc43qGUs0t8LmR/yGw2W0PdCJJB9hvTaeKjENG+gWHh8nZ
         mBmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YW7ppVeoRLVQCLnGvfkZ3DPxaXrIg4n4TYyY9tNYUuU=;
        fh=KeUmxfHcH1nrXDP22kr/pv4sp4rMoG7gILc7EI3nXOA=;
        b=cNOb/hqxoRRP6aB2UwzEkc4qwQPkObI8lBbEzGhk2NQNyW06anlagnrUir5wIdJ3Xu
         wZZwszVEtom0uXUKAV/HQALaJ08eN+JI3Sl4DvawotirvmKqSw0Nyw0Lxfw66UUydyT8
         YI8TOB9VCzm4lLACI2HcD2Xit9ugbUhg1ne1D3u+GFIJgVrY+GOKmrfukNWNKvl5RK6a
         UGiJmEs3+9b5qYY0oMIwdc6KIZ8Qn4USpabJuHgvpY4aEbG2IJCVx8SlSMI/jHX5wtKc
         At7uVE+7BuJ1wZjLpYPv3gRaHPrteYaPTguWJIEIgdiKmUE5EpOehOVkWoGG9wrn2vfI
         59aA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791416206; x=1792021006; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YW7ppVeoRLVQCLnGvfkZ3DPxaXrIg4n4TYyY9tNYUuU=;
        b=qSXDPnFzOgu1X/v4N/tt4GN26skSKHLDR0E0tu7JR5k8wGhuC8zYDK2vhdNvk88i1A
         I+Xyx6+Dh+AhvMnUF7ulNkD3qLEfXCV1xPEmVAkRRBrHsAdn9fecAo+HoGop13Yr1mwJ
         wHHO7dqerVtI8ScFlq4mhdTKxthUvVYEVk0zHQz9beaEkWuB0T5h59+7b3xmkFanfK02
         4N9iGuNMwiXgTs2lG8t7AOe6muH9E9eLWRr5hzPDCdb9qx/OnV/tgiBzWweGmUuiSObK
         +GoXxtqqdIXOYahnOCJlS7vENi204Ob+SsyBFzoZoRMPQbeLf8AH9XZSjgPWK6s1yuf5
         ARdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791416206; x=1792021006;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YW7ppVeoRLVQCLnGvfkZ3DPxaXrIg4n4TYyY9tNYUuU=;
        b=YUJlgAwGvJVOvvROGrFNt9c+z9EhEXfG0k8/BVi3taKsG4PriPG0OgaKmysYMfAitV
         upgn7UlBO+0RUQG27c1y/7ubaQHxQgy9gFHyQpoaeK7Ty7X/ihlexdJve2MayL1IcqnG
         Z/DT9J2EZ2R+QMz0Y/Z0YIXtd1O6eHCssT5QXOBbzdUfDfRzWLPJfOW0ohOSm/HUyqUv
         zXPJ0iszAsPKrcnpDUzm5IwIrrwGjGv1QFrTHbsUNM0n1takAe4RQo+GebFXXxRrBL3y
         ao5zV1qlhoJsAKn4c3B6doC4ljAluJ9ENTUPJomqpbseBx3ChnoNPfnOhuJQ4dT+Iv0E
         kezA==
X-Forwarded-Encrypted: i=1; AKwUvBzLotOS7oE93BrBGzTP4C+ZMTCvfPrv4+k2UO7zFwYMKgbnLnAjLnuzXiLLLb31OU/pdkao+iUaIVU1HZgi9io=@vger.kernel.org
X-Gm-Message-State: AFq9FYLxk73AM6xjFqfbeDmwJ9wQtV29Vnzc/ZTbCAYIcNmfGASQ3LIh
	IhfiU1GsSAmaUUU8wWLUh4KjukKab/UjcABHAPTlzh0V6lUidpF4iNurP5MgklAF/Wf/bUKqmYA
	OFSPoTCbA0PruZKrTz+zcGftaRlVuhds=
X-Gm-Gg: AYBFou1tE3cuMVmPFce88V8A5Uv0xCBKX5/Cd4vffnZLSPn4/gHlxOMyH0Grjp60vUA
	BF8XY7j+g19/bQH/ZXckCbocs1kdekZH0pfuukQWrcfJUd0vaQdTg7/w6PA1DOYTlmyKmQsL5GL
	abc068/lE+ncOCJW2NjzyBK2OUOvaE1SoIiWlgYyAMDwDvZQdwpis+mtvk499zMU0Doc25V8Ef1
	MKR1yIPdFRam8AgM03ftGK4SFkwWDjAsxmH9w7wF5wDA6r6U8zswB612rNX+jYFMwyFr2snzxzt
	YTaOHTS6L2oyAzEv7VbjHX5188F3BvxEJ6XGuZUkeC0nejvnEB1BQp1XzxqUXWDg6EwDkp8IKIr
	OipC3p3zfAZ7FDbZo2faHAA18KQJmY9eEw4Hm77cEbObkuck5LNoFj3/eykSSjDAqEwfT/kzWS8
	c=
X-Received: by 2002:a05:690e:4853:b0:677:c24d:ebfa with SMTP id
 956f58d0204a3-6790a3eaa26mr994855d50.58.1791416206358; Wed, 07 Oct 2026
 16:36:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0a012b4923e189c4c593ef4f471e5ff0edbe9030.1791412497.git.mst@redhat.com>
In-Reply-To: <0a012b4923e189c4c593ef4f471e5ff0edbe9030.1791412497.git.mst@redhat.com>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Wed, 7 Oct 2026 19:36:09 -0400
X-Gm-Features: AclHuK9jyyf5sYugVmTQQFcLaa4pyEtdizNnLZGPpZtB9PsCE0-Mfu-D4Td6hn0
Message-ID: <CAF=yD-L_sv90qxUxEh6HRrz3mHMRP=WK3smkMMYScLAnJbgTpA@mail.gmail.com>
Subject: Re: [PATCH net] ipv4: validate checksum_start before completing checksum
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>, 
	Ido Schimmel <idosch@nvidia.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
	Phil Sutter <phil@nwl.cc>, Nikolay Aleksandrov <razor@blackwall.org>, 
	Steffen Klassert <steffen.klassert@secunet.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, bridge@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 7, 2026 at 6:42=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com> =
wrote:
>
> If a packet with bad checksum metadata gets into the ipv4 stack,
> skb_checksum_help can corrupt the network header and cause a bunch of
> mischief.
>
> This was discovered and reported by Paulos, and has been reporoduced

(minor) typo: reproduced

> by others independently since.
>
> We really shouldn't allow such packets in, but as a defence
> in depth measure, let's also check before we complete the checksum.
>
> A more complete validation at input is forthcoming, but needs more work.
>
> Assisted-by: LLM
> Fixes: f43798c27684 ("tun: Allow GSO using virtio_net_hdr")
> Fixes: bfd5f4a3d605 ("packet: Add GSO/csum offload support.")
> Reported-by: Paulos Yibelo <habte.yibelo@gmail.com>
> Closes: https://lore.kernel.org/netdev/20260922030310.8684-2-habte.yibelo=
@gmail.com/
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Cc: stable@vger.kernel.org

Reviewed-by: Willem de Bruijn <willemb@google.com>

One point about sending as a single patch touching five separate
modules: nf_br_ip_fragment was only introduced in Linux 5.3.
Such a block is probably easily dropped from a stable backport.
A single patch is likely still preferable over splitting into two
(core + optional) or even five (one per module) patches.

> ---
>
> Lightly tested.

Tested by me as well and found to block the known bad input.

Touching five modules is not ideal, but could not find any other
approach that would be preferable: low risk of unintended
consequences, out of the hot path, and relatively concise.
