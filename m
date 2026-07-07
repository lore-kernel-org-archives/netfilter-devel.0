Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F253859FD
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jul 2026 18:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783447706; cv=pass; b=HYAJYyjt8NJF7fkTb8lLvQf0CJNZCKX3QQGT+Q+pFcvUkrqqtPN74gKjNycKy+Ny5CnsTekH3piVFZcptGvddUJvyQD7+RFRxNXq4YAApNq2tFBpCxqV2LGQz3GZaTMFMlpdrORuB2MEjYWivlRgN+D+quaNsg2xTnsdDGfMNZ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783447706; c=relaxed/simple;
	bh=1K73blC9Kx3yaOPYnxm/Zkp/YEqW54XsRRVie4JKAHg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eORjwhCcItCPafwf/AxpF8reUY/hv0hr53SzjZajQqi8zep92scQs/TPBE4pIQTHhwz5HRGT2i+ayrIczD/PvWbe6673yAb8Mq4s9oiiwQp0TUGqKP0RCLCecusPrGYItbx1U44TxsGzR3SOkocOOxsH72lPGFAS2nOagC7N3sA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U4E1TP9J; arc=pass smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U4E1TP9J"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ccdf36f63dso10875ad.0
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Jul 2026 11:08:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783447703; cv=none;
        d=google.com; s=arc-20260327;
        b=GV+ogJM2UWGu9mq2WHCa4jCEj7DsXZfNNePM7b9zwe5I56ZbR2xTh72r9Jo7ofyIzD
         LouhmLC1DrDjufn2u5tXHsCu3zVEZBoCK4SiiWlG/nJJ3qaKLFv9vxwhJHtFoPTW5bRF
         8E5eAR/rtGpvMSVSUdwa9oZqutueIZxY06HuKeCTNrDh04o5JZfxsawppR0BcZyxH6Q6
         FMsI2daKVl9Mp8CpZ0coVD+xXJANwKfjRq6AUmA1gKPrXZVrWlmbygCdYs/1YS1lx2ml
         EgFXQzURkfIYPyM2tpl4oagsP7RQt2MustS/0TjrH6x9cELOElA8tz1FbssUeGqbxHQZ
         jFNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7AyY3In+/2qmMESFL0/aH5QS9fOZYo5idMgvT2hn8Fc=;
        fh=n5dbouMqIJ5MdRme7pWNhtW7d6Cas+P+7EHDjxWUlbg=;
        b=DZ/3d6TGCyOm/34+FbXJw12IEXNI9kR0LWVPepraH/A1wS/l4IXJZUr5T+Qw15OyAe
         rm6Vmli8tqRTocrcQg4Vg7fFCutb8rrqrRT9i4/LA+cjdLQsgdoB9bvPe9uZSq0vECZ+
         Ll+OAySUfFjquHjW8hs6jV5bUohuqo5ta7vqnOQRqYO03E8w9PpeeGUHlzFoMws5LtET
         ylkvPY+oAGRIYRS4YbOmKjuIJugrlrRZ6+slvNWIppad2YD3Blr+yZv1+RyMF7omM0Ml
         Qiy4HMpfMy/r2l+eTGm21peNS2dvGk8HzxZFPgpWQRG/FSQc3J09E3G3MEjsy0ngZjB1
         Mpew==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783447703; x=1784052503; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7AyY3In+/2qmMESFL0/aH5QS9fOZYo5idMgvT2hn8Fc=;
        b=U4E1TP9J56LQtx+hII1VURftSaTiurYbSkismgGXw2QLtQzD0fcXGzp70dmcc5FJto
         pH2YU/tZhiRwS2QinCEwvclItZraI6w3VdKGd6yrVmhb0fk5yXs2H4BtH0tb/jgk8YNd
         li4ct/ss9/8Jhw/q+jE6tlLG4wk4AmqH07e4v1FzD5YUoIWxBlmR+1y3Vw0mTLKhp8Sx
         I/tU0onj4bL++Yw5VWayPe8tb0ahI6ELtORxhicJUEk7tZCClMlbAF8ItCAKzukRXHG1
         IcaXEIR733fOIKqRx1dd5KDiuXZawhPnor1MoIhxrfA7vDsTBY6mB17idNdf2eibRzEa
         PkXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783447703; x=1784052503;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7AyY3In+/2qmMESFL0/aH5QS9fOZYo5idMgvT2hn8Fc=;
        b=YEHsumPc3dgPsPDQwmZVZhTB8zGY3zBisFYMS2akId8kEXmtut8I3EEWUbOxU7iQQr
         5Y/MXX6lctSGz1+/57QPnkS9xFKEIL6XGFOa844FVUb1mDoO9NCWDKKPM+KgaZqqh257
         i2cTgH8ug31iSOVOVG//WMG4CfDXQsv7TQSUwodofnQuO1trrCvjeCkf//U7jQuV6jkk
         oA+NbE71f9Sm2LZki5s2l22y986qyVu6agawApJHGRcFH6bmzxI0iYjfg+fTdrWQjgAI
         yKyx3XrOTvNFnmGB1OHWRutsxu6nv62zjzCLQ3kNdh0pQiMnbvDT+zQIhh6AYH9W4qOw
         vjvA==
