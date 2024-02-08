Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434811E89A
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Feb 2024 14:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707403889; cv=none; b=vDmKDZtZWiUwH019V2w4P6xn5h8F6Jy1cYkoLNo7gmkUaJ1brgnmnyDwDPZyklZVC/EH5vuJK/sRom9XocjdZMffpBJtj7VtUMzLDw9Tc72ysTrj8kLO8ODmqVnoNk49KQ9DDzr74UXHqDr2be6w3Oz6/1q2lu0RwSHK1OingyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707403889; c=relaxed/simple;
	bh=PnXF/Gd8YRKSguHh37uq60GaYpLUTqAbu0tKhAqRZ1I=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=F3vylXJa02C+1ZxBxLvpRFRg/jR6/42gTUV9VcMi/LyS3oJG9wvOMB/jP4+b4PDCDl60lW4eu+leK6EixFbcXRe6ivKh3WYBBdaZW9Ejl9NeiUKw+HS58YsXTAjzn46AesX59lmNy8uhMDx+GdOHeNbZczfkhBy0Nvq+JnpVsoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f+WngWlq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f+WngWlq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707403886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qkQtNh8jP1WG2/VKjAx6L9mr0/7PuxydcQwlwUxlrXM=;
	b=f+WngWlqnNXi0wa17aoJDURSn0WddP+zPOC46RWnwPYY4TrCWYdhTnGlCwyUNPWnNav02G
	RrQkXBt5CG1Isdzc1dxj4kP0S3h6xTYbhTsejWJ8GEEAoYfSEZInm8xRGcgeSinDknrfQm
	ZKuRUjWaEZ2oQPOQcPna7wfcAmC9PVc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-aa76lPBsMBCCdx5518xsGA-1; Thu, 08 Feb 2024 09:51:24 -0500
X-MC-Unique: aa76lPBsMBCCdx5518xsGA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4103bb38a68so1416535e9.1
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Feb 2024 06:51:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707403883; x=1708008683;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qkQtNh8jP1WG2/VKjAx6L9mr0/7PuxydcQwlwUxlrXM=;
        b=aHzZfMSvmOMGFlNyqou9DpvSId3IQYmw/Y97T85amGUjT3w9Hce0UIPwIKwrLuFNtY
         rT8V3VR/pwABLceqnErYBxbrxpLW6elRsXXfn7AnzMN9JvuU5nLw3rG3IpJE0qdd+7dm
         yN0xHI+ewrndW64vIpKPZrMk0rAdwNr0HqoL5pQ8QIbKhXEcKm7uKpnUXtKEGI7+UB7U
         RvuYuEPO8LJEIvtmd24J/206PO32tviBk2K8sNJPQoN+fyxyf1iNbee0tTehO2gBZ0yw
         CKcsikyQ3DkwFt9L1epyKg/4Qwn5bo6lGhdJjb9h0QvIoUGI8NWE58ejgTzZjbsf6zky
         6NFA==
X-Gm-Message-State: AOJu0YxA0qPyZbhAt5AFlFqNjiK5RXeRrdtaJiZ9w2oURxG4m1RcKDEA
	9rxsrRrapn9fqBTJQKo7Aj1nJv+bh4FBtLPkbtOv6tnFp2Jo26CVQEb+1Y2hh9JID3pjqf48Yqm
	1ThmaE7XhraiCo4P2vuBtnGECRbRzKL27CVedeE+d6M1PizFWt7hcXSvcozUqdb56eg==
X-Received: by 2002:a5d:554e:0:b0:33b:4d82:a487 with SMTP id g14-20020a5d554e000000b0033b4d82a487mr3800378wrw.1.1707403883635;
        Thu, 08 Feb 2024 06:51:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF5f8fJGRwG6tiIElOk1Iah8S/w5bPK5WxvBhpAiq5h7GnNrurd85U9lNrA/779xuzHRCj4VQ==
X-Received: by 2002:a5d:554e:0:b0:33b:4d82:a487 with SMTP id g14-20020a5d554e000000b0033b4d82a487mr3800366wrw.1.1707403883265;
        Thu, 08 Feb 2024 06:51:23 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVJRK6YNrVSuNqMTYse71kqucy9yY4kwzCMajkissJrTJBrwJ7ttDpxgw14so6qUBt7C3SsFab8lUMPkFGdWOQmqDX41migoKt/sxnuxeAY50FPQlelkCEJzztlNEnMFoPVrJJVxMnJVeV9Oqc7tH4G+a4D7V9Bm9lTK+nq98Hw/7UDF++ADZrpOl3w7hkYrDgn+uH0BmV24jUHraSa+1+ktBmXD1ozcX7iNHiL8pB1Qz5BugE+C2CW7Wo=
