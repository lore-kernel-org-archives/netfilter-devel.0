Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C027A210186
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2024 12:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730984154; cv=none; b=L1nNKhk1sX59aFCox21XRKYPR6z8L9HMxG5ZCmQLdGqHVTE16NsYMYiSO69CpSlBqQS/EfgOd77mOSc1T/VWA9BfrjiuRvPG4O4n6skY5Z5slyD08fQVoYS8vjwr5W4VXEHzyGs6NqM6EnP6yuI1mdELzxkIkJ1xi5BtECS5D0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730984154; c=relaxed/simple;
	bh=MNGuxclNZEl8wDL9mnqdwaXSxv3EbzjWppbI5JuQjko=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bF+OJ9QETQgZOj6qHX9jz9+E3yeCqpcs3k8YqX5hhPWYgrRW2XkuNvEMhG4JLH3ENT+q91eCumTLCezj1F22QidK1OdCz2Bxp56N4mN16jFv0EXW8N7ppT4HmWBUnfXWDkcaTb0QPrQbzh/QQ2NSrZAojZpn8siaLXbWtpKomto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mTgeyjuH; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mTgeyjuH"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-83ab21c26e5so34479139f.1
        for <netfilter-devel@vger.kernel.org>; Thu, 07 Nov 2024 04:55:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730984152; x=1731588952; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MNGuxclNZEl8wDL9mnqdwaXSxv3EbzjWppbI5JuQjko=;
        b=mTgeyjuHYPIEnHh/8SsxDKAwXYop+nczr95YtrvJlldFgn/GqQpJG+pYqynSdJf790
         LtDO3Aredb3UKsIVLt3yH/xbSDfTZTgJIZMOHnsNfTmOuebFlMLK6BrJesduUz4g1fW2
         GdLns5j/CieAzcmOeMLY7Ew5iTCEX8pc/MsnAz6sbYaS1FeBCSmeVMnDwH0TUJzuZ35o
         njZrl7Y7t8y/BKAqogkECoiuoMYvV0epmd7Q25szYDH2G/y5WvTi85isj43z2d8timT8
         3h5727Hhu9/XjTa/69T13Hurh1WwkbcQz+d3KFUeawvfbKFdCVQkvnJ7AIsjnG0lzLRZ
         JyeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730984152; x=1731588952;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MNGuxclNZEl8wDL9mnqdwaXSxv3EbzjWppbI5JuQjko=;
        b=c5FoGLike9b9NYuSNwRK12DvsvuM1V0l5UjvwaPJAGgjgq7XwPUS4U8s76IusmbOlN
         G8HcRyNUy5hq/4MH12nh/VgcVwB9FbBTutRoz+bXrArTWXxu7V+MIVt+Qkod5fYcH2T5
         6Ytf61rYbEM//eY12J4uyyzcyS16vNV6H9JGC0/ERj4ntizCzDnKOsc/Pkt3k/rX3KWA
         3+hEpV731Ram6fezy1T2ZVm38ksvlFQlfftqDhpWL9nbk9fGy3l9Bsu0quZaPSPZ6zOX
         nPtjrUNn1qwUVOVaQeeGceFJyfYHwYAjmyNUAwcTs5VwMFNWpxC7OCFJXnw37XUIzUdN
         dGfA==
X-Forwarded-Encrypted: i=1; AJvYcCWb1ISaxkyx3WIx7jQpxK23svcgQuXgqPc3XhRF8tLyMyzZlyxg4VJls3p/CKm02ZPGBUZLgJmOpXNK6Ap9Q2c=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywqi5bY4DPK84TzrQToXY+hgI+vQ/MlolVhpFkWxwP/wPq+1pfA
	vEzkvgGqQMcCvOWpdyY6YNcAzTqP1ZwW0SjWgF6Ri5zrgIwHgJWEPGisKmRbgxYwmdIFvTRHkrs
	5Hy+Lnjxdqx2MyOzoM8MKdV9iDi+6+2GQtiDO
X-Google-Smtp-Source: AGHT+IEr2kqryj3CHwPojAnrjT77oI+p2eagCFy4Mf/8qI/k5/pCuHJHt5YAM3upHDoOFWeA2megF3ZaleOAMRi88yA=
X-Received: by 2002:a05:6602:3fc5:b0:83a:db84:41a8 with SMTP id
 ca18e2360f4ac-83b1c4b4febmr5159706739f.10.1730984151674; Thu, 07 Nov 2024
 04:55:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105100647.117346-1-chia-yu.chang@nokia-bell-labs.com> <20241105100647.117346-12-chia-yu.chang@nokia-bell-labs.com>
In-Reply-To: <20241105100647.117346-12-chia-yu.chang@nokia-bell-labs.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 7 Nov 2024 13:55:39 +0100
Message-ID: <CANn89i+yj5DGj=OF58Uez6m0xt1n-6bi=vnG7PX1frBPWm+eNw@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 11/13] tcp: allow ECN bits in TOS/traffic class
To: chia-yu.chang@nokia-bell-labs.com
Cc: netdev@vger.kernel.org, dsahern@gmail.com, davem@davemloft.net, 
	dsahern@kernel.org, pabeni@redhat.com, joel.granados@kernel.org, 
	kuba@kernel.org, andrew+netdev@lunn.ch, horms@kernel.org, pablo@netfilter.org, 
	kadlec@netfilter.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	ij@kernel.org, ncardwell@google.com, koen.de_schepper@nokia-bell-labs.com, 
	g.white@cablelabs.com, ingemar.s.johansson@ericsson.com, 
	mirja.kuehlewind@ericsson.com, cheshire@apple.com, rs.ietf@gmx.at, 
	Jason_Livingood@comcast.com, vidhi_goel@apple.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 5, 2024 at 11:07=E2=80=AFAM <chia-yu.chang@nokia-bell-labs.com>=
 wrote:
>
> From: Ilpo J=C3=A4rvinen <ij@kernel.org>
>
> AccECN connection's last ACK cannot retain ECT(1) as the bits
> are always cleared causing the packet to switch into another
> service queue.
>
> This effectively adds a finer-grained filtering for ECN bits
> so that acceptable TW ACKs can retain the bits.

Too cryptic changelog.

Please add more explanations, because I could not really understand
the intent of this patch.
