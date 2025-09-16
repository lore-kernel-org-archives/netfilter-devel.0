Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928193016E6
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Sep 2025 16:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758041389; cv=none; b=FgdZBWtqzDSRl9n2lsLkutxrxVkc+PXCxL8DCOqhOl+TRM6aP+wrTmR+0HULnhVpAkLMJKeJyl+sAs8IearlbJf1jVLuWSJ9yL90tZgsBwFVPMenkACkxA2PwOkBs4M3KLIVOX62ZwYiDRcFi0H6fuahJDHqJDJoR4n4zPujiYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758041389; c=relaxed/simple;
	bh=TwcfabmK9WC+2NnCZx+uDvKHL+px3+cu4KrnzhiY1uY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 Cc:Content-Type; b=fkFCuSVH82NDe5KIGzHdHAZ9gzoFwkz1b6tEDjclToiF65241wZXGVpZ+7C4RZbfhtA821zRenKS9sGgvmSbhtb+6GdDo+SwdD3AGxt8kgNLcLraLxvgDO6MyYruGUG+5vTDyNKIHYyqHSN+6ez2cjd4we6Yjg/p+aYMT7GZzMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cTMvh5Bi; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cTMvh5Bi"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45f29e5e89bso35416235e9.2
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Sep 2025 09:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758041386; x=1758646186; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TwcfabmK9WC+2NnCZx+uDvKHL+px3+cu4KrnzhiY1uY=;
        b=cTMvh5BiZAQT7XxuqXQALlC0nPbDxLSNPWLLTD6SDCVaPRvLnG1dPSdFZkIaf80UTT
         FZ7dKG3/4W0ASBzyTsgRAxvJWGT+xJnMT4qllBWWu4xnhxHKQr+exMN8pqlMyzDhVThA
         C9mKynrDNjxMka4Xw4BITjSzRZCxh3YNIc6JKlh/3nzoLtnifA0nVZMhrr0tJL6MgXjx
         +PhO5nrvR4A787I7o0Jh+WVTZUQYbHNAQppxq3YdBKe/5MItN/GcosBy3awlf2+JIdph
         qjxJ5RDKwdCYcBHxO40afUcVR1tsdopQVgEBdy/Yui9JYqjWLD/oQlfnB2h37GsqfjgS
         m/dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758041386; x=1758646186;
        h=content-transfer-encoding:cc:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TwcfabmK9WC+2NnCZx+uDvKHL+px3+cu4KrnzhiY1uY=;
        b=gSbJgZMNlEs2CvqEWdZyPEuce5gKDKrVLuErxYVJlEtr5NWsmNBJ9H17CjaBhb5O9U
         pGiv+D8lRj9mt7Tt8ws122Jb7Z3Onk/Dse/4v1wRMjeyIyLHu0w09x4Sh2ysiOR7MRXM
         2Ane5RbWghft0rSIz/VW3AE2JAeCeE/86MT2VNKi8vA6qwuuw0w+A3lHE0iGnItUDkOw
         Ryhpg8KHpjHS80ubueBGCREnqEDAYK/FEYazjxR9dr2kmGGP07ZVEkpqwKpZ857u9XaT
         6w33svvrQ2fBd+MP/n/TAvFu5mxhcGFgwqYcBlxGAyNUx3aPTLZ2836C6BEV7Qzk7IDP
         VYYA==
X-Forwarded-Encrypted: i=1; AJvYcCX4OosUo1G+A5cgNLSgN3qHnePhW/IR78XDY1ppEUOj4xk0SdjD331eq0chh6vilatTZHcKX48CgsDSMisQEGM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0a7ccRCaKIvpxqEZ8sO1hw357WjZfJOtPj+S0dahgo9qqnszf
	EV61Kzj+qJMBfx10ruB+UbLeCXjjF6GTfKJOLbQA7tfiFs7rrZtTAQ0Mtegrt8IJ2mRsTIUmfJs
	Bw+oOv8+StOJru7q9ifnYWHAW015BaYM=
X-Gm-Gg: ASbGncvnY71R8IRstfS+Yt4LDmKyU4VvFA8SYQDjnOf9F9e1hPJADdFOg2XdVkh/ACc
	/bHZ/GoJKyWGy3MyZTPJG1qxHK6mOo5BVWAEWIFMzxf7APJvMm8AZ8wLuEoDND4YoIlwurAi1cR
	h23YbTQUjn+fsKCe50THXA2AOJkxMi3Dq5zCekEu+ue6vdhff+Jj2ugCyCyO7lQZ75IVYPOCutd
	awp3lvRFMRQr0+OsJQrcsmCjvgL5bBGp1+i6V2W4GBgfldrsa7xzHiy+O4S9ZJetrRSU3BEP54s
	CTgC5Ec=
X-Received: by 2002:a05:6000:144e:b0:3ec:25d2:2bdf with SMTP id
 ffacd0b85a97d-3ec25d22d48mt4512324f8f.27.1758041385551; Tue, 16 Sep 2025
 09:49:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250912163043.329233-1-eladwf@gmail.com>
In-Reply-To: <20250912163043.329233-1-eladwf@gmail.com>
From: Elad Yifee <eladwf@gmail.com>
Date: Tue, 16 Sep 2025 19:49:34 +0300
X-Gm-Features: AS18NWCrlr2QeaCB--5yANKThME9nJo6aat3FBzn5_cxJNe5mTnDqX1wNE37gpE
Message-ID: <CA+SN3sp6ZidPXhZnP0E4KQyt95pp_-M9h2MMwLozObp9JH-8LQ@mail.gmail.com>
Subject: Re: [PATCH net-next RFC] netfilter: flowtable: add CT metadata action
 for nft flowtables
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all,

One caveat: this change will cause some existing drivers to start
returning -EOPNOTSUPP, since they walk the action list and treat any
unknown action as fatal in their default switch. In other words, adding
CT metadata unconditionally would break offload in those drivers until
they are updated.

Follow-up patches will therefore be needed to make drivers either parse
or safely ignore FLOW_ACTION_CT_METADATA. Because this action is only
advisory, it should be harmless for drivers that don=E2=80=99t use it to si=
mply
accept and no-op it.

Just flagging this up front: the core patch by itself will break some
drivers, and additional work is required to make them tolerant of the
new metadata.

Thanks,
Elad
