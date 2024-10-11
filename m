Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1002F2194BE
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Oct 2024 13:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728652338; cv=none; b=WW1+VaxGjGf10eyihTDbukzDqNgkCoFx/5cV7xw7kkmCiUhMhvszd9WZKaptiJREne+iZaSZLVhbw5ZXFHTSoIbohmJRdnTl1Iz8EtvbiTNGf8EVATWOcy2ep4pRZutVuhfMvfyUcHDEAKUxZQv90lD57EhkquSrXlHp43Gu3Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728652338; c=relaxed/simple;
	bh=G8qGUaGJGZv/c5eUN39o5VdKnPXF7QYCJgzm+5GU8XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MQDy/S8tF1DotPm7c79r9SfSDPcBYYtsjaMMJwuUUkgX+HgxvFkNglWjTCOsi+rBTm5oA1jyKRCKveyoVpBjB6XRYP8kGwVL9cvfgb7PXJC9THrZ9RwvlSO242eCs13jYrZ91HS4Lq1NOTYocRR6dXH2kb1OQCtm9pw9ofedRik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at; spf=pass smtp.mailfrom=sigma-star.at; dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b=j5uzEnLP; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b="j5uzEnLP"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-37cea34cb57so1248069f8f.0
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Oct 2024 06:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sigma-star.at; s=google; t=1728652334; x=1729257134; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rv8NzxNpQPLVEaMv8BkCOMn4dFl6HxQWItjo4gHc8S8=;
        b=j5uzEnLP+NxO2FN1pLSct/PEYg5aXOD/Gidh0A/4nXmKSTmw2lKNacxBVX5kfr+7T0
         aATR7c6z4RokLw9hCkPbT9zK74oaHkrAWRcievEiwPe5T83zQUUN8YvhAZSSRXwzGTDp
         d3b0CBDYix9YtwGJ+/uH5icbPwY04DVW5yMtrvGigdzf9GNHJIJxmPzJcUblhXzE4700
         U5i6s6JK/qp5+RO/a+CYPQsiB3sxc+Vx0043Ex3WArF8EOXeduN3/YpMZJ2ci90nxedy
         R/Gd0gH4doOQ48Yux0QWNDiC2NFJ4rTHtFcWpW6C0AXDKnxnNasmh8b6e0bfhXkuaH5z
         xnQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728652334; x=1729257134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rv8NzxNpQPLVEaMv8BkCOMn4dFl6HxQWItjo4gHc8S8=;
        b=K+ZwBE7PoG4GAC693w75PKEulmOxJ8au7s8haMHfRr/W0mVIaCFLt+oLEeOgU9J/ir
         InUTPfe3c+IQGBwS80h1co3upyfJsDn1LZ8RdufoevjKuXsnB1l+GXPgbZe6aON0ErSH
         3r0m0h6q27KCwIElnY4BXTlOLJpocTOFs78ABAQpHYP35cLn34UVl6lq7XkGJBoHGy6z
         0uJQq+FhmiQw8LO65fvCQ1rKhFa5Ng/EQuLanetFwxZJ7ELScswNOhTJvdFJIbiOFXNL
         tw9wHdIBPFx0nmSGgxVZJVfIscGVfDTaa+bAMgtUfkMbb8w3YOZuSsLXMv9mFQGLH4qc
         l8lg==
X-Forwarded-Encrypted: i=1; AJvYcCX7kqb6Z89Vocwo1UIC5Da5ArpZady9qpwLjbMED+Z2r6jZb3mzao2jXvLc4edOVNv1R6QxbYqcxUxBuZ/kGbg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3nQSUlujuD76Sv2DqWVbXZrK3VJG/qqtETSpXCB3dItBAy+H/
	ZJyv4NYvrHXzlSNfHE++1jRZryYHlqO/obZoR29t8c9nw1VAlSkuRQavkNtyFXo=
X-Google-Smtp-Source: AGHT+IFwPySkw7rAoJTYAStSldgDhY3jVOzIh7W2cIvSY2yJOw89fNE5yWdDJXb+a0dmn/DcMb9dKQ==
X-Received: by 2002:a5d:68c5:0:b0:37d:46a8:ad4e with SMTP id ffacd0b85a97d-37d551b9740mr1930481f8f.15.1728652333936;
        Fri, 11 Oct 2024 06:12:13 -0700 (PDT)
Received: from blindfold.localnet (84-115-238-31.cable.dynamic.surfer.at. [84.115.238.31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d4b7ee49bsm3909731f8f.100.2024.10.11.06.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2024 06:12:13 -0700 (PDT)
From: Richard Weinberger <richard@sigma-star.at>
To: Florian Westphal <fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>, Richard Weinberger <richard@nod.at>, upstream@sigma-star.at, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, pabeni@redhat.com, kuba@kernel.org, edumazet@google.com, davem@davemloft.net, kadlec@netfilter.org, pablo@netfilter.org, rgb@redhat.com, paul@paul-moore.com, upstream+net@sigma-star.at
Subject: Re: [PATCH] netfilter: Record uid and gid in xt_AUDIT
Date: Fri, 11 Oct 2024 15:12:12 +0200
Message-ID: <1884121.lUd5UmjTVT@somecomputer>
In-Reply-To: <20241011012713.GA27167@breakpoint.cc>
References: <20241009203218.26329-1-richard@nod.at> <5243306.KhUVIng19X@somecomputer> <20241011012713.GA27167@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Am Freitag, 11. Oktober 2024, 03:27:13 CEST schrieb Florian Westphal:
> Richard Weinberger <richard@sigma-star.at> wrote:
> > Maybe I have wrong expectations.
> > e.g. I expected that sock_net_uid() will return 1000 when
> > uid 1000 does something like: unshare -Umr followed by a veth connection
> > to the host (initial user/net namespace).
> > Shouldn't on the host side a forwarded skb have a ->dev that belongs uid
> > 1000's net namespace?
>=20
> You mean skb->sk?  dev doesn't make much sense in this context to me.
> Else, please clarify.

Well, this was a brain fart on my side.
I wondered about the sock_net_uid(net, NULL) case and wrongly assumed
that a skb I see in the outer namespace can have a skb->dev from another
namespace.
It would be awesome to have some information about
the originating net namespace.

Thanks,
//richard

=2D-=20
=E2=80=8B=E2=80=8B=E2=80=8B=E2=80=8B=E2=80=8Bsigma star gmbh | Eduard-Bodem=
=2DGasse 6, 6020 Innsbruck, AUT
UID/VAT Nr: ATU 66964118 | FN: 374287y


