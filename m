Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.174
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793973741;
	b=duGbWR5XRHe/FO2N56daxd2QKDkGdghCC0/oITd6u5i/mbyB6h7WoNXuh+ln0SNgfBuP
	 gd2RTzhcTL6ue1r2+xC+wHNKBWKm1v0F+HSHQEC9o/cpu245NjoOy5Y6GWFTm44xqmaDp
	 VM8CH/eJ6+Cx8/+qnTTr9ZHvVsOZBgCak2hN/WeO0iZFYx6n+D/bdwnXJxACHUMo/rQ+N
	 097SpALjpVdllofnbXwb2GAiuV7zDAuNQWPQLpC6As8NjF5lIhMQxoiocfbrzYsaAy1N9
	 pWm3mcbmnSC6C4Rb3VKcMyDOASgskCTnqO+kj/zMJTDi/nLaxPCiEt7JfUr7sDVmh/g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793973741;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=3gDlvZK/KSG16idOi9JjnT7Pe/XLQwbqGEv25TbSfLU=;
	b=5Lf+Yi1DuBcRkTo5XJT169JoVneYGBBR+XUtKjwzknwerJwqSst3v6yWwPKtrx+1Vpgt
	 fo56WACOGvREm/FOWTyGRWmEJzbrlKhniY+7YABQNLV3HwVe/Pc51BqdFTL+K1Y5WmDiC
	 0EU2+OQ/yE4nc98UaLE1gkxP2Z7bdcnc41uNOUgv6VgVTG6NVqX53G/woUlnprK2izBaN
	 XIpMbub/gINZsC7GhTdXYzywIXR5422HqucndFjs+T0gj+XeYqqOLJPWl29Ll4049qsX4
	 ++ECuak6VV+XEbj5c5MYpnQV5S+7PKI1LV5O1ulRQfqevPgKNMeiTx5F4n2RgT1jQow==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IaSIxWx+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.174
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792BD606EE9D
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Nov 2026 14:02:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 792BD606EE9D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IaSIxWx+
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-3282db206d3so1384707eec.0
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Nov 2026 06:02:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793973741; cv=none;
        d=google.com; s=arc-20260327;
        b=mP6KYlM53C0kqSY+rN/s5w7YA7qiKtUIoDr2fuzjGOCzCKO1kv4+lTZoudg2QEypG6
         W/gMolrPbtUHkW5kZNc6sFrO8tTPMrLZtPtCId9y78ZRZynsqACAFk0CKCGqsJ6rVL0m
         E6VGuInY6fAnPI/bQrHIxA9KYV7i0PiLNoy6mCeVxb3VJqi+4owJxWho8/JZMnmeU/BQ
         C05K7VOjije6I3FslyWrRhRLNXPyMDF0O6C3tdd/6K2r26HArSXh3t6rC+QTfK/3XuJ5
         w6vodQpkuwcmY8L++mgXHv63f7jVqPZ/lzThD23dR6Mui6b4tjx9pRJChckS+Maskfxb
         q9lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3gDlvZK/KSG16idOi9JjnT7Pe/XLQwbqGEv25TbSfLU=;
        fh=iCjVDsbW9GMWkouiosnpqntZ8wkDB0SG4Dkaz0NZRz4=;
        b=feY4i7oh8GLA/r+W8M4v/poIwK6seRSzXHHWfQZzR/jwHpuzg6q23s5gAJGzqiS8ly
         EFm5pe3jGM026nhMx5uDgDBO4OMcqrtJhaoXQui+c7GefZPmM6tRaFYm//NITKOFo+IT
         O6cz38tMeSB9NnF3mCCYtxdM0KhaLVxs9JRviJNGLcuU+EsdSLPRD3kkyoD1nR93MP9o
         xhdzinnbtwvpl5Yj2jDPLWc2C6DXASmRRfH6+1QnwsAMn2Hg3RdT6SJmYjYo9OL3LIow
         J/SgOcZaUuaN46NuaoHbS0wyWSn9qlhYDbzLdb7s/v20MZ0jsdQuUw23War+bH/+xv7x
         KZ5Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793973741; x=1794578541; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3gDlvZK/KSG16idOi9JjnT7Pe/XLQwbqGEv25TbSfLU=;
        b=IaSIxWx+W6s8dkUoGvweOlDos6V+EDwjKOzVI7lkCG5BEzPxtsq/dWTpWqlDAg7gA4
         HLnE2cq779xXzCv67vCcGZPij0HutKvfNSxZfHYdbJj1vw9cVM0XUHYBWrNoOxViglDK
         U9Ke5lvKp6UnjS9SnFoLVtW00sv33oYi6PjeZy4whDO8K5TybpTyryG1wky1QshlhlvD
         CsvHRLmRbOgVtVlZUrWqxZ9iGqQwpSwvrXK0D7tz2L27SkCpYoelu1LAkKbfzcAT3wH8
         RdKoerBeg0WqKqA7IhFkiiFPNdQRSiyYoulvKBkBO/6WhMweXGP6rEpb1FqwzDz2KFdZ
         vUgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793973741; x=1794578541;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3gDlvZK/KSG16idOi9JjnT7Pe/XLQwbqGEv25TbSfLU=;
        b=obQOmPXR2NVA05kLcp7qQ8mBZJTpSLcIPcjzvSjuYndzxgbELrKXREmtXMnwSE0IU8
         b1SGt+23dlv30NKtbTVG5CDh6T8lcn0+oTzmhOlSkNZL2kWt4WqQ3PEemd91bJkY+Cfw
         LNb6NzUIJosnpyRTGdg67pmKy1pxOcN0CQUgz9Hx2WkhpGSfcJPuX3FKW/vGkGD3Z+My
         VmYiwYrOGOxmfYRjCCTwHQE22EMdp6xqliejAH8VXF6QIqDceUeTd/xsIcBaaktwMq2T
         oA00pZ8ErhShamJNT7DRTVau7tTRG5okHl8IegroNtP7xgSOdvoDX2R5fE46pz2dOuhT
         zmMQ==
