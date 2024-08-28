Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B1B1547DD;
	Wed, 28 Aug 2024 19:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724873370; cv=none; b=W5Qdj7uE1P1cbGJP7kYBqkfZoxsefv1RIJHfqxTQfMkqmUH1P0JERTKwIgKbfqXDG+7rWUcButz9+SU2X/3iUuO7qJMQoqqpjo2ifyDuFXGLfO29sQ3N6L7wakxzqLNA6I4NpJx0+tCAxWHUgmbsaQiZdf3Q30ebp/rx6lDrW4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724873370; c=relaxed/simple;
	bh=V84t0/PsYr0WBebeMY3KqqY77y6qvzTY59Qebk/rv7o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fnp4IbKb6SpvIDobo4OsuK2qLSjAQIEBl6csgngf+imn7BN/SEwwlqQ/Z9tIdhFEN+rebRbJ34R8xo2reGhCe+KsqiBW4V2Cyg0hnlPVS0sW1xlvv9tlrpgByYgUmzcci4+ITacm8keG0/31qRDAYGoNJNQcefIPZUvw0SQIBX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eYD9r0zq; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eYD9r0zq"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2f50f1d864fso38080061fa.1;
        Wed, 28 Aug 2024 12:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724873367; x=1725478167; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V84t0/PsYr0WBebeMY3KqqY77y6qvzTY59Qebk/rv7o=;
        b=eYD9r0zqYwiUcxte4XrTeGfi6Td83wntBasSi7/CiEdIOwDAPRx3Gk8Y3IQ443eg/L
         J7fce2UGXfrGEBYBV1TqXfO809HsWwbm5USm4Sl/VAdPir1B8Vsh9XsS+QGBGf1/Q5X+
         DO5hth7CWTRmgVI8aVSlxnVYK0g19WGNcj1OnCbpSutJwImjr7RmKaplSKRl2d3WPR9l
         UfERWVtl4dH5SnVa8TxaDtVH+RIclo2d/XCeWVymWcPa1QlYtVux0tKi7ao38n/+V7oj
         7jgNVnNU0kjSdvVlUrzW0Ht39SwStq7ODEVVa+ra4aQaV0BvDb1Y+FwBTxvZlpLgGUbK
         +w2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724873367; x=1725478167;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V84t0/PsYr0WBebeMY3KqqY77y6qvzTY59Qebk/rv7o=;
        b=G0D5+LBJuFqpxucOdPPlw8m1HpgDCm+kqy8lNBsoAkl2CNJ38OJhMtlBUwG4P2zBEc
         gQkFqZfcPiXlqL0JYoJOjfWh0keFQr10T4I1WsvVTf8GEC9Bc0ucGQC9feNXoRqk+PMl
         3bhzA70sS7Who0c/Lxid0stWZY71Z9whndsOh9nfaA3l+etMJ8Izd8WuoJATDbbWMwZX
         2FT4YTsJp5P0WxCCkLzgRZwXkrGcXW6dszUfUktjghvcCl3IIwnF5fWlxl4SU4gTo5Ma
         WD0F203SA8Pm3dh7kTNZHE8JyBtfaHXXOJS/F/X8LSdF0v+WMKQEx9tRyWiYe/m9wR7Q
         aNiw==
X-Forwarded-Encrypted: i=1; AJvYcCU9OSOTg7fltSNaSbKXoPgI6LF+VBFxm0kt8sSyWaH82Jrqllg+468EVShJ+DdygagnS8+cpIeotTyeW5c=@vger.kernel.org, AJvYcCWKfqsR+4QJvVXl2PNWo1hYpajh9R+5v6uKJ8Ptt1RW//WsSK/ZZzkysgNMa0e4Us5sMV1J+VWy@vger.kernel.org
X-Gm-Message-State: AOJu0YzVPQJGYDxJGBOZBzN3D9FM/p8PSvJmhCbnNYWDRoXXWdxXsgVp
	wZ3oWUfCdd3TN+EgXS44P6pMiPjm2pKrw8aM5ikDosGRcIlFM8snMFTkz7SOhHcDRR1r++ErAHZ
	TVBToZ0fgbl2MdP2ADesjAYZAqC0=
X-Google-Smtp-Source: AGHT+IGSeeuh+aGksQS2lS42Aemy0OyMOtAztalMvpRmQlC7EsG/09YXp9qmnlUfMkI19mntdItkwk/7Xv9P+xOv0ro=
X-Received: by 2002:a05:651c:2105:b0:2f3:f170:8ec3 with SMTP id
 38308e7fff4ca-2f6103e3093mr5340921fa.21.1724873366023; Wed, 28 Aug 2024
 12:29:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240806102808.804619-1-ubizjak@gmail.com> <Zs8564GQ2c486JVR@calendula>
In-Reply-To: <Zs8564GQ2c486JVR@calendula>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Wed, 28 Aug 2024 21:29:14 +0200
Message-ID: <CAFULd4Y8tCUNHJ9vVPKch0sMj31LnF8bVtJRTez5tBV9p5509w@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nf_tables: Add __percpu annotation to *stats
 pointer in nf_tables_updchain()
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jozsef Kadlecsik <kadlec@netfilter.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 28, 2024 at 4:53=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>
> On Tue, Aug 06, 2024 at 12:26:58PM +0200, Uros Bizjak wrote:
> > Compiling nf_tables_api.c results in several sparse warnings:
> >
> > nf_tables_api.c:2740:23: warning: incorrect type in assignment (differe=
nt address spaces)
> > nf_tables_api.c:2752:38: warning: incorrect type in assignment (differe=
nt address spaces)
> > nf_tables_api.c:2798:21: warning: incorrect type in argument 1 (differe=
nt address spaces)
> >
> > Add __percpu annotation to *stats pointer to fix these warnings.
> >
> > Found by GCC's named address space checks.
> >
> > There were no changes in the resulting object files.
>
> I never replied to this.
>
> I can see this is getting things better, but still more sparse
> warnings show up related tho nft_stats. I'd prefer those are fixed at
> ones, would you give it a look?

Yes, I have a follow-up patch that also fixes the remaining warnings,
but it depends on a patch [1] that is on the way to mainline through
the mm tree.

I can post the complete patch that uses percpu variants of ERR_PTR,
IS_ERR and PTR_ERR where needed if this dependency can temporarily be
tolerated.

[1] https://lore.kernel.org/lkml/20240818210235.33481-1-ubizjak@gmail.com/

Thanks,
Uros.
