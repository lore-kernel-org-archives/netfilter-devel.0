Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121E028DB3
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Feb 2025 06:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740378339; cv=none; b=S1stL3sI90a6pU6k0ba5sXCx6hA+2ABFIyYj/hC/OA2hFkOjfwKkxoON4X5WGCguc4bQT+Cd4dlm7+2Q2Isibn9MjbOBRIew78AaGED6R5hA6iGOjQ9rquFKoaLrpOEMAJbZz/VEpWsXzr4igOwEym6p8dQ3kaWHiqvy20vLi8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740378339; c=relaxed/simple;
	bh=Q445OS9oTmu1MFuyp1WYQ5L/R8nc5qFxwsVlfdEFEGQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WM25fd2N+1EJYAuXC34CylmQ/5HgFiJDyXzd0F/UUpuSBHbCORuw9PjQhAlcQPHgGXLxexeFJBCIfcaeR55kL9FZy9IZC2Eqey374AGBQPeVy4eSNH08+h6jITDpyVVca3+75pDBKU2Nh8ZHRSPJNkLwPXiHQp0MQVjzf4lJ3wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OjvuAa5k; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OjvuAa5k"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5ded1395213so6739270a12.2
        for <netfilter-devel@vger.kernel.org>; Sun, 23 Feb 2025 22:25:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740378336; x=1740983136; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q445OS9oTmu1MFuyp1WYQ5L/R8nc5qFxwsVlfdEFEGQ=;
        b=OjvuAa5kEjgVoPc+3iTkxd0x6kgvjIrjl0W2NFB+jGXKwAKT5Wld1JFWJ57xZ44GTz
         9HgrwU72OXKnqSvApaaK1InXKBQY8GTO04mmCCNEXN5PDc3Hw6p/jAR9I8JEEtgRX2Ax
         Ju/DdkKwVerRQ2t1QO/zEDdG2B6vhZYP8iKF6qomH5zDdEnquVp1uTrRwVZyM63i+zjN
         87JTgt/h5MSovtf9FhJ0sIMcn7JY9QSHqkuWwcrB6Q05YXhZVM4qZ22BwHwnGYN0r2M4
         2m5VTpKo2S0zxImr0FiQzXtwzy4FBbS5q8UZzktL/2ybDT+S5wsWl7aBPfAgvqqvu4ip
         MdGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740378336; x=1740983136;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q445OS9oTmu1MFuyp1WYQ5L/R8nc5qFxwsVlfdEFEGQ=;
        b=StUfza4kcMk5prKz0ddGcPMHEt6WQSytRrmmGOLPKfz7dX8bciEyR8tz5NP1sGD9z4
         BVod98UPWbGEwHu5HDDNZMMhj2Ne6M+FvqDv8AWFTMb41Ll+PKzwRcG6mKo+/ZUyYnMw
         pHrrg0fIv6TcXFCItzi3Qzodqvk24uKdtIUYySTm16TeAZLlhhM+K26bd7u0X3jEjutn
         xgOlwJKkgQ45ClJAeNNzEsW53CCGRKbrvLzRiN4gsArn2YRmrLsDFRuuuGqHO6oxkO+C
         DP1H4s2bhdE850Nm/4IMuAvFQIExVAq59XQwM3BCVd/LniRBbYh2/JFElIe3174AXuvZ
         HgaA==
X-Gm-Message-State: AOJu0YwJfu4ZQy1OYDx35tKsyEigwpaJ7aVLGlsF+ltxlZHqh3UcxsDj
	ASMDQ523PcbqhL1sFgMbuMX3rdvMlGJu+v3SYpJIdjkVwM6tS5ekCw2MvCAoMTGKh9szsDPH1Tp
	2O1oKVQfQ76lorpExnX+76LQxHHA=
X-Gm-Gg: ASbGncvXdCFLFOuBgTDqEkRWNe9/n+lgqXGR7DuUJVC0ql89BTVkWGicKERzFVnLjnB
	t2OylRcR6HPy//M8x/0hEZ1MTWjgf1BVc5ITbJB21AV5AWBAmP41AiKUPjgjZ15Jww/phHo07fJ
	pibJ15hmM=
X-Google-Smtp-Source: AGHT+IH0ZWzDRhpeqQNdFyKpYP2929mYoSX0n1xwMVaK8ISvgCOX/ZZNQ3TxCZ59kzEmunaIg0qh06iBLVNhw/imUEA=
X-Received: by 2002:a05:6402:40c3:b0:5dc:63d:b0c1 with SMTP id
 4fb4d7f45d1cf-5e0b7243b7bmr10948857a12.29.1740378336075; Sun, 23 Feb 2025
 22:25:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALkUMdRzOt48g3hk3Lhr5RuY_vTi7RGjn8B3FyssHGTkhjagxw@mail.gmail.com>
 <642q17p7-p69n-qn52-4617-6540pso33266@vanv.qr>
In-Reply-To: <642q17p7-p69n-qn52-4617-6540pso33266@vanv.qr>
From: Vimal Agrawal <avimalin@gmail.com>
Date: Mon, 24 Feb 2025 11:55:24 +0530
X-Gm-Features: AWEUYZmDxSZ1Gr1999vgwZD8PkcBtWOp-Km9wh7SGxCK7G3i0WIJXSw5b-dyJMI
Message-ID: <CALkUMdRa5uRo=j4j=Y=TtJe2OW1OC3sAi8U0kSRx7oZvFoNZxA@mail.gmail.com>
Subject: Re: Byte order for conntrack fields over netlink
To: Jan Engelhardt <ej@inai.de>
Cc: netfilter-devel@vger.kernel.org, 
	Dirk VanDerMerwe <Dirk.VanDerMerwe@sophos.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jan,

But we don't send everything from kernel to userspace in network byte
order. Even on netlink I see some fields are sent in host byte order.
I see this specifically with conntrack fields that most of all are
sent in network byte order to userspace. Are you referring to
consistency with userspace for conntrack fields ( conntrack tools in
this case)?

Even with the conntrack I do see at least one field (id / CTA_ID)
which is sent in host order as well.

static int ctnetlink_dump_id(struct sk_buff *skb, const struct nf_conn *ct)
{
__be32 id =3D (__force __be32)nf_ct_get_id(ct);

if (nla_put_be32(skb, CTA_ID, id))
...
}

I don't see ntohl being done for this field.

Thanks,
Vimal

On Thu, Feb 20, 2025 at 1:33=E2=80=AFPM Jan Engelhardt <ej@inai.de> wrote:
>
> On Thursday 2025-02-20 07:03, Vimal Agrawal wrote:
>
> >Hi netfilter team,
> >
> >Why are all conntrack related fields converted from host to network
> >byte order by kernel before sending it to userspace over netlink and
> >again from network to host by
> >conntrack tools ( even though most fields are not related to network)?
> >I am referring to packet exchange during commands e.g. conntrack -L
> >etc.
> >
> >Is there any good reason for these conversions?
>
> To be consistent with the rest of networking (IP addresses are also
> passed MSB-first), which goes back to RFC 1700 and
> https://www.rfc-editor.org/ien/ien137.txt .