X-Gm-Message-State: AOJu0YwB3Gh/u5pgDp5oRu6PO6gn9R3pzobCnU4bqyeyanekZvXCUCOz
	EnwzTZuT1MmDjo/12BtAi7qitclDFRohxuPRYDjfbBjufX+oRCfadpbl2tJuFyqLEQrNsrS3Seq
	Qo+1ceNNImxPWrMUskaVnlSG4SpktPnaTf0wcfGeTR+FNc/fbzO5LFdFS
X-Gm-Gg: AfdE7cnuqNLXnjZBjzz48ClxEpMIQbA1Big1U4HbFJlWlNFQISJ7DDaLkZSAat5d8kM
	YjaGkVTZ4VdgnGKZT98eMPrZpWKvkLp3ECKRtSzLRejZyxg2HJD606HYEmEtgsgE8RwohLwAa+A
	BpycI6BqlFO7tZ6cEXZCp8Q4f5qCv26aaI31xxru1IPlUHOKvtS2HRlPdeXDfhWXn0Kr8X41tHK
	59mFwQd1kAHhWHu6cam5pGjfba+AOnilpj8pLmOqtn5FZSEJjG9dwJR1gZXIz2AKFHGBS3YVVGb
	uMYfLpq7qsqVeZ6BZYIj4pgKOLE=
X-Received: by 2002:a17:903:11cf:b0:2bf:1000:d3ac with SMTP id
 d9443c01a7336-2cce607e197mr62705ad.11.1783447702719; Tue, 07 Jul 2026
 11:08:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260707111808.15057-1-fw@strlen.de>
In-Reply-To: <20260707111808.15057-1-fw@strlen.de>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 7 Jul 2026 11:08:09 -0700
X-Gm-Features: AVVi8CcZg6H7ZCwpRa3JUtgS5K2ltjGsH05X3uwsHfDHz7YhQht0vUfu_hvaCDg
Message-ID: <CAHS8izP7YQ4er6Fuq-yzC1-=eUPYeOk1fn_Du=bd4tDgezjGzg@mail.gmail.com>
Subject: Re: [PATCH nf v2] netfilter: handle unreadable frags
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 7, 2026 at 4:18=E2=80=AFAM Florian Westphal <fw@strlen.de> wrot=
e:
>
> sashiko reports:
>  When an skb with unreadable fragments (such as from devmem TCP, where
>  skb_frags_readable(skb) returns false) is processed by the u32 module,
>  skb_copy_bits() will safely return a negative error code [..]
>
> xt_u32: bail out with hotdrop in this case.
> gather_frags: return -1, just as if we had no fragment header.
> nfnetlink_queue: restrict to the non-linear part.
> nfnetlink_log: restrict to the non-linear part.
>
> v2:
>  - skb_zerocopy helpers don't copy readable flag, i.e. nfnetlink_queue
>  is broken too
>  xt_u32 shouldn't return true if hotdrop was set.
>
> Cc: Mina Almasry <almasrymina@google.com>
> Fixes: 65249feb6b3d ("net: add support for skbs with unreadable frags")
> Signed-off-by: Florian Westphal <fw@strlen.de>

I don't understand netfliter implementations enough to confirm the
error handling is correct, but in general handling skb_copy_bits()
failures due to unreadable frags sounds good to me. I definitely did
not address all the call sites in the first iteration, so:

Acked-by: Mina Almasry <almasrymina@google.com>

> ---
>  Mina, there are other places that BUG on skb_copy_bits().
>  Could you please have a look at:
>
>  https://sashiko.dev/#/patchset/20260706155219.23757-1-fw%40strlen.de
>
>  and see if those need fixing or not?
>  [ and the v2 review of this ... ]
>
>  Also, should skb_zerocopy() copy over the skb->readable
>  flag (or refuse to handle unreadable skbs)?
>

Yep it's buggy :(. From my reading, skb_zerocopy() needs to set the
skb->readable frag on the to skb (and clear it on the from skb?). Let
me find the cycles to fix that.

--=20
Thanks,
Mina
