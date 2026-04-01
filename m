Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDC537C101
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Apr 2026 21:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775078602; cv=pass; b=CExN6EdrOD0BCg+rkdyTf04PC8iin2+xDefGVoLzYjg1dH7htsjzFsvAdyGoJTDB0J8yLB2jZsrBtAAc6tSllx5Qoq0NM3leKC07w3tIlD96gAqoVOylngWz+YAiQUxvIE6M33LpXdDnJsnzNPH5VOj+JY1lMmslTe5IfHNPf44=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775078602; c=relaxed/simple;
	bh=22PzYe4g+q67LhAXGP8TetwrwN45cW7JKmWdgg88E+8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=npK9Eh8yvnwSMQFAJ/wMqFPgnQQ4jJ4Ep5jIQOu5MP55HtugrvG2MxvFUuBKhrvrimrlTaKZaw+wRDAwyaeIS+22fQwo5XIxmHoW8EVlCqvNsFANmfBmWUq22EdTdKvhn1K8NzO7ilxP4bJq8rB1YHz+QLCpZzQMtYWiZhoTaNE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=a7XtP6CY; arc=pass smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="a7XtP6CY"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2a9296b3926so867245ad.1
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Apr 2026 14:23:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775078600; cv=none;
        d=google.com; s=arc-20240605;
        b=VONDFVrdJ9/Q/W2qZKJTdv0vjCq6f3h2uB21fPepNj/2RSO2Iny0ea/AXiaTlQVpt7
         1lRliWH/JaEyeLadjSP0/UE84CEQaDvMnnbESr/yvN9ZfX2l1/687p60IDksZaMfXSlB
         g9NnqM9UrJyfMPtsp3Y+CMnrj7Vdeqibuw1xyuOQgikY5w56vbgeee85XQLiA1iDv6pj
         BDGNWuLHH4bHVZLyIjOczgA/YkiBYlckWNu/7tUkfMTT8l2aBqPrUf11i4bHzz0U07nD
         25iOSjNvHL0B0WTI9Kpp0aErke+c+8p74w+w94Bjv7hQsjwm2cTpHgEfT6hyDJP8LEwn
         0r4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7Om6Yg/2zA/cbTNg7qKf7Hf+m++Wf8FwyUUwYISosbw=;
        fh=3XSCj8idsmYTIjrElbtibxD6L12Lz816qkj2R+0Iw+s=;
        b=fwWV6ZSDQeMFxYCamiKUKsMjBaidb9sLuoeUpDrkRXFFQqq2p1T2iZ2hj1E0y+Gfl1
         mNU/3r4kiIYW/vw09kzIzMHlB3153h5y/PeIjxuiskEanK2IICL86uJhnnlYSsBOVzIy
         sbGywX9rTy6C9NjmJRWHqCNErsTx0xm+IFH3w8mu4HTEJC5Xb/Ny1s2F2MOB+ZPwmhGr
         uFriWHvK2M40wPN66wd9wSPuKh6n5940xpHRGxkaJ31MScwkIhg+GvEqOXmQRhdAr9MW
         H57hfzfkOWMlbwp+T0KMC4C8s91F6RrnAKa/5/jYHpgJact/e2uYgc27zP3Egini3xDt
         ywzg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1775078600; x=1775683400; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Om6Yg/2zA/cbTNg7qKf7Hf+m++Wf8FwyUUwYISosbw=;
        b=a7XtP6CYpk2D1P8nvPBbQN9lYgaqZEi+UvWCVN+6OZCf9TdSywDKXViI0NqSydX12S
         Sv+mHFBRc7XREjuSDG9ugckrJSsfUfD/Efs38xrBwJE51JvOQQkIQIVopyJJFfTYK7I9
         064Ofax+eE4r80zbwpPSI2EwDLWUdBZ8PhT38BMFlB2y9goV9eleMIEGNCZPbANFM4hy
         ep++x1ouoJfdtML9qs8jkSEB2oE/3lZ9Oaea+nQtwK3Xil4xv1alv8cGyeOuzBaBCIRF
         0FhA5LY8gnkU2lr4s/JTGMprn7dm0JFll00eDUR2T9ibdB/9xOJMJwrXt63RQNih4kQ5
         in1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775078600; x=1775683400;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7Om6Yg/2zA/cbTNg7qKf7Hf+m++Wf8FwyUUwYISosbw=;
        b=Gi5WsyWWlNfwRNTXS4pjCNo9mqUdn/PPhJVaiqigDQn2Q1fW6ldDQ2PB/15kk39A6/
         5tyIaEdslwh38Do5uBG/QskSJMNUSSB6gotNgkaNvqAVcmWaKUj7FujF0eWAMfaFnX4r
         AqwArRKGWUm4bBAehd53oo6xW/GxV5hJxUv3oo9YrjncGr14lxylGV5pCvdbH0I4BT3O
         hcEEuxqQwQ30kJKbT3UV7OIF8QWph1oxGUlfPoM7cPHL15M5zLonyPHlX08c9SVhxDQC
         h2w/6KJrn4IP419ciGrwWQcffcq2umjbwzTgmag8Gszy/CFZiSO0oYAoHloQBKZr7pki
         np0A==