Received: from gerbillo.redhat.com (146-241-238-112.dyn.eolo.it. [146.241.238.112])
        by smtp.gmail.com with ESMTPSA id o8-20020a5d62c8000000b0033b1b01e4fcsm3734207wrv.96.2024.02.08.06.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Feb 2024 06:51:22 -0800 (PST)
Message-ID: <c7165858c53bf9385e0fe510b34da2c91a7342bd.camel@redhat.com>
Subject: Re: [PATCH net 01/13] netfilter: nft_compat: narrow down revision
 to unsigned 8-bits
From: Paolo Abeni <pabeni@redhat.com>
To: patchwork-bot+netdevbpf@kernel.org, Pablo Neira Ayuso
 <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net, 
 netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com, fw@strlen.de,
  kadlec@netfilter.org
Date: Thu, 08 Feb 2024 15:51:21 +0100
In-Reply-To: <170739542966.30179.12730184449437976359.git-patchwork-notify@kernel.org>
References: <20240208112834.1433-2-pablo@netfilter.org>
	 <170739542966.30179.12730184449437976359.git-patchwork-notify@kernel.org>
Autocrypt: addr=pabeni@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 (3.50.3-1.fc39) 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2024-02-08 at 12:30 +0000, patchwork-bot+netdevbpf@kernel.org
wrote:
> Hello:
>=20
> This series was applied to netdev/net.git (main)
> by Pablo Neira Ayuso <pablo@netfilter.org>:
>=20
> On Thu,  8 Feb 2024 12:28:22 +0100 you wrote:
> > xt_find_revision() expects u8, restrict it to this datatype.
> >=20
> > Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for=
 x_tables")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  net/netfilter/nft_compat.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> Here is the summary with links:
>   - [net,01/13] netfilter: nft_compat: narrow down revision to unsigned 8=
-bits
>     https://git.kernel.org/netdev/net/c/36fa8d697132
>   - [net,02/13] netfilter: nft_compat: reject unused compat flag
>     https://git.kernel.org/netdev/net/c/292781c3c548
>   - [net,03/13] netfilter: nft_compat: restrict match/target protocol to =
u16
>     https://git.kernel.org/netdev/net/c/d694b754894c
>   - [net,04/13] netfilter: nft_set_pipapo: remove static in nft_pipapo_ge=
t()
>     https://git.kernel.org/netdev/net/c/ab0beafd52b9
>   - [net,05/13] netfilter: ipset: Missing gc cancellations fixed
>     https://git.kernel.org/netdev/net/c/27c5a095e251
>   - [net,06/13] netfilter: ctnetlink: fix filtering for zone 0
>     https://git.kernel.org/netdev/net/c/fa173a1b4e3f
>   - [net,07/13] netfilter: nft_ct: reject direction for ct id
>     https://git.kernel.org/netdev/net/c/38ed1c7062ad
>   - [net,08/13] netfilter: nf_tables: use timestamp to check for set elem=
ent timeout
>     https://git.kernel.org/netdev/net/c/7395dfacfff6
>   - [net,09/13] netfilter: nfnetlink_queue: un-break NF_REPEAT
>     https://git.kernel.org/netdev/net/c/f82777e8ce6c
>   - [net,10/13] netfilter: nft_set_rbtree: skip end interval element from=
 gc
>     https://git.kernel.org/netdev/net/c/60c0c230c6f0
>   - [net,11/13] netfilter: nft_set_pipapo: store index in scratch maps
>     https://git.kernel.org/netdev/net/c/76313d1a4aa9
>   - [net,12/13] netfilter: nft_set_pipapo: add helper to release pcpu scr=
atch area
>     https://git.kernel.org/netdev/net/c/47b1c03c3c1a
>   - [net,13/13] netfilter: nft_set_pipapo: remove scratch_aligned pointer
>     https://git.kernel.org/netdev/net/c/5a8cdf6fd860
>=20
> You are awesome, thank you!

FTR, the patchwork bot went wild, I pulled _v2_=20

Cheers,

Paolo

