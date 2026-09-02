Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51ED46C82F
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Sep 2026 23:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788390297; cv=pass; b=Ry0sJeK2l72oO42oaDqmsUXN6oSEerm/9ohD8ID+6XAbSJmwmUTKyGpUgAR20E9pLBhhdfNWb4zYfJyWLEKqLcDC6ZZC6gFGhjhZfb3GCAdpcITS1w/CT1YI7kieI0LQtW8gcnzNzLlQmXeroK8X0rcX+9EBqVM7RmBjxOu6v8o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788390297; c=relaxed/simple;
	bh=/v97SxnXWUl3AzCD8i4KYWPlhfuArXwfYgURlq/8OC4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B0hFAElibZ+fmfZfw78ldz2cj2LYNPw8aPT0p6tqYSvwMqbe48Ka3I87C3oF0kBiReZFzvGys+bxTHnP19QuQbQFud26kchQAr/FncbPfSMyLEeBKPYQCmr1fF3k11ZjODpwjyka45Oofx7WSu835aqfvzolD4HVq6h+SSQ+iWs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E+VK7vZR; arc=pass smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E+VK7vZR"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c9b373d5af0so1331298a12.2
        for <netfilter-devel@vger.kernel.org>; Wed, 02 Sep 2026 16:04:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788390289; cv=none;
        d=google.com; s=arc-20260327;
        b=fRsMbilCqQy7tPDY96RYFZFFBXJvAVBvcsnu0eQGKYD7tV0zxyqWP3CdiID5WIXq+8
         m6dWylVixD2FiQyObxIE93oEPWimppNuixRGJBuj1mvIT4Er06Sd0t5zlozM7XU9QrYc
         juSVDgqXe8DK13Jv5aaCOWgeE9IrP5uSubJG3g6xWthJtJMFTkA4mDajZHQKJueHTUUd
         mGUBUxYNrJjyWszb4RsxUPcVqFCsE+xMqDrvjVqtDQSY4NxD1Lqsrit3rBZAgl5x9w/E
         bbKPbLTQ+iV5Kk6Ah9eozztwRiUAjUWvd7CrJHU6yCPHxnXuACe6Rjurvo0PENMCmhSy
         0oyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/v97SxnXWUl3AzCD8i4KYWPlhfuArXwfYgURlq/8OC4=;
        fh=J1KQE1YDds2EppDOr0wZRXWGni3pT+vgMNaiXO7jUeE=;
        b=FDR1UgaRcxHvi8qxjFKAjdZoYxtjtMzYP83SeNmmGmODOJKHkdpHhnpEWBILx0Uq5G
         TOIau4NOPLoIwRMdXAoaCjoH3svg9j+w0w7iBlNdl+MvF0n6ESYkyU7Fpn/TYFHfTY0e
         4AicNP2QDgrRai+lJnVaEzt0Lfq8EfKAMQAtRpvpkiCYuaLvk0VuUGlDO51DvIxLie0d
         ucWwz93+ukRkg3eHjvyTv/VWWZmD/DdkrW44kS3lrKg3oaXbN4ew8qpt+o11LZp1tNcf
         sKSTU52kTGGuhNES9ltImPc1go5cNrzqsahP0gztgGflY4cH8DAUpQ5PkvGoutFW01L5
         jtWQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788390289; x=1788995089; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/v97SxnXWUl3AzCD8i4KYWPlhfuArXwfYgURlq/8OC4=;
        b=E+VK7vZRF+UAaweMQupmYJcDtfYBCXTmfbly6iB1bEIecnOxjhl3ZGTJP85kBzzba3
         BWfclCerpJFce0/ObOT0+5u57AMR/Ld9bNfttf5t/9uwIDH79+wsNfQx99uMrcmOf2Jy
         eNVS1dcHV0YsbgjWFwjiYQ+vhiQacebt0Y1RkeIwA7K9xYmQpAnK0T1k+hBuK4ROQzUu
         /0UR5SEGv192wGNrPfOX2R/ZLK9UPTjV0thLrPUbgArW2Uq97ld+4RwBGpp7rjRLxbsJ
         RoRuAKKT8D6TGBjkWFf4IHUUSb+ceyqI8uTKL/ns5wg/GZJORktsGcT13kZ+6ae7n/9C
         WaDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788390289; x=1788995089;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/v97SxnXWUl3AzCD8i4KYWPlhfuArXwfYgURlq/8OC4=;
        b=cba38nF9WEieY8QF909VN9hTJR35y8iGrSXJL0RzSROvDQACqEmpc9OlAUfsyyoxgK
         M7G/qef/hp3BEtcABAjC3GsaJafgyY0iSMq31/RAmq9OKexDm/KD2yKGhqLA89U93ls7
         NvGN+d9k6Qb9SMoPnVeX6URScX9v+8yDgW7hnzBhZLmhthCRbpfbzV6xq47RpvmACYv8
         BfUWE/AE4ii7B6MdjG9n2DTKrO9JXAMuxmLeMPLekBrN87JeBm7PUC6R7sIUPrKZOG+G
         03k2bTYSQbEk+M97J7q0DMBCafUeVbWQWSMDSuHzSjt69ZFhPNzuDJOSmNgTrSb5gWPD
         vweQ==
