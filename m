Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF67362066
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Aug 2025 14:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219266; cv=none; b=aedTUPVNhw3SNLN/gjDswEx+iv1bm8Uy0vlNRR+2bBSG0mQTS9NcjW/qXHaLvySukOm/n9tA5e78FJ9/9EXX0UoukMIgaLjR5tKeFRezEoHR2NWgVrm1lDO0OIRQDqUkMYX28r3xAEEWcv1LMHFj43xIvhlmlK+6uAH9pCNYJv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219266; c=relaxed/simple;
	bh=hyCxhAYM+PA3OYD2qg0SHMzPnPjwfrsqspLLMQYlk24=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dVpS3EZldQb47MJ/Bxp5GFB4V4/xsJc0fAskwvc5GP6thRn/Z5iX3AxDqinPCDCOk7/MgkkvPyuvrGBUUmHBCNEWYC5/POMQlKbaqrjtWTI6MgwoUZAN3V6Onyn4r+sYihBG6ilbiquwFSXWT+H1AoTJbE2r2/3/cObUDPIOYog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LpgD5X+i; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LpgD5X+i"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-71d6059fb47so44830387b3.3
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Aug 2025 07:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756219263; x=1756824063; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mgJng7gbUZZ9Z6XUdf92AxiN5YcMf9KcpRV4KEnk74I=;
        b=LpgD5X+iRVIpc7002zZNLT/jPDE/Eqnv4uPJOrJFij7XRTiamoXMB9hVvhagjG3ECM
         HxdCokSOVy3Z6HvQ4BGigcl+34NkdpPcgillz/WqpOVHmeb/HdG8Q5iK0hKZqQb3Z904
         72CgoMGzUo04XlTCqvN/y60WtuTnXrswXgPLa2X9mVN+quuLm7/m/vsayxIXtrgJ/SRY
         LyhqP7Qq4ZBYqVohotNuYeUSVp8t61rv/wOF0y2kTaTg9rZ8zZbFVzWsWUhlWthrtgsC
         qP/9VtIgo/WCCkmFzYo1qZMDGOjLkT011q+sKGVhd8vzg7Mtu7p5Zkx39eRehAqWaGWK
         +c9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756219263; x=1756824063;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mgJng7gbUZZ9Z6XUdf92AxiN5YcMf9KcpRV4KEnk74I=;
        b=JIzLSS4hW6z1L5FqiM1HmNn/0CTGO30DrJZiPUtjHdKfXz9eFG9Pw3oQI3R3m7zkG7
         z/WJ9XbeXTi/fhJmljhLMoCM9+H6buDxiQ6VNn+XZB2w7zj3wmLJjwc6lpErz1byBWTl
         U1692RUv0IlKzfxP+BsVWEQ+0jww+KDD2UvEJSC2cbB9PbkHyuiy3/D/uoYD/5B7ygaH
         p3Pi0a8/ef8AR6ftA4YM2Fy2lJHMko3RIRO3DRrAapC8r1NZuv/jQCZcZfGMt8BHFzwd
         HQcvUPVM5I9IF4D1fTtk6mvWS3KKLx3X5kjtNX6nmaQt5tUoRRypRINoZrnC8srra9o+
         RRBw==
X-Forwarded-Encrypted: i=1; AJvYcCVnNGxDlcUV7PhN2p7uZ0DPeDT/VQUj8E33lIXV+ztgrK+tNPyfzJPzgZyNPbWNLXLhkTSVoFp9ZYiSLUpCPLs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKs4JEhRRscgSRscU/i8djJ12uJoBocuMh1rAKF3kg8/zC631n
	FcLfeZPawLKOCZREy1xgwpgkTXC5nAIhWU87u9LfSkWU9bIGKZ/3vOoKvasLstXRv0wWi/0u/4B
	nYVKJuaRET8QbOS6siBAJfPtf2qRhVs21QIm7W9vg
X-Gm-Gg: ASbGncvhppFpL0CSciaP4LHurhl1sButwJFO4ptK1lSSdLBX5yoTyXDcfPM6y/hVtKy
	Bhu9AiwgxDyCf3/uTRUtxLRgcG8+vnKJTHfa3ZN20LIJ5dXIBXHP+7FDRmf5w8396/0NZ0hn5A4
	ZUsD986iddrDVKgQoGVxGi2VE1a7VCs+rokSRihVfjRr6iUnl5bkYUwisbHEK6TeAcIgCTLtRzB
	J2l64E4XltC
X-Google-Smtp-Source: AGHT+IFesp/oI9Ak46NqKRSQa8N7DRHfHsYS7xFO5jugYlbdLYp0PlK7Sg2D2EF0K5ksP+hlagrHvGHb7VSuD4ocbTw=
X-Received: by 2002:a05:690c:fca:b0:721:1fda:e32e with SMTP id
 00721157ae682-7211fdb5f88mr57202097b3.23.1756219262794; Tue, 26 Aug 2025
 07:41:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250826133104.212975-1-zhtfdev@gmail.com> <aK3CQ1yNTtP4NgP4@strlen.de>
In-Reply-To: <aK3CQ1yNTtP4NgP4@strlen.de>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 26 Aug 2025 07:40:51 -0700
X-Gm-Features: Ac12FXy0DZXDFBRohoO9_uQKI_gYe4HZYQAW7aKbGnFlHhCAnD0bLM7ago9sXzA
Message-ID: <CANn89i+p=jBtqS6ijvQ5RWovk_DgZTBPnTLBMjpj2ppdVc_W_g@mail.gmail.com>
Subject: Re: [PATCH] net/netfilter/ipvs: Fix data-race in ip_vs_add_service / ip_vs_out_hook
To: Florian Westphal <fw@strlen.de>
Cc: Zhang Tengfei <zhtfdev@gmail.com>, Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>, 
	lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, 
	"David S . Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, coreteam@netfilter.org, 
	syzbot+1651b5234028c294c339@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2025 at 7:18=E2=80=AFAM Florian Westphal <fw@strlen.de> wro=
te:
>
> Zhang Tengfei <zhtfdev@gmail.com> wrote:
> > A data-race was detected by KCSAN between ip_vs_add_service() which
> > acts as a writer, and ip_vs_out_hook() which acts as a reader. This
> > can lead to unpredictable behavior and crashes.
>
> Really?  How can this cause a crash?

KCSAN + panic_on_warn=3D1  : Only in debug environment

>
> > The race occurs on the `enable` flag within the `netns_ipvs`
> > struct. This flag was being written in the configuration path without
> > any protection, while concurrently being read in the packet processing
> > path. This lack of synchronization means a reader on one CPU could see =
a
> > partially initialized service, leading to incorrect behavior.
> >
> > To fix this, convert the `enable` flag from a plain integer to an
> > atomic_t. This ensures that all reads and writes to the flag are atomic=
.
> > More importantly, using atomic_set() and atomic_read() provides the
> > necessary memory barriers to guarantee that changes to other fields of
> > the service are visible to the reader CPU before the service is marked
> > as enabled.
>
> > -     int                     enable;         /* enable like nf_hooks d=
o */
> > +     atomic_t        enable;         /* enable like nf_hooks do */
>
> Julian, Simon, I will defer to your judgment but I dislike this,
> because I see no reason for atomic_t.  To me is seems better to use
> READ/WRITE_ONCE as ->enable is only ever set but not modified
> (increment for instance).

+2