X-Gm-Message-State: AOJu0YwFmTzqoptVBAPEdfPDYLNxGVM00698rZI3CMYwx4zn/60+6MoD
	eLLM4En1JNvW/6uL2VD+KeIN6C5Sm2HUAKGFXxveoCFZtOLbGZZo2mNmBG9T1BOEpd77+Z9bLBy
	9UbLsDDqprIxecmpH3eb5lufFWD4SgyJnsBeRmjhz
X-Gm-Gg: ATEYQzxfNMNJWIZuidPrAi5/gmfV1HMr8aL+jf76farm/igWEnequiP/586SzfsJRCY
	omJi+VEwDOgDV3aNKK/UnpzJcG+2t8RfwokD9NM2+m83bBRtKFaZBo06rFHj8wLO3Ga9oh4H85y
	fHRVKdg9QgAW0Tx05nBLqhOphFLm/Hk/SwgztynPQRjbfEcobOSGKwvHepRPjVoYGWBdCkwNgkC
	EPc9O/+lEzXkKFksUeu17d6+q3r4uzk0Tvg6tV7sbbt6ViQI7HfgOsieYjfKdAobblaeXj9bBdH
	P0IGtvG+
X-Received: by 2002:a17:903:380e:b0:2b2:45b7:307f with SMTP id
 d9443c01a7336-2b269a9cd8bmr52451315ad.9.1775078600243; Wed, 01 Apr 2026
 14:23:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260401195735.564488-1-xmei5@asu.edu> <ac2Ce-hHidTY8Z6V@strlen.de>
In-Reply-To: <ac2Ce-hHidTY8Z6V@strlen.de>
From: Xiang Mei <xmei5@asu.edu>
Date: Wed, 1 Apr 2026 14:23:09 -0700
X-Gm-Features: AQROBzAuT3Beam5f520OlCmTfwlIezeqz2pdvsn7A46gMGM5WFHjqfS7FU4c3fU
Message-ID: <CAPpSM+QfQxotFf0cBWRQcnZyTZH_6bNtSrK_CBEBaMri6upYbw@mail.gmail.com>
Subject: Re: [PATCH net] netfilter: nfnetlink_log: initialize nfgenmsg in
 NLMSG_DONE terminator
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc, 
	davem@davemloft.net, coreteam@netfilter.org, netdev@vger.kernel.org, 
	bestswngs@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the review, v2 is sent. Please let me know if the usage of
`nfnl_msg_put` is incorrect.

On Wed, Apr 1, 2026 at 1:39=E2=80=AFPM Florian Westphal <fw@strlen.de> wrot=
e:
>
> Xiang Mei <xmei5@asu.edu> wrote:
> > When batching multiple NFLOG messages (inst->qlen > 1), __nfulnl_send()
> > appends an NLMSG_DONE terminator with sizeof(struct nfgenmsg) payload v=
ia
> > nlmsg_put(), but never initializes the nfgenmsg bytes. The nlmsg_put()
> > helper only zeroes alignment padding after the payload, not the payload
> > itself, so four bytes of stale kernel heap data are leaked to userspace
> > in the NLMSG_DONE message body.
> >
> > Initialize the nfgenmsg struct after nlmsg_put(), consistent with how
> > __build_packet_message() populates nfgenmsg for regular NFULNL_MSG_PACK=
ET
> > messages, to prevent leaking kernel heap data to userspace.
> >
> > Fixes: 29c5d4afba51 ("[NETFILTER]: nfnetlink_log: fix sending of multip=
art messages")
> > Reported-by: Weiming Shi <bestswngs@gmail.com>
> > Signed-off-by: Xiang Mei <xmei5@asu.edu>
> > ---
> >  net/netfilter/nfnetlink_log.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_lo=
g.c
> > index fcbe54940b2e..ad4eaf27590e 100644
> > --- a/net/netfilter/nfnetlink_log.c
> > +++ b/net/netfilter/nfnetlink_log.c
> > @@ -361,6 +361,7 @@ static void
> >  __nfulnl_send(struct nfulnl_instance *inst)
> >  {
> >       if (inst->qlen > 1) {
> > +             struct nfgenmsg *nfmsg;
> >               struct nlmsghdr *nlh =3D nlmsg_put(inst->skb, 0, 0,
> >                                                NLMSG_DONE,
> >                                                sizeof(struct nfgenmsg),
>
> Would you mind sending a v2 that replaces nlmsg_put with nfnl_msg_put() ?
>
> We already use this helper in __build_packet_message() and it takes
> care of initialising the nfgenmsg.