X-Gm-Message-State: APuU4Z9ZbMkOHrlEGvPYaXz9e76vFnde8mnFvVC3+jWXTSI2dATkpIpC
	EhvpIdZRohXtBucPtoNw6vLssoAcf4TuHlnTJfPTs0MW4HLpEeRt+TT4vj8kS6U0Qrtl9+BKKfy
	dRPO38RcgPIqI+r9Xn4n3TezPXh6ZbPgHr4l7RQ==
X-Gm-Gg: AYBFou2PFobCHhkHrysTLRp//yoACkYyJ5R+X+4xLLi99+khfe3TL9GeNDCS60p20un
	dpxoVNzyWbkjfJ9uwnLG6jViJ1vvxYgjcdoeqv8G9VkoUI6kpDsV/aXHo+SgxwkPMjK4lQrH7hI
	VS3AJ5A6U00d6f7xXA3DTiBv4m1tuOxjncmy6zaF03DSP0hHbxCqCCpN4Of0QerByYUF5JCSTqF
	f4IV1I5m1DIDbE2vIGhAOX/m83Th62ZFESNY311xfP+qKHHvP+q8zWC6wETXEBTHz8AsLK+U/kf
	OM4DDGKNYDulDa0XnXCHGqZNOIA89GhYakiPT2TzCzcg8Ji7jYyZJJbCREF5GVncuuHuFr3Do+0
	y8a67gKnlJ4OzDNu/EYQZC6V1EHsaflGXSnPwL4v27jH4YWN3XqW2kBg3zR89zJp3yGgrthSIYL
	7/XpHZATXswxjplrqYWHSfiN0H8tCUcbXW0jUeMX3HsMgvrRQHl73iBWXVCEBueUnvbqJBROP2l
	vTQ6D6QPuGkANGfg2Ou4SLwT8RezCqEsKwQ6RVYH5ptjUPrgkWQUilBF7dfdX1u0wv2pA==
X-Received: by 2002:a05:7301:d80c:b0:36f:550f:bb0d with SMTP id
 5a478bee46e88-36f727d59ffmr3654501eec.5.1793973740423; Fri, 06 Nov 2026
 06:02:20 -0800 (PST)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAPGrzGkjouOeqOcy4pXbBgx58DWvZpqK8ppuChPsDsXKvxp4RA@mail.gmail.com>
 <au28uheXr_lsEhzY@chamomile> <CAPGrzGmyVKDYsQV1vyN-K5Y6FJ9U+T_DvkDXnR6Ju0W-5Bk=dQ@mail.gmail.com>
 <au3cjRvFU0Iks-WW@chamomile>
In-Reply-To: <au3cjRvFU0Iks-WW@chamomile>
From: "S.S.Vikash" <arisivikash@gmail.com>
Date: Fri, 6 Nov 2026 14:02:07 +0000
X-Gm-Features: AclHuK_s9PYqC80hTXEcVUWZFT3GNyQkKfNssOv8iGgRTzbJGez26-OAfzd203o
Message-ID: <CAPGrzGmHvNaLrHyrGx9nC53jahXraxNXUp=m6YYEtkLRbDwJQg@mail.gmail.com>
Subject: Re: [RFC] netfilter: conntrack: early_drop eviction limitation under
 sparse table configurations (max << buckets)
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Pablo,

