Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3C4193070
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Oct 2024 06:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728541474; cv=none; b=eiZqkCQZe9qTgx80Gth0JEsZbj//mXS9dFBv2uzKsn99OeizTNuXIlpkzlY1LFHpxuBbcU0ciG8fzuZmwHAsqjc+CRTKYShXFnyeyq+UHDqO0jF9WfyObm3oCr8UXp5T9fFR+DIQ6D2oYgCsdZDhJl/H1t9mGlVdC92tNS/ubRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728541474; c=relaxed/simple;
	bh=06v5ByD0afjFJR2Gk//6r4sYzvL051t2rbG6jI+cafg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=edZtXBloFsY9Ashd2i4TELCiuvoNCMQ7luY0EGq2uATXC6EyJwOA6435YB5c6jtSKoHZyU9xCagAM2hZ+tHQ/W4hXH9K1+AB3ToFu8MtmsBHcMcBDW4wQTYJafrD2d7skPYJzHtd2cK24XcHJ6QxqNRSSLD3/iWfHlCrUDSDdu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at; spf=pass smtp.mailfrom=sigma-star.at; dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b=B3Kpe3aD; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b="B3Kpe3aD"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-37d47eff9acso235569f8f.3
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Oct 2024 23:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sigma-star.at; s=google; t=1728541470; x=1729146270; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=06v5ByD0afjFJR2Gk//6r4sYzvL051t2rbG6jI+cafg=;
        b=B3Kpe3aDsmbhLLtHzo8VK9ZpJpX9MSQFynq5TpP5EuIR49OtIOPRJ/nGrPm95ikCCp
         RR89gCfBX4c307B0Zsgj+IEXmtHG5nJKycwd1i/7EZI26k0sC706MGx1O39DnkL9Ujbc
         k5kVkTnP1BTZIIwHEA/gnrp57IQVqb3cQc83JAdlllqaJuqW4Wu5Qkjk8E8SzljDurFw
         4MzvtfPm3oeoWZjHlGEXyPCCxyRl+XyVHEhd72zkV+zoU6cBrMcP4pN6EAd29IAhfP7E
         qSRMDbauUOLspb7O5yxGfMcYHsadvZYMkHlPF9zx5SgEtGknn/RrPGwdXjrVff94er9y
         uPkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728541470; x=1729146270;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=06v5ByD0afjFJR2Gk//6r4sYzvL051t2rbG6jI+cafg=;
        b=jE0rjjAFmeBisC5TJC5TGzU6iVQPdqQNg3Ln/S6M3Xnn7+xbNf/P06phlhbogUHGnq
         24TfM4Zw9fmqIu/GY9ZxIPY1192my5/LavGu31b0MdiRmHI00FZwtJH8w3kOpU0JSGJ1
         uuPC43PMjfUBIRWoNHySCu8QYARbJxnAcuqLCH/sOlc5RQ62A6zwXkWk49RqU9B0AmFU
         /uwbv85ICa9TDaN6/yM0AUmtGiBCEgqMZHEa8i1Jzsq9N8Gc/FPlkmVHLcmc5HyXEx1k
         uiMGBsZNjZsrDerzXeh9/FSjjzHVFM9+T2Dwjyy1js0vTrlycQU44rUe5uiLvKceYpRr
         SPSw==
X-Gm-Message-State: AOJu0Yw9TzBpFRIi4fLIawAj4vLUoci/jOOmhgy0rjW7oy2h89juFG1E
	5bEegmKX/l+0JKW0br2bYgZQWZ2+C+D9FuO2M+airblIBKPkBfkWItjwDDpQYpg=
X-Google-Smtp-Source: AGHT+IFb4UsVqlsnmRzalMlOFhL03MP9RKPAZIFBzAhHFTnSb9JuNURPjg2Y03goJMWBnZPtgCszsA==
X-Received: by 2002:a5d:5606:0:b0:37d:4937:c9eb with SMTP id ffacd0b85a97d-37d4937cbd4mr887313f8f.21.1728541470555;
        Wed, 09 Oct 2024 23:24:30 -0700 (PDT)
Received: from blindfold.localnet ([82.150.214.1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d4b6bd127sm605077f8f.36.2024.10.09.23.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 23:24:30 -0700 (PDT)
From: Richard Weinberger <richard@sigma-star.at>
To: Richard Weinberger <richard@nod.at>, upstream@sigma-star.at
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, pabeni@redhat.com, kuba@kernel.org, edumazet@google.com, davem@davemloft.net, kadlec@netfilter.org, pablo@netfilter.org, rgb@redhat.com, upstream+net@sigma-star.at, audit@vger.kernel.org, linux-security-module@vger.kernel.org, Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH] netfilter: Record uid and gid in xt_AUDIT
Date: Thu, 10 Oct 2024 08:24:28 +0200
Message-ID: <4370155.VQJxnDRnGh@somecomputer>
In-Reply-To: <CAHC9VhSbAM3iWxhO+rgJ0d0qOtrSouw0McrjstuP5xQw3=A35Q@mail.gmail.com>
References: <20241009203218.26329-1-richard@nod.at> <CAHC9VhSbAM3iWxhO+rgJ0d0qOtrSouw0McrjstuP5xQw3=A35Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Am Donnerstag, 10. Oktober 2024, 00:02:44 CEST schrieb Paul Moore:
> [CC'ing the audit and LSM lists for obvious reasons]
>=20
> If we're logging the subjective credentials of the skb's associated
> socket, we really should also log the socket's LSM secctx similar to
> what we do with audit_log_task() and audit_log_task_context().
> Unfortunately, I don't believe we currently have a LSM interface that
> return the secctx from a sock/socket, although we do have
> security_inode_getsecctx() which *should* yield the same result using
> SOCK_INODE(sk->sk_socket).

Hm, I thought about that but saw 2173c519d5e91 ("audit: normalize NETFILTER=
_PKT").
It removed usage of audit_log_secctx() and many other, IMHO, useful fields.
What about skb->secctx?

>=20
> I should also mention that I'm currently reviewing a patchset which is
> going to add proper support for multiple LSMs in audit which will
> likely impact this work.
>=20
> https://lore.kernel.org/linux-security-module/20241009173222.12219-1-case=
y@schaufler-ca.com/

Ok!

Thanks,
//richard
=20
=2D-=20
=E2=80=8B=E2=80=8B=E2=80=8B=E2=80=8B=E2=80=8Bsigma star gmbh | Eduard-Bodem=
=2DGasse 6, 6020 Innsbruck, AUT
UID/VAT Nr: ATU 66964118 | FN: 374287y


