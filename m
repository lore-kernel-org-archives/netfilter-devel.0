Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDED4317B
	for <netfilter-devel@vger.kernel.org>; Sun, 21 Apr 2024 20:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713730413; cv=none; b=pbW22kyjUjcGO8yxgLtBkcBUhQ6OCrZ6sCoIkMr+3rbnKMt/M2wN33OUdqyIXDDk5fTUDfyg+feHXgySbm1E5ZDKcy9hqTGTG92huGdeBZ2g2rpVgKErh461Ae73fBpM/f9vLk5lA31/06tEaYj9rXqD7OdXXV7QeaMk7tOaHPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713730413; c=relaxed/simple;
	bh=n1r+2yz6msZNjy9JapePphXlZGdgwzjaqnnBd2Y3ahE=;
	h=Date:From:To:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J1EGp1TX8JbPB+k1v3tLLacebQP4whv9w8d4RCNhcGuUmSKkbidXeSU4udrQsPNyOs+/PQabiaATumiQ+f/+E3MOjdRX8DTel7bhaksiDc8oJDXM2bcdh046AhlE7AGgkM7jPQwnTEtjP56PAGOBSMVbDHzLoZF+bRJPhZxbFRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rp7ha/c3; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rp7ha/c3"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-69b6d36b71cso16718336d6.3
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Apr 2024 13:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713730410; x=1714335210; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:to:from:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6xVopRBZeRJV2CmW2c3JUHZS0TZBwvmRbdG3tYGq31Y=;
        b=Rp7ha/c3XfNQ+OZxVo6RuqzPmGxpJBOGgMTNpXUbV/GbNgE3DcF3khTKjWu0h0ITpy
         xZfJzJHjMJnbUa5exgpMiLkAaftDgU0rngm/PEs2eeqOs+s76+PPdfy2Fdw9W9YR+R3M
         xoAzUFJyAL2MlbNb/9SbXa8K/Y4S9MkdB8zEXID9RTRsrkxOjNcT2jbStkyovkRtjD6l
         YbJPytuQt6YCR3Y2MC8utlAJo5UtZnH5K4Tz65I3dNyfxJY7aKwufMwg6LwDEa/8b6rV
         y0UDHc+EJQRTsXL/nK6urPXaZsJQWqpCkAVOHY7kbB1IT8uoCtYP3NSK26UOkLivl7bJ
         dmXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713730410; x=1714335210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6xVopRBZeRJV2CmW2c3JUHZS0TZBwvmRbdG3tYGq31Y=;
        b=oNfaSnrI94Igwlk2teMvZ9B3UNmdvXPFnRvWv/MjLbC8uQoBjAzxYBFQn26OL4/VtY
         wzS+dCS+qUKOy7Pbvt72QlnVvpl42n8bhH3uT3PSRlthyZLJ1dZbkdugtH8eM7Om6JIf
         VuAorsPSzk/XjmKo+fVi4yrpcEwjUlxWuWuN79u1pEWVya3yAlxraluQIZMZKVYXjG6q
         L9U1OKM6PGvwpo64Hhw/pYUqXdTVvSZxhZeswO2PF5xaCI/oNtFZK2MrQKkYOnnOuahE
         MTTbffGkDcXAsglO0S7Oh02o4VYX3pM8yiRa8C5X/yG9zwa8+nZoVD6G9pxSZMTeQw6A
         psyg==
X-Gm-Message-State: AOJu0YwjdOf4WLZ9Te9hxYNfyblUErqusFF+b4oXLwJXr4z/QDKyNChu
	sww1h5TvJ57TQ/OyEJFDnFzcsIMQ4I/mKx1tiOeMthhDASWz2CW7lXnssvRz
X-Google-Smtp-Source: AGHT+IHTZnLjP73/mjdd6vH8yvltm0hkr/9F+81MteWb5hKlD/CDEZPoDdfmOmdMY72XQnLbg846vw==
X-Received: by 2002:a05:6214:29e1:b0:69b:5803:d961 with SMTP id jv1-20020a05621429e100b0069b5803d961mr10350883qvb.0.1713730410641;
        Sun, 21 Apr 2024 13:13:30 -0700 (PDT)
Received: from playground ([204.111.226.63])
        by smtp.gmail.com with ESMTPSA id w2-20020a0cb542000000b00698f01a958asm3625379qvd.77.2024.04.21.13.13.30
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Apr 2024 13:13:30 -0700 (PDT)
Date: Sun, 21 Apr 2024 16:13:27 -0400
From: <imnozi@gmail.com>
To: netfilter-devel@vger.kernel.org
Subject: Re: [Thread split] nftables rule optimization - dropping invalid in
 ingress?
Message-ID: <20240421161327.626f4a61@playground>
In-Reply-To: <20240421175000.5fa666d7@localhost>
References: <20240420084802.6ff973cf@localhost>
	<20240420183750.332ffbad@localhost>
	<rNVqfcHpj4XyJlxISjkKDdyRHbyPqlyF8MOHq07xz1_V3vc99maPQTsAuxgA2PZNbvff2dUfl2s0YdJBI4muw8A7FiMeKu2KvnjK0fG7kYo=@proton.me>
	<20240421175000.5fa666d7@localhost>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 21 Apr 2024 17:50:00 -0000
"William N." <netfilter@riseup.net> wrote:

> On Sun, 21 Apr 2024 03:45:31 +0000 Eric wrote:
>=20
> > I'd be very interested in seeing some statistics on how many actual
> > invalid packets you see on a live link.  Stick some counters in there
> > and collect dropped versus passed packets... =20
>=20
> This particular system is a desktop one (rebooted often), so that kind
> of stats won't make any sense.
>=20
> > My naive guess would be there are only tiny percentage of rejected
> > packets. =20
>=20
> Without a particular attack - quite possible. However, it is always
> good to learn what is better/worse/futile.
>=20

[Again, this is iptables; your mileage with nftables may vary.]

=46rom my firewall that's been up 30 days; I think these are reasonable numbe=
rs. It shows the total packets that passed PREROUTING, the packets from int=
ernet dropped due to my blocklists (which probably includes at least some I=
NVALID packets), and the remaining INVALID packets from internet and intern=
al sources. These two are the only DROPs in PREROUTING. Ballpark, about 0.5=
% of the packets are INVALID. Small, but not necessarily 'tiny'.
-----
*mangle
:PREROUTING ACCEPT [728638:3046835361]
[43686:2232175] -A PREROUTING -i eth3 \
    -m set --match-set blockSetHost src -j blDrop
[37712:1840302] -A PREROUTING \
    -m state --state INVALID -j invdrop
-----

Note that dropping them at the top of PREROUTING prevents them from passing=
 through the rest of the rules in PREROUTING (and mangle), and rules in nat=
, and any rules in filter they might hit before finally being DROPped.

N