Thanks for the suggestion. I've submitted a documentation patch
describing the early eviction limitation with sparse hash tables.

Patch: https://lore.kernel.org/netfilter-devel/20261106135816.391285-1-this=
isforspotifyvikash@gmail.com/

Thanks,
Vikash

On Fri, Nov 6, 2026 at 1:56=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilter.o=
rg> wrote:
>
> On Fri, Nov 06, 2026 at 11:52:47AM +0000, S.S.Vikash wrote:
> > Hi Pablo,
> >
> > I understand your point about the suboptimal configuration.
> >
> > I came across this behavior while experimenting with conntrack and
> > investigated the source to understand why it was happening.
>
> OK, looks like a LLM finding then.
>
> > I'm relatively new to kernel development, so I appreciate the guidance
> > on what would be useful upstream.
> >
> > I'll start with the documentation improvement.
>
> Yes, thats sufficient. I don't see the need to improve the situation
> for a suboptiomal configuration like the one described in this
> scenario.
>
> Thanks.
>
> > Thanks for your time!
> >
> > On Fri, Nov 6, 2026 at 11:40=E2=80=AFAM Pablo Neira Ayuso <pablo@netfil=
ter.org> wrote:
> > >
> > > On Fri, Nov 06, 2026 at 04:23:08PM +0530, S.S.Vikash wrote:
> > > > Hi,
> > > >
> > > > While investigating connection tracking exhaustion behavior under a=
 spoofed
> > > > SYN flood, I observed that the effectiveness of early eviction in
> > > > net/netfilter/nf_conntrack_core.c:early_drop() degrades significant=
ly when
> > > > nf_conntrack_max is configured to be substantially smaller than
> > > > nf_conntrack_buckets.
> > > >
> > > > Setup & Reproduction:
> > > > - Host kernel: Linux 6.14 (Proxmox host)
> > > > - Workload: Conntrack table saturated with non-ASSURED, unreplied T=
CP
> > > >   connections generated by spoofed SYN traffic.
> > > > - Test: Verifying whether an inbound, legitimate SSH connection can=
 be
> > > >   established while the table is at capacity.
> > > >
> > > > Results observed:
> > > >
> > > > nf_conntrack_max       |   nf_conntrack_buckets     |     New SSH C=
onnection
> > > > ------------------------------+-----------------------------------+=
----------------------------------
> > > >               4096              |              262144
> > > > |         Failed (drops)
> > > >               4096              |              4096
> > > >   |         Established
> > > >               65536            |              262144
> > > > |         Established
> > > >               262144          |              262144                =
  |
> > > >         Established
> > > >
> > > > Root Cause Analysis:
> > > > In early_drop(), the kernel examines at most NF_CT_EVICTION_RANGE (=
8)
> > > > consecutive hash buckets starting from the calculated hash index.
> > > >
> > > > With nf_conntrack_max=3D4096 and nf_conntrack_buckets=3D262144,
> > >
> > > makes no sense to make to configure it in this way, there are well
> > > define rules aiming at maintaining O(1) in hashtables and this
> > > configuration is clearly suboptimal.
> > >
> > > > the hash table
> > > > is sparsely populated. Since early_drop() examines only eight conse=
cutive
> > > > buckets, it can fail to locate an eligible entry even when many non=
-ASSURED
> > > > connections remain in the table. This appears consistent with the c=
onnection
> > > > failures observed during testing.
> > > >
> > > > When the bucket count is reduced or when the table density is incre=
ased,
> > > > early eviction succeeds reliably and permits legitimate inbound con=
nections.
> > > >
> > > > Proposed Improvements:
> > > > I am interested in addressing this behavior upstream and would appr=
eciate
> > > > feedback on which direction would be most useful:
> > > >
> > > > 1. Diagnostic:
> > > >    Warn (e.g., via pr_warn_once()) when nf_conntrack_max is configu=
red to be
> > > >    significantly lower than nf_conntrack_buckets via sysctl, notify=
ing the
> > > >    operator that early_drop() heuristics may become ineffective und=
er load.
> > > >
> > > > 2. Documentation:
> > > >    Update Documentation/networking/nf_conntrack-sysctl.rst to docum=
ent the
> > > >    tuning implications of sparse hash tables on early eviction.
> > >
> > > Documentation is good to have, I would suggest you start with this.
> > >
> > > > 3. Algorithmic:
> > > >    Investigate a bounded improvement to candidate selection in spar=
se tables
> > > >    without introducing unacceptable CPU overhead on the drop path.
> > >
> > > You mean, to improve the situation for this suboptimal configuration?
> > >
> > > > I'm happy to prepare a patch or provide additional test measurement=
s based
> > > > on the discussion.
> > > >
> > > > Thanks,
> > > > Vikash SS
