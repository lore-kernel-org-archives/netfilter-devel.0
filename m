Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6633451CD
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Sep 2026 01:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788571242; cv=pass; b=n147EkIRPvPNydcXCxfxgPevBddyWS1dkZtZZvjtVUjaGkxef4HzZsma6JtEmbT51Y8hTD66BSHCOcr3E2RTIkS14nUJnBFjbPg0q+dFbhrgwQVNa5/nccYTkN1s0d6Kzf9UgzbhJBPn2e5bK4KeQdNJZrkQiw/VIRTtOcsKXhg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788571242; c=relaxed/simple;
	bh=P/Hbu0V5Vc4QgElq6BDPyNbu7w0tz8nmjZRMAFRdhVQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S+u2wxwnmBz8747dCJYledURqldv8JhQKCYR+VODp34q9NUEIkG5SeLq4ndpTimfyN7z/aDzGMsODQu832AIPBZdWcC+mk1L5u2jir1fRfQPxoM3DwMAZLrQbkA8x4q4EaqtHFxAgX16RLUsxYvn8MFz41kd2TRtZd1oMmiBJSg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gfEhKl0I; arc=pass smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gfEhKl0I"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cc1cf287ef8so1564800a12.3
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Sep 2026 18:20:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788571240; cv=none;
        d=google.com; s=arc-20260327;
        b=PW2ff8bZOfEKhAbFvVHNomO3MZ93Er8UHmuXLCO8PURP15N5pP3cc8bNaVwxwD0FNF
         7UElyd75sqto7raZDvBM9JJVbRMcz/3ckcbdmRzEuTliNz4+hASMRBTVSs2KZIaqN67O
         AtK23MEHraFtiGVDt2hioYeLzag0akQowNVI8A9mpPOd4ztMxDOe0B/f68wzqK+uS63k
         HUE8OtP+lSjbvg1s4YRQLuosdmBg5xKEOhTwQwnV9pRPoaBxhXL8senFsc+vqKFJzCCj
         KvnmBqbuspnn381NKEh1Kgjb90bNuASVXDy/wwDKuH3FfrpEATy2GT+Ql2yBs3ykB+s1
         mQWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P/Hbu0V5Vc4QgElq6BDPyNbu7w0tz8nmjZRMAFRdhVQ=;
        fh=euVRPTvX3ntuGj7Cv/gftTtv5PYpYWM4SutWI9FSNn4=;
        b=KBzRR19rD9oy9FKGBECb6bop3pOtVYFwNY0S3JBcHTNNlDwziwgX8Yb70uz3+J0FPY
         RONl8H4QPSra/BYUZ4yZVe1nsVk4PhuaRgfjP6quF9sxJZYFCf6s/Xigz8GhxpxlD6DW
         OnyRLZhpOYgj0TbhU0ftr3Stm+V9X5KNRPeAGZlsbD4yJRtk28Rrlp+rz3Pl19hMJoWA
         yhx+44yyBh/2j3vkOnVTpt5gCACEtTderQ8z7ecc6YkecmSVUqdxg0i0iIy/wb7GaMJa
         Fx06E6tVItUmRCHf9319osI3p0vUxW3kdMbmYzVPR3lxzMYg4ZnAh/hjbK1gr7Im2wNw
         kOxQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788571240; x=1789176040; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=P/Hbu0V5Vc4QgElq6BDPyNbu7w0tz8nmjZRMAFRdhVQ=;
        b=gfEhKl0It9NqgR3w8+wejPtXZN9sOx1oMaFRAYr2TmIgv9zIWWQ0zlN8C9Y+ji8YT/
         xqN3aUaYFp0UwVxtWZ9IqWdp9ADMLkdqiR77ZyZnoxvn6OxkCiBHx50KtjSRIeTYpyeh
         gCSOi2IWF50ArN+eYejmr2Y+bbcfauLDFpOptdZndGV6tSCNETtVadfRiDpUNUzYDiP1
         tB11vRwZrrV6B+t0Ks52C8lzxwaN05WvOhTTkdXcTg1UnS1KV0PhTo6lO+QWPLn+fTw4
         G9xJIvPDgs8P1/DwNdoSjS7Pza6QcQRzaYk0ZYdKrJRVsGiNE5XLpJTCT/qxbz0nD9kG
         kx/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788571240; x=1789176040;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P/Hbu0V5Vc4QgElq6BDPyNbu7w0tz8nmjZRMAFRdhVQ=;
        b=AQNz+HCUMQYgeFNuZoRVe858Y19NeBI+6o6Ao8sR9FwjvNzp56GKEb/WCTzpAmHffQ
         mjY4+02FvexnCTjIr7HheYD6dY9nIkruo776F+HEtlffRQo00n9unwSWooHsFD1mDjBE
         fohWFnB7/IjBec5ZbBzt4HZ5S4XVvUAGKZ+5wow4sdVtxgiNJ9b4LwDX0khdVch56tsC
         oXpeg2CcfcelCbGwCcQFPzgfIwwZwrTgJ3s2kfFweq0aZ0wRB8pK1JJ3TmO+6xOGR2OO
         G3F7gX9hVtXZsDDHpWjsxIfBbKBhZ/oB67LiI2bQrGo+7YSg0LwMQ7RSCCxm3AtNP6Ab
         6C9w==
