Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B139B4CF485
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2026 19:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792177876; cv=pass; b=uI1LCzIyUlBAfZMH1BpW3aDVWXpjn2ihG3AFKRBfmn7jYob12+huHuYNFaxG4ZQx6Ycr++et9hVjb1qoC5zWbui5DbW2r4Dxh/5twv+y7OOUFCoD/Dhp4hoHmrRJTQdV0r3DctbWZR99gqLXXjIsV/ilEhjbhG+Y+GzXWfjNBjo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792177876; c=relaxed/simple;
	bh=qppVgsYFvGGhHcWK5q8fwgXEoXbm8x8Kajt5Kyll45Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GxgCexgAt0/E4orv77ao9c4+JOFLV3kxfPC+OklC99NgLC/HkEnxFAtjwbxvw+KiAU7nrcltc4SS69E2k8JCbZGnO3URczc7uUtMIfGUtpfpBNVrkEjpyLAWK2KJO3bRMAjOfSjN2srVJ4hmKgdS1196iiTxpb2WFpZh0hw+OzA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lNYHVnir; arc=pass smtp.client-ip=74.125.224.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lNYHVnir"
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-6711f05fb14so299253d50.2
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2026 12:11:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792177874; cv=none;
        d=google.com; s=arc-20260327;
        b=QXgeooWp9VkRBsOcIdR0PtYIvJepRTlWtt/GonafE213O4T5ZEo1Dd3JXlC6TDJxLy
         TrG6TrlpYMhl+HcLsA4zbTf7GRYlABv+39gtztgDmsZAR5uyIL7Fqy8Q3uFKAYFVYjDd
         FVBtlcCBC80MJm7H4/6/wOdc2KzjwYwVtp48LQEYtkKNHzb+BgRSF/9tMyVPgpNyQb7l
         1UmJiWOHFE+xup6VJI+G3hVosyLJXn+m5H8s4pz6bdt+AtWfxlx9HNcbQQDeD4SXBx2y
         TSpXFtOrwCuLd1onSyNr8VY643hROlZf1q1i/0ZwGkvefMP6EqfGT6wEcdFxEUuG17Cf
         hYWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rcM0e5h6kl2DJj3y8GjJ9yn5THeHomwVF5DySO9cYxc=;
        fh=0rFFOgeFacUKG+/QhmQBJyQdUfzWBeD9pQt0KUamofA=;
        b=DqdY1EL/OGvg9JmHQe8awD+jZ1WJYvFFXwXN6yB5rh3Li7dyWOT/HHncfGdjoG+O3Q
         f7lTirF5HYElh3qqUfK+le6b01sr2B9UQKN5BFFvMEQOy8xIkGt05+1ANkEyr9qmNjQU
         cr8GRajXYYtIcFGrnIR8xsoglIIZnovZiO9SvAr80F7shSzDqfTULev3W7WoIqTDcNGC
         C4LbznCpbRX+Mj3AaycEPI1OMuB9oM+xg+gzOAxXy4vh021Z16cZY506NoZJj0k8YSH9
         GMAN+Yu/WCPCj/vRGVjZpB7YcjlyzqENrkiDJ2qM5GX753lVVK9h2lnthsG2V/WXDr7p
         1F8Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792177874; x=1792782674; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rcM0e5h6kl2DJj3y8GjJ9yn5THeHomwVF5DySO9cYxc=;
        b=lNYHVnirjmv/XVzkDQrJJrtTF9KNDAbXxawbFWCxJHjZruMMjPqAmhqeKnvX8Dhuvl
         FqHZWxxeA1e6BytDa6B6qWm88wVrLzwDEykURFCxQx3GhLCfSWQ8hX24aL5jkY+DOSeW
         a5LUkceNq6eXRyJXYk91Xsrolvl4ZLVSW09ID+JiLAiBJwZlMk/9roGrfDRIobieGdYA
         zRTfkxGvy0mJEEGWG7b8rFrA2HM049eB2dHGCNYgNMRsupgebUZYB35BuuWYyM+WZMB3
         UzicVHJkTFg9yRS0FeittYF0id7wNbKhs14p7mRXpKok2DzsraiYLJVstHVmYBs5nriU
         CoeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792177874; x=1792782674;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rcM0e5h6kl2DJj3y8GjJ9yn5THeHomwVF5DySO9cYxc=;
        b=Wr3Rpervd4FPoH2DAIKP11jHKPfNaD7ZGj03r/qgo8FU0jafHM0CrdiPOP/FMGqcQJ
         A/6y4kLI0d9ZP0Z4284vepnmek7KvGoW2jplReI+3FFda1NCK0GOc2oR4UNKRgpnpJbn
         3GkFc8Ag6hU4XgwopR/akxkv1iw8mLN1LdmKsvlQzRB9qgp3tSL7EplbfIlh8ZMe10iP
         G+a+okhODJXm1bpXyYZ8uYCC/nqPeVlQfpRfm0XbQRhdkW5CHoc8meziUHm0+NZh96Ld
         cHd715sOujQAausa4O+8ngshadgbdU0FXjwTK0kjHm6+4bPEikbhlw9zqioUR1vDL2+s
         nYGQ==
