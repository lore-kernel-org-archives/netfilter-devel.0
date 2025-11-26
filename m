Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010C61F3BAC
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Nov 2025 04:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764130869; cv=none; b=YltnTY1byngT9acyq5TPYI8gvJ/ZIa5t2xK351lpGyxvPpbbhYjuh9Iuozk1+xwzPlfn9lG7wPUtVTwuf+I/qlrhkfrZB33unCarU4xAJvv1v4M1QeLCKHyylYKkQ+N2u1CKrsQWYMwJQ3k6UtWFkidyeFFqxR7j15Dr9pQ38nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764130869; c=relaxed/simple;
	bh=BkFlPk3+5nub7BZCjBNabDJurWqy94KOOmIC0GDOFag=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=is86EAeBoEYzjvQuh1fkiZOsxlhF2cBm67lkucKtz4pUSk48f33czR+malp9yd+rLOb+Sa05ZZRYSAGpRulRgqe0ocAevk9c6q6ewyyJnAJ2d5jDkdf8SQ31o4hM+b6aCWAeEKR9EmjruWbV0wa/rkLgyqTNeeRmSMhMnt9sZyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wq8STw7I; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wq8STw7I"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8738c6fdbe8so6247456d6.1
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Nov 2025 20:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764130867; x=1764735667; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v0WQSgW99+CubhdNpwBhumDm/WkmkjO1MJpCA99Mtzw=;
        b=wq8STw7IyUGWcGrc7dw3Gva1AS9pA2QBZhFX9gr/KZSVZVFOR5fJovp1KAggojgETd
         vQNr/alcRgVbDzGzRMtHkmD4hjKnJBt4tVxpInqaKcHJfQV8dwaCZEuWp++PCXBEqrBU
         orq24O9sLQrPYa51CQVJfsRc/AqW28bo4o/qInpsBUECxq7zr6BI8qwMhRfzTemaQ4d4
         Z0PsX2hW9mKsT131+wTT/hQxfCbzAcf7wEd/+kKrsYt0VSgaGic0Ln58gb1MwnP91Vzj
         pMM2jKLu4SNefx6nmZK5Z9bSirqb/9G4yPQ1jfjqiNsiJrcX+zxyoGto8r5va/m7YX/6
         Ed4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764130867; x=1764735667;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v0WQSgW99+CubhdNpwBhumDm/WkmkjO1MJpCA99Mtzw=;
        b=OGmz2gIVm42sFg+v1SPYmZ9BRXEguya4u3RJGGUtqlwvCgGNeMmIt1tY47LWu3+qeY
         adkrrSkDXTrb01LKUfEuMMreCYmXRapJEK0j50qGCeLCxEI4Mxwg1oclruCs/uAzZfk2
         4Tl+7RhAjh5rP2IQ4cUlK9Hszvro7Kbhf86O632tKSrX1uV4MXrapLGC8ZveiiRssHxC
         FY4dd85bOV9FEL06odeAiXOZNoEEsznEh0/VK8T4/eUJi8EMbhQQAVpbwsieZr7cPp8K
         ZaABso2CvfphqVpjdA3MmgjGdS9jz6VGWwyBwscKuT/6Fix0iOoioudCAm1qTWPJozWr
         pe9A==
X-Gm-Message-State: AOJu0YwS0Wbr2ScdIB8vvmC9Fx4ubTgcahzkgBbAY5lDATmFlwuLz6/R
	JClYiTml7++9hcIlOOWk+bQAM096AaJ5rCb1X5pKMmdUP1u7VwD1E37+MGlTkkwa5hI7cMQh6JU
	NphVSBXUrzk/YCTvYKLdDs0uNcPFnPa9xC9N3KeSWIKTtQbsRbfLq27TK
X-Gm-Gg: ASbGnctrrBq9TNSOL0v4ql1K3f5yzxhsR6sj0qoaVeTAd4N+i/RhS/fKKZpTcQzzn5Q
	eyNCnh1C0oEVY+IfS0rp+PlPSI3zYy+f7clFqPhSu+5R6NobK5VaOUsmQCLG32g7Ei6v/Q4i27I
	U37POnO00US8JI3lc7soYbZTmCf154xw9Ez1Eoar9kYHp2IKeHtbQySFDEAMZ4kpasWTMiVab/l
	Q6puxCviTvXRl5Q+vYhhPjhAnIT3tvXwQUyCO6LQ5P7fKKtg6s1kyetXQynzmLbf7GGGA==
X-Google-Smtp-Source: AGHT+IFleJTwznfh7QMv/AG0SGTuwrxVYkRp6eELQGLLc5UcBUyDg99Mf3CPsqqX8gWPb5Hu4F4A9V54ZvoAbPtY+Wg=
X-Received: by 2002:a05:6214:2404:b0:880:5883:4d24 with SMTP id
 6a1803df08f44-8847c45daf6mr255046516d6.9.1764130866514; Tue, 25 Nov 2025
 20:21:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251125223312.1246891-1-pablo@netfilter.org> <20251125223312.1246891-3-pablo@netfilter.org>
In-Reply-To: <20251125223312.1246891-3-pablo@netfilter.org>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 25 Nov 2025 20:20:55 -0800
X-Gm-Features: AWmQ_bl80ip7OhaAsTg46og0aFXG3CVUfPmo7hC2YvkaKQmGy5gAFvzr6Ttk86k
Message-ID: <CANn89i+pLDYSCfz9Yq7MPw5+zS+k9VfL4EXZWxztDGbiL==-Gw@mail.gmail.com>
Subject: Re: [PATCH net-next 02/16] netfilter: flowtable: consolidate xmit path
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net, 
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com, fw@strlen.de, 
	horms@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 25, 2025 at 2:33=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>
> Use dev_queue_xmit() for the XMIT_NEIGH case. Store the interface index
> of the real device behind the vlan/pppoe device, this introduces  an
> extra lookup for the real device in the xmit path because rt->dst.dev
> provides the vlan/pppoe device.
>
> XMIT_NEIGH now looks more similar to XMIT_DIRECT but the check for stale
> dst and the neighbour lookup still remain in place which is convenient
> to deal with network topology changes.
>
> Note that nft_flow_route() needs to relax the check for _XMIT_NEIGH so
> the existing basic xfrm offload (which only works in one direction) does
> not break.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/net/netfilter/nf_flow_table.h |  1 +
>  net/netfilter/nf_flow_table_core.c    |  1 +
>  net/netfilter/nf_flow_table_ip.c      | 87 ++++++++++++++++-----------
>  net/netfilter/nf_flow_table_path.c    |  7 +--
>  4 files changed, 57 insertions(+), 39 deletions(-)
>
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilte=
r/nf_flow_table.h
> index e9f72d2558e9..efede742106c 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -140,6 +140,7 @@ struct flow_offload_tuple {
>         u16                             mtu;
>         union {
>                 struct {
> +                       u32             ifidx;

This ifidx should be moved after dst_cache, to avoid adding one hole
for 64bit arches.

(No need to resend the whole series, this can be fixed later in a
stand alone patch)

>                         struct dst_entry *dst_cache;
>                         u32             dst_cookie;
>                 };
