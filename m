Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA56F20C029
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Dec 2025 13:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765634341; cv=none; b=FQQ4dXOYVp4Y1iiMze/e7hDCG8OrurEKn+Wl60XDm42mxJLEeo2eEvXXLGuo+A0OGQo+e5yts4tyJtUGqAljzsFC0UH3AqnT/eJ2zmE/aDKvZ7zW949Xz4/By15xJwu6CZFA7e0C54nt+C6WMSxprylQfDE7DzIsXvEfvZgDyD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765634341; c=relaxed/simple;
	bh=OS8/bA21DIVh/jE195m28LnszNODbHbW2ZaxE7xVS9E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yk+GtCfwiG9v6PdwzhOvr5jEWJNpxUFmVHcN6wyCC43FBeReoSqc+G4Q3G89S4ev00Gui982xS5AHmGuAiKXwdCgP+Htm+sgdJAIS/OBEfMEHkBgvjLuYT4qBKFmq7wElgfigqbkoeK2XFXnDNqO5+6cHVZgfz6Wt7AWlksXoIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a62iKdLg; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a62iKdLg"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4ee4c64190cso16785101cf.0
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Dec 2025 05:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765634338; x=1766239138; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eGsRL9xvdoN6Nu3uyTYTSI9WjXII8rdvZR3ee7/1ydY=;
        b=a62iKdLg+kXXWk7X7+00WCtcLpip00eruQaMLNndZ+Q++qtB2PefKy8okMepdyI6+O
         3XM9IzldeBTP/qdBo2vk8BP5VQbdvwFHSGyULqayRwfgco8eJ/iaFylQbhzF/mIQwPS/
         5szzfCMTaQSuhwwPCImNGOaSp31BmvP/FaFP30VZn37HIu1QOOEushtK6xZ7kPf+GN41
         QRvhAKKJE/Qlk0p2Z0/7TnmbKkSuEg3HUTmz2kMuBAjbDbDebVtFFpqJnWMkE3QLpw0m
         /21AtP2eQMyekGOsGSGY3HFy0cRmJGHoWtU0XpwYzRTSmzFcxpRZR/0qRHoZDFdSBX0i
         MCFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765634338; x=1766239138;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eGsRL9xvdoN6Nu3uyTYTSI9WjXII8rdvZR3ee7/1ydY=;
        b=h+LkLhywpmJnBJzDbrjJGE/QQhKfrQV5Pn871i08cKu0jFDh3+bGnAS35O2AsE9na9
         J+9zpZbhc4YX7Sua9WSuvmJKHz1aaVHce/5PSzvc8QpmSX3e460rShtSsYAjIuBxloqg
         qfC1LyvrXICmYjdcJjCkdJFPTNTV7kHmiZ6tFloG2BXTc48FInBvEnzjRUBK9fye0I8D
         dpU8IerVXr4SUOFAQ97UC+LdEB1+NIE++WwwmqG46atgjZvLUMv42PDqSAcgN1JH7qFl
         /tZTvVrzVfjc37QS+eHmyygHw8mgO51tKf069WEipk0wIHKkpuJt8SSD0uChh6LWJTnH
         CbCA==
X-Forwarded-Encrypted: i=1; AJvYcCXM/A0Wimmw6JXJFNO8StkAmSYyBit2+nmk+hW9kd0GStuMdR15hFCAn/5Na7VZ/evBgUsaixLqwH5BVZWhrGA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+4pY4kfQQfu7Dk4ltaQpJWpy+Z6GWv5F5YsGW2YSER8BGUKMu
	DdAFDlTzRbcA2Gx/DETWtIw9G4GuDaesJcBSolPJXMVB2PdOM78euxtNdsC+3Mb84tKyHG0fRhn
	kxkDO9DaE/Hotn30TPwMD5F+KmnHMtVNJ6aC+WHCC