X-Forwarded-Encrypted: i=1; AKwUvBw+BgNV4o7VqCDenVTsm1T3tUiC1CVLTpEIqysPpdIy9byZQa6kHilflM3TKiIUBrtyto71LzhP4phZMP1GUSE=@vger.kernel.org
X-Gm-Message-State: AFuF++nnUEMUxiTAiKKPpoAsIWonKfbwU2iQKV7wi2S8x6/peMCLFg1L
	coppPBNCq+uQdKbmUnL9naNs7nHlFKfWf5XqdDX1gEyEVK6+wBssDaHvXfITvoSQz2XRIY3+iY8
	o+3Db6o/8OOXMfVfydjt+auEB/HMd8pw=
X-Gm-Gg: AYBFou1TFgBueEgBM80/xUY8hWOKQYZicWfQlnoVX0utXGybDRn4sid8fluR35ziQfj
	m+Gpf4kcaHNxC8/k7YB/DCQZ37qNb0i1QdULgUtrTDJL0/QsPNRXxRgF2FsZLOuyIJw1ATMU/u7
	G8c30HWYu8YDcnG24X8taiJcoVHMDFIjLZTa7/MA3k8vQ8N28rqpsYeDwmHzRdI4jk+vBX+ijkp
	DL7uS02SU4r1aeH93ign9wYG0q/5obuqxwffj/EEu9+XS0kj/BuWgwnZvCBJFydqtlq6FplVBuG
	KCEG/oJd4ctsG1VafDlyHr++6HSp4I4II1tNsHimJkwizT6aUu/HxmvjbPkOutrLGQlGTkGH1VA
	43UHT0hJBPneWsL0D/0MCrMVpXxZ6
X-Received: by 2002:a05:6a20:9f92:b0:3d0:ba81:79b1 with SMTP id
 adf61e73a8af0-3da3980a0f4mr14688710637.0.1788571240105; Fri, 04 Sep 2026
 18:20:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260902-sockmap-lookup-tcp-leak-v3-0-b998b3d49d07@rbox.co>
 <CAAVpQUC==6KEBs3XgFjZ536mJ23cbHma8HuiWMu1DRc_=YYOHg@mail.gmail.com>
 <20260902155216.4fa23444@kernel.org> <CAAVpQUAWjBuF1Rgze0Vt_XvkUT=Ajw-F+Kh+s2iHk38c8iAapg@mail.gmail.com>
 <CAAVpQUATOCCc0N1jnfy2+tkD_zj1su-a-4+bV6qXOSzR7y_iQQ@mail.gmail.com>
In-Reply-To: <CAAVpQUATOCCc0N1jnfy2+tkD_zj1su-a-4+bV6qXOSzR7y_iQQ@mail.gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 4 Sep 2026 18:20:28 -0700
X-Gm-Features: AcwNN1UINzK3524FpZxXYWs5I9-HPFyb-jm4MKb0Vr_8_U4tRNTF9_M_llHPnxY
Message-ID: <CAADnVQKi0yji3iEepgwy6c9cXWhzJqGJ9-gg-7NXJc5Jj+bVeA@mail.gmail.com>
Subject: Re: [PATCH bpf v3 0/2] bpf: Fix socket leaks around connect(AF_UNSPEC)+listen()
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>, Michal Luczaj <mhal@rbox.co>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, John Fastabend <john.fastabend@gmail.com>, 
	Stanislav Fomichev <sdf@fomichev.me>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Willem de Bruijn <willemb@google.com>, Jakub Sitnicki <jakub@cloudflare.com>, 
	Jiayuan Chen <jiayuan.chen@linux.dev>, Joe Stringer <joe@wand.net.nz>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, bpf <bpf@vger.kernel.org>, 
	Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	netfilter-devel <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org, 
	Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 2, 2026 at 4:06=E2=80=AFPM Kuniyuki Iwashima <kuniyu@google.com=
> wrote:
>
> On Wed, Sep 2, 2026 at 4:04=E2=80=AFPM Kuniyuki Iwashima <kuniyu@google.c=
om> wrote:
> >
> > On Wed, Sep 2, 2026 at 3:52=E2=80=AFPM Jakub Kicinski <kuba@kernel.org>=
 wrote:
> > >
> > > On Wed, 2 Sep 2026 11:58:49 -0700 Kuniyuki Iwashima wrote:
> > > > > Several BPF socket helpers acquire a socket reference only when
> > > > > sk_is_refcounted() =3D=3D true, and release it, independently, by
> > > > > re-evaluating sk_is_refcounted() again at the time the release ru=
ns. TCP
> > > > > connect(AF_UNSPEC)+listen() sets SOCK_RCU_FREE on an established =
socket.
> > > >
> > > > Due to several bug reports, we are now inclined to forbid the
> > > > buggy transformation.
> > > > https://lore.kernel.org/netdev/CANn89i+px52TtJy3S9=3DuHxGj3s-WueguR=
o1Z_4FxO=3D02KLmwmQ@mail.gmail.com/
> > >
> > > Kuniyuki, would you be willing to send a patch to do that?
> > > Not sure if anyone else is planning to, I wasn't..
> >
> > Sure, I'll post one like this with s/synchronize_rcu()/-EINVAL/g
> > https://lore.kernel.org/netdev/20260804015349.2353056-1-kuniyu@google.c=
om/
>
> and cover IPV6_ADDRFORM.

sounds like the fixes in this patch set won't be needed,
so I tossed them out of patchwork.
