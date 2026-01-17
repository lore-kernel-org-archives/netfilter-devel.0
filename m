Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17491DB13A
	for <netfilter-devel@vger.kernel.org>; Sat, 17 Jan 2026 23:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768692334; cv=none; b=S4walNBUy0HAh3nDRX1KP/xvxVZVY9MM8AjCJXW/rci+/x3Ec6ngXoNI/TGvmeSvVCS55yFUoaPvQ+pOYGIKAHTx0Sxgm6hPVPynV2Tbw3MkclEf0VkRYvHIth+9XA2unhc52bHN0Trn10R9Lfepp9wmIZ/ZpVwANYKtgAvNLzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768692334; c=relaxed/simple;
	bh=jjxONDZgz4g9AgjF0aVEKxaxXPmyhSjNp7R0R95MSJk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K89NcShTmk6Pqb8sh04wuASFL7QHW4oTQKW9sgipTV1cKZKHXiMBnMzRJKeSURfn2uULizFx/g1H5CzvfSXpbJ+pzK/SLsDTQNWBgoFYHFU770vE/ReimCQ+GV3KIVXDK1y7g+ia9YXe9d8LK6ycEqBhllT8HX2jY5zJfPLYq8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b5WzBoYO; arc=none smtp.client-ip=209.85.222.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b5WzBoYO"
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-93f542917eeso1049550241.2
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Jan 2026 15:25:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768692331; x=1769297131; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UcsCZwajE5u4VDllyDH/k10Ec6h96qHubd8jTuIYuig=;
        b=b5WzBoYOfw7BA1B/Iwd9yIoFu0ceZI64Vb0SHWskkSbQSWch/+WHcre6zNxjB458N7
         phRr19BAq0DJdDSLQF+xC9Sr5ZwmiN27UZZAcZCQwelUAZQcTF6tmNlmJ5QhKgMwSZge
         l5I042JwrubaPTYlHVvJc0+T8ae+GzR34OXahQ/s04lWvQNqgZEJkgR5+EssVd5a+d7/
         +h0x2u1ACuiarKOkID5cfUiTblfKLwjw/wXELnrxTm4WL525krqKep6duJUQHPvu68jk
         a/j0H+pQU8o2bKBUr945BPVshmZYdBPS+pPOF5SdGtGVB+KyT0aRAgHEc4tm61nyqw7J
         Iv/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768692331; x=1769297131;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UcsCZwajE5u4VDllyDH/k10Ec6h96qHubd8jTuIYuig=;
        b=puRDXlrpTdcfW870Z4dtBDH6MRfx8JIQnc9+N6awOmfsTnL/ZtPE2YZO7qklBx9Pw5
         0rIyzckquhVtUyJP07key1CXTVuON2CNJIMWuxPvIqu/oA8sgsULQGZ0mx9eeI5wEqLA
         k8C+ohTp0pRf7a9FZsner1ilpGvCbFr0N+mBBI1ze+/kBSE9D+RHVbavN8ZnLgPYuqf2
         ydMeQRI7hK/syWZWautpTLmYjmG2tMNFyZJ4Ue3N00NqPkXWSyzV87z7GlqIeGqq9rRT
         Tp6tom+fbPhhkRmz7ZlpFWVPB+/jZBURQVhcf5NIl5oq2FfN15awCwx+DxFifBj3lkvt
         79AA==
X-Gm-Message-State: AOJu0YzhDY2wbqhU5Vwl43qGSu6rTAvu5ivd8WhMCJmyBYp7GgjDcxEM
	uy0UYpNZN6DPXaANZpAqWB/eECbxravucjzYbniUDAwniKGFEaz3LIy+RAQKZPsE7jbV/rbfnwN
	DzI35fYwKD6OKS8sFPN9yUL5OnUq+OGk=
X-Gm-Gg: AY/fxX49Cd/41fkdZmYvJx2vCBHcSBOfWkA0BXGh9TJdI2s8smtB8T831qY5NoomU8y
	LCF001CMuNryXbfjZXmtj2IEgGyfQWlHna5gEgO7RvWosx3OwxKXVb9G9y2h4gfo808loDBuHOf
	4Ho18DgyAf/7z/KUuUa3WXSCOgSz2OW30aotH0FJ8lp89r2A5JqZiLUptXXWEI50BvLT8hN9B3U
	0f2okg2Yqcuj1UBnfluJAvDHgkdrDzYYCGP+Z2WA7BGrKtBwtXfW2fcmDjvGs2+caCwh3E=
X-Received: by 2002:a05:6102:b10:b0:5df:a069:4f79 with SMTP id
 ada2fe7eead31-5f1a71329bbmr2046709137.20.1768692331540; Sat, 17 Jan 2026
 15:25:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260117173231.88610-1-scott.k.mitch1@gmail.com>
 <20260117173231.88610-2-scott.k.mitch1@gmail.com> <aWwRCM4YZZ3gUP85@strlen.de>
In-Reply-To: <aWwRCM4YZZ3gUP85@strlen.de>
From: Scott Mitchell <scott.k.mitch1@gmail.com>
Date: Sat, 17 Jan 2026 15:25:20 -0800
X-Gm-Features: AZwV_Qin2q0aQbss7wyelG0OgbFr1aLei_KNnUSG9ukZPpEzL8qvuT9-tkWQTQ8
Message-ID: <CAFn2buCeCb1ZiS0fK9=1RZS3WOSLcdwV1c06JEFbgXTQCTVW1A@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] netfilter: nfnetlink_queue: nfqnl_instance
 GFP_ATOMIC -> GFP_KERNEL_ACCOUNT allocation
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 17, 2026 at 2:45=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> scott.k.mitch1@gmail.com <scott.k.mitch1@gmail.com> wrote:
> > +     /* Lookup queue under RCU. After peer_portid check (or for new qu=
eue
> > +      * in BIND case), the queue is owned by the socket sending this m=
essage.
> > +      * A socket cannot simultaneously send a message and close, so wh=
ile
> > +      * processing this CONFIG message, nfqnl_rcv_nl_event() (triggere=
d by
> > +      * socket close) cannot destroy this queue. Safe to use without R=
CU.
> > +      */
>
> Could you add a
>
> WARN_ON_ONCE(!lockdep_nfnl_is_held(NFNL_SUBSYS_QUEUE));
>
> somewhere in this function?
>
> Just to assert that this is serialized vs. other config messages.
>
> Thanks.

Will do! Does the overall approach make sense?