X-Gm-Gg: AY/fxX7BAL+vPXjcdLQfoag9BtxWmRNCUxNTZakMxGfF/FblwSaUzsmhy8LPHAXlD5z
	kUFEbLA7fJRQfaYPn/4w17rH+c25qtgX4/d0gk2mtJ0kuoTViC5ZBwC4bP61l2bAodgqE6Lky71
	QuvnbZRkbk1Ygh07AuAfZ8+NaMSW2dC7syRWx4ngl/N9WHYLiBb67A4hoZAvFX+/++xVBJ0rfiH
	aib9LwvhRomGwzEyH5HxYHu3FqTkA7ENyMw0NVH20ansqVA7gGDEIGLx/nqbS/md+sWqg==
X-Google-Smtp-Source: AGHT+IEdpu+q0erHGj2deqRm9MF4wNnxJTK3SohJhVUJYmXZSOmWySCPn66woJHfqew+wYsVhgEh5wWW/M4ySVKeSzM=
X-Received: by 2002:a05:622a:410:b0:4f1:c738:1fed with SMTP id
 d75a77b69052e-4f1d0479dfamr81954571cf.11.1765634337304; Sat, 13 Dec 2025
 05:58:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <693b0fa7.050a0220.4004e.040d.GAE@google.com> <20251213080716.27a25928@kernel.org>
 <aT1pyVp3pQRvCjLn@strlen.de> <CANn89i+V0XfUMjo5azSAkcr6EKucQFs6fv6mpNeL3rN41SsTzg@mail.gmail.com>
 <aT1sxJHiK1mcrXaE@strlen.de>
In-Reply-To: <aT1sxJHiK1mcrXaE@strlen.de>
From: Eric Dumazet <edumazet@google.com>
Date: Sat, 13 Dec 2025 14:58:46 +0100
X-Gm-Features: AQt7F2rGMYTMKwULp_shdo8qjWTSqqQIadjzIpezluGT_n2jI0V6gQxUo2QPHuI
Message-ID: <CANn89iKDFe83G4_bmzPVkKwVwNcxTX1pyjBqoHwrt+rk3A9=dQ@mail.gmail.com>
Subject: Re: [syzbot] [netfilter?] WARNING in nf_conntrack_cleanup_net_list
To: Florian Westphal <fw@strlen.de>
Cc: Jakub Kicinski <kuba@kernel.org>, 
	syzbot <syzbot+4393c47753b7808dac7d@syzkaller.appspotmail.com>, 
	coreteam@netfilter.org, davem@davemloft.net, horms@kernel.org, 
	kadlec@netfilter.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	phil@nwl.cc, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 13, 2025 at 2:40=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Eric Dumazet <edumazet@google.com> wrote:
> > > > I looked around last night but couldn't find an skb stuck anywhere.
> > > > The nf_conntrack_net->count was =3D=3D 1
> > >
> > > Its caused skb skb fraglist skbs that still hold nf_conn references
> > > on the softnet data defer lists.
> > >
> > > setting net.core.skb_defer_max=3D0 makes the hang disappear for me.
> >
> > What kind of packets ? TCP ones ?
>
> UDP, but I can't say yet if thats an udp specific issue or not.
> (the packets are generated via ip_defrag.c).

skb_release_head_state() does not follow the fraglist. Oh well.

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index a00808f7be6a1b86c595183f8b131996e3d0afcc..f597769d8c206dc063b53938a18=
edbe9620101d9
100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1497,7 +1497,9 @@ void napi_consume_skb(struct sk_buff *skb, int budget=
)

        DEBUG_NET_WARN_ON_ONCE(!in_softirq());

-       if (skb->alloc_cpu !=3D smp_processor_id() && !skb_shared(skb)) {
+       if (skb->alloc_cpu !=3D smp_processor_id() &&
+           !skb_shared(skb) &&
+           !skb_has_frag_list(skb)) {
                skb_release_head_state(skb);
                return skb_attempt_defer_free(skb);
        }