X-Forwarded-Encrypted: i=1; AKwUvBwH2BQDr03yj7SJBnEQS8BPh3gqnm83heJzYUW2EEKfhZPuSJ6oIiYy2ZxabLnS/v/qwiNd/FNEm/dnPTFhTAA=@vger.kernel.org
X-Gm-Message-State: AFuF++nvLaBXH0xx71vfgbCkqIs0ozGZInYxDpsbEn1jR2uywni4Q7J5
	omh5pUM6tqSuRUXUvKpobz9LDnjZb78c80d4MOjj4+ua71EA6dAK2kIZ762ImjOuq8ptalbX8CY
	Y9pQvy9dgaYKR2vfgA2OwdEc13ZJMTPWAFGSgSdTR
X-Gm-Gg: AYBFou0GOTn/iCpxcPf/RMaQ0acn8aa1rcc81LrJ48Ar5T5M6M1Mlz6SUalgguRpZb3
	k7k/0MEUtr24YwnROoEF/GCAAj4EhACOVWVsHDwTyTBOKHIxvIXRTNJryUaBq79n6DBW3gTPzOb
	hYQJoVuqHBMZnTS72x7PBpyaTgFcaRWok7cyoLJDskAfZzMyyuxXjvCiNtpFQB3KchFUbIGwfw1
	MVS+5t2hnET4jmTQAzFyNOipwnfbl70aCwp3f1G/2V3+OqBtrkvlvwj/U4JcOrSIEasaJnTxyXu
	L12pnmhi2IxZbPqqiZcWXVqZ11Ysm8jPp20ruaAXFqz1dOf4LiJzeJWGiKsd618RXLB1lzvXwft
	VZhyHU8H5/WS3Famb8+0CPwb2iLzPjYLhqxg6LS+XdQdwOp/tYUqr8y7Q9MiSqo1YVvfGsyd3DK
	mOyN7Xwy7wdIqM
X-Received: by 2002:a17:90b:2649:b0:398:d6e6:4671 with SMTP id
 98e67ed59e1d1-39aee249be6mr12032469a91.25.1788390288724; Wed, 02 Sep 2026
 16:04:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260902-sockmap-lookup-tcp-leak-v3-0-b998b3d49d07@rbox.co>
 <CAAVpQUC==6KEBs3XgFjZ536mJ23cbHma8HuiWMu1DRc_=YYOHg@mail.gmail.com> <20260902155216.4fa23444@kernel.org>
In-Reply-To: <20260902155216.4fa23444@kernel.org>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Wed, 2 Sep 2026 16:04:36 -0700
X-Gm-Features: AcwNN1UkbVzkWQ8FDXuwY9XPS95VYwqDS1NMCf7kWqvgYjJkEoK_LkIEshdICok
Message-ID: <CAAVpQUAWjBuF1Rgze0Vt_XvkUT=Ajw-F+Kh+s2iHk38c8iAapg@mail.gmail.com>
Subject: Re: [PATCH bpf v3 0/2] bpf: Fix socket leaks around connect(AF_UNSPEC)+listen()
To: Jakub Kicinski <kuba@kernel.org>
Cc: Michal Luczaj <mhal@rbox.co>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, John Fastabend <john.fastabend@gmail.com>, 
	Stanislav Fomichev <sdf@fomichev.me>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Willem de Bruijn <willemb@google.com>, Jakub Sitnicki <jakub@cloudflare.com>, 
	Jiayuan Chen <jiayuan.chen@linux.dev>, Joe Stringer <joe@wand.net.nz>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, bpf@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 2, 2026 at 3:52=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Wed, 2 Sep 2026 11:58:49 -0700 Kuniyuki Iwashima wrote:
> > > Several BPF socket helpers acquire a socket reference only when
> > > sk_is_refcounted() =3D=3D true, and release it, independently, by
> > > re-evaluating sk_is_refcounted() again at the time the release runs. =
TCP
> > > connect(AF_UNSPEC)+listen() sets SOCK_RCU_FREE on an established sock=
et.
> >
> > Due to several bug reports, we are now inclined to forbid the
> > buggy transformation.
> > https://lore.kernel.org/netdev/CANn89i+px52TtJy3S9=3DuHxGj3s-WueguRo1Z_=
4FxO=3D02KLmwmQ@mail.gmail.com/
>
> Kuniyuki, would you be willing to send a patch to do that?
> Not sure if anyone else is planning to, I wasn't..

Sure, I'll post one like this with s/synchronize_rcu()/-EINVAL/g
https://lore.kernel.org/netdev/20260804015349.2353056-1-kuniyu@google.com/