X-Forwarded-Encrypted: i=1; AKwUvBwQgBQupkjdVVWP8Mv5XahATkk4RvB7BNtpZO8ie8oWIZg3Bx4Cx49UvOhrw99UcS4jnmkmqtK0AKpPPPMUTHg=@vger.kernel.org
X-Gm-Message-State: AFq9FYKv+XKzneea6JLSZDlFCGzdPV1IIeoSV5y5pfPTH0xoodsVVnKl
	WfKrJinHppAY5Hf20dOeald8BsZD0qvIZrJmG/icfjA9e9X3teNFReF83vTJ8vwn7kW7gD3rMCp
	iXZz3IRuSUfUs0nG/JOoCAafsP/8bK38=
X-Gm-Gg: AYBFou1EYxNKfJeBhUzTNiYF7loeKjOQpx5LFvIZiwwqlvuOQiErNGizlyd/dSJcXKb
	EIhc2yA3Mk1/TPDcWTHUz+gb6rUHb7Yoyzx4v+vNhrA9dVB9wUA9F9y9nnxhewOVsIcXxNT4VZi
	dXxT+9I1QNKhe580Gf5UaW9d4QW5yYAmkeTV8lg8uKI1n70RBYZCJ6CgWAh/cPaka9EgYWWmuFA
	T4IQEtg5XNkrG47L3Jv7VPiZVvkibFnsY973ptHJdUZXkScubxuZzgwY/ffezoaexo02LDIffCV
	EZdho4NJzTJXjSvnee4jy+BlfG4tfgTnlKKeFUG9wLy7519yB3L5RSZ5xRheT31ddQ==
X-Received: by 2002:a05:690e:138a:b0:679:c9af:6d51 with SMTP id
 956f58d0204a3-679ca86652fmr108710d50.69.1792177873691; Fri, 16 Oct 2026
 12:11:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <179216146138.25460.7866279004288174372@gmail.com>
In-Reply-To: <179216146138.25460.7866279004288174372@gmail.com>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Fri, 16 Oct 2026 15:11:02 -0400
X-Gm-Features: AclHuK82Reo9t1Q_XYkamM6mGKm-uUZWL-8Kv3QM6WU-oPDk-hAS-2iAswxeKCA
Message-ID: <CAEjxPJ7fLbBANfjcgN7Xa+axbQFE5ZALWzXxRz_kQ8zGvmw4Rw@mail.gmail.com>
Subject: Re: [PATCH] selinux: don't label bridged packets in selinux_ip_forward()
To: Joas Antonio dos Santos <joasantonio108@gmail.com>
Cc: Paul Moore <paul@paul-moore.com>, Ondrej Mosnacek <omosnacek@gmail.com>, 
	Paolo Abeni <pabeni@redhat.com>, Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
	Phil Sutter <phil@nwl.cc>, selinux@vger.kernel.org, 
	linux-security-module@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 16, 2026 at 10:37=E2=80=AFAM Joas Antonio dos Santos
<joasantonio108@gmail.com> wrote:
>
> With br_netfilter and bridge-nf-call-ip{,6}tables enabled, bridged IP
> packets go through the NF_INET_FORWARD hook, where selinux_ip_forward()
> calls selinux_netlbl_skbuff_setsid() and NetLabel may add or remove a
> CIPSO or CALIPSO option.  cipso_v4_skbuff_setattr(),
> calipso_skbuff_setattr() and calipso_skbuff_delattr() move the IP
> header and reset the network header, but the Ethernet header stays
> where it was; when the bridge pushes it back in front of the packet it
> picks up stale bytes and the frame goes out with a garbage destination
> MAC and EtherType.
>
> Labeling a bridged packet based on its IP addresses is not what we want
> here anyway, so leave bridged packets alone.  Add a stub of
> nf_bridge_info_exists() for CONFIG_BRIDGE_NETFILTER=3Dn.
>
> Tested with QEMU, two veths enslaved to a bridge with br_netfilter in
> the middle, SELinux and a NetLabel DOI 16 configuration, 5 UDP packets
> per case:
>
>   case                                        before        after
>   CALIPSO packet, unlabeled destination       MAC garbage   5/5
>   unlabeled IPv6, CALIPSO destination         MAC garbage   5/5
>   unlabeled IPv4, CIPSO destination           MAC garbage   5/5
>
> Routed packets are still labeled (an unlabeled packet forwarded towards
> a CALIPSO destination gets the option, 5/5).
>
> Fixes: 948bf85c1bc9 ("netlabel: Add functionality to set the security att=
ributes of a packet")
> Link: https://lore.kernel.org/netdev/CAHC9VhS+bdL_YnLQtd0sPmKKfy9BvS-LWV_=
6EhAuu4qfUFe_mw@mail.gmail.com/
> Suggested-by: Paul Moore <paul@paul-moore.com>
> Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
> Assisted-by: Claude:claude-opus-5-5

Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
