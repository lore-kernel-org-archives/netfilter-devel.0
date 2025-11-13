Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423F52F12D1
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 15:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763049044; cv=none; b=VzEkth7mTIFDJibKQZ+utSgZh35MFzLhhGkOP+MckBfr5HbN9n54RpiX6pdXVoqeTIMaiUemZayAzuT0XB5ccBHxamN/pDkFCY53qtNuOP2b4BiRHpsOr9JT7wWqzHBxCMttHWaNIK2z8NxBWDO5fIi5fJUmZvoxERtvyr2H1/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763049044; c=relaxed/simple;
	bh=Pfjqk60b3THr6aC7BPzuk/TyhyVleC13UqlztnSEPLE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CGz291r+6NWPk5pkxYzJj6l+fwCPq6nMWzNPzm75qdSXDjVh6J4VY+obogoFyHPq8WJyVPQnqrWfvGMV2k9JGMTZXhjiTAFSBUnia/dK2WWJvhzdBFQcTTcu2EoEYFUAAOBdP3DXfje7ludZshN/AnqmEz5dhfo7bMul0D5Aw0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EeqJwZrD; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EeqJwZrD"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8b2627269d5so117531385a.2
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 07:50:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763049041; x=1763653841; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pfjqk60b3THr6aC7BPzuk/TyhyVleC13UqlztnSEPLE=;
        b=EeqJwZrDX4SeCiOY3OvCZyuKTaIBqhtMvRrhU87xemKUaOPFBVpP4gg787x60VG7Z3
         OC1UjAAnz9CIxey1yHCt2aoqcA3W5Vo6IyfdFdGKtiVfposu9ksUpVeidLb4tutqDoX9
         /l+XkgXSJYHbhqk+N6gc08qBp/1pr+yGhYRDe54bmCdiVC2fsbHKTnyqE85Q2P2EeFix
         kZCUOUYIEnVG5YTxQ8jkTLTNokATba7v4RYR0J4hZy7JmPU/Ksu9eFF1DiT67dvuv1tK
         RhDljY4YMOyXBxE9SyACGcmAMm2tAAJR5U7pN/PQ3FetXRJV6rXXXncZpfmBnbN66HRR
         lZww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763049041; x=1763653841;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Pfjqk60b3THr6aC7BPzuk/TyhyVleC13UqlztnSEPLE=;
        b=SZbpiLpxHHKoawTLu3p0hT51ripsIgXAzXzgQXBhUM9QzQlSHljc4IMwFtmhei2N4W
         fy66IMtly3eJKG9TgEuNpazi5x3mmvwHap/afeQz/KQHkXFluZQQs3zCeHVQELZHYQS6
         RRbOP/hXDv/mOhho+sXh0RM3hdVjVE6pGuwiBybPKUkHO56+uyQEwn6sZSEjUXVFyMgI
         CCzccIPNPb5K2kBX1Bd74axxW9nOpr0aZBwNnug87cx3JKOlhaNi2A092o03u1N7CE7w
         5qjWvzjR3gEkhBNhGHJpILUpxb9l11h7Y4jkLkjbieLOpA9BE6fYC0tUAhCK5TyH0WI5
         vluA==
X-Forwarded-Encrypted: i=1; AJvYcCV7Q3MZTk2dZ9MAv2Sio/n/NHc8kV1XCCO1DytukjBXXl2xPrh0MdYEguKazjmipVodqc68s5EEyyzzN4JTru0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvTFz1vP/6IrHgDBRtzJ0or95it8TpW3Uj7LFAYsqUjq9mZfK7
	m4VOYzD58SjaDt9sNE0tsFTSuBlJMUQuf2gMgt7GybzuMqJSqYv78AgO2+Lx3i/cJKcob/X9y1U
	ayMtBJhlSrSwW//SJHY6aFN5KcfjJMluxIRm+tLyIC9Rgl5DkKF+Lj3Mgdng=
X-Gm-Gg: ASbGncs0HLwVOu+P9vFensez2gt9VHL+ep8tSmTL/Uyl12H4Sg1NkMrIUs+hYvql5x2
	31Zctd2mUOJAe2krp++PjEDvTSgVz1GD30/QWGlHnoRviXHYkpFA7pZGhTIBtQI5NLgnncl0MZW
	9C+mv5XxU8HROaE455JxtrFxQcRCbfWvTAcqLMD7uqwZ9Kt5UMxv/SQPOOO6MaP8OACAHMBkdsi
	4CayD+4SSYN8Zj/N5rKpFET+EHFx0qS5ps8Sl8iwUd5vmJ/PYP83QberaBTm+N9NgYX50MGQ/GM
	mfd/1RI=
X-Google-Smtp-Source: AGHT+IGMjRUoY7nRKeINhOpAWlxY1uOyXJ7f2kSGeOU78eFrpNzjxzKtA29ny45jesxZqVrnMlSBnu6gigSBq2AMGhA=
X-Received: by 2002:a05:622a:130a:b0:4eb:a439:5fe8 with SMTP id
 d75a77b69052e-4edf1f39a9fmr2200831cf.0.1763049040701; Thu, 13 Nov 2025
 07:50:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113154605.23370-1-scott_mitchell@apple.com>
In-Reply-To: <20251113154605.23370-1-scott_mitchell@apple.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 13 Nov 2025 07:50:28 -0800
X-Gm-Features: AWmQ_bltsOvb2svPtDoPMFYM_GmVTdMqw3ShE8mYyo_cbuU8uVm_vgFXojpGOdA
Message-ID: <CANn89iJ_b6hfj96Me-8AZN92W+cA52HpGcu81J0MNtzeahpfXg@mail.gmail.com>
Subject: Re: [PATCH v4] netfilter: nfnetlink_queue: optimize verdict lookup
 with hash table
To: Scott Mitchell <scott.k.mitch1@gmail.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc, 
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 7:46=E2=80=AFAM Scott Mitchell <scott.k.mitch1@gmai=
l.com> wrote:
>
> From: Scott Mitchell <scott.k.mitch1@gmail.com>
>
> The current implementation uses a linear list to find queued packets by
> ID when processing verdicts from userspace. With large queue depths and
> out-of-order verdicting, this O(n) lookup becomes a significant
> bottleneck, causing userspace verdict processing to dominate CPU time.
>
> Replace the linear search with a hash table for O(1) average-case
> packet lookup by ID. The hash table size is configurable via the new
> NFQA_CFG_HASH_SIZE netlink attribute (default 1024 buckets, matching
> NFQNL_QMAX_DEFAULT; max 131072). The size is normalized to a power of
> two to enable efficient bitwise masking instead of modulo operations.
> Unpatched kernels silently ignore the new attribute, maintaining
> backward compatibility.
>
> The existing list data structure is retained for operations requiring
> linear iteration (e.g. flush, device down events). Hot fields
> (queue_hash_mask, queue_hash pointer) are placed in the same cache line
> as the spinlock and packet counters for optimal memory access patterns.
>
> Signed-off-by: Scott Mitchell <scott.k.mitch1@gmail.com>

Please wait ~24 hours between each version.

Documentation/process/maintainer-netdev.rst

Thank you.
