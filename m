Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489E11311AC
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Oct 2024 06:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728541633; cv=none; b=Rn2BnPH+4Uj0jOcHXbiBYD2PUiaqX+MLlJY1K2FErGKboFAq3Ktal2srMDDwTtBc5Wo9VVruJDI4efay+6dupYE36kUPl33XKmE//TfgCQqkaKUjvj1s4lh416z27rxC/NOuiY3MHMS4XiZJ7XEwFEOyH2t7oDa0yOKJVXzkcAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728541633; c=relaxed/simple;
	bh=DJaQzZsVBQ4pNi7ZfXCLZjYApmeH7omoEawSV46OekY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b5WEa2XHL86J4VUB+V/QqVU9W5XpKV3N7S3C4tsmZGaSlQizWLx+1dUKymlNYA0tos5BnqpEc2be6x/+ljEt/bRD7QMi2jpzCRUyc1AMYpvCzuoff3Dpp4RLoOye8ZHHcHJNexxDmwhiWi6fmNBhQFIWtwOclk5wXEezecgGyrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at; spf=pass smtp.mailfrom=sigma-star.at; dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b=ZfsLnDF6; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b="ZfsLnDF6"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-431195c3538so779045e9.3
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Oct 2024 23:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sigma-star.at; s=google; t=1728541630; x=1729146430; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DJaQzZsVBQ4pNi7ZfXCLZjYApmeH7omoEawSV46OekY=;
        b=ZfsLnDF61UXFMl8AK0angBwqckqkAaMa0AzAYdffj+2vILcH6nWEv/bPvDDb1A9X0F
         upMTJfOnfrv0yZxRdoqMfVhOalvD+lqSxAXFEpYvjQgTJez6G4BY1TXWTpUx4JxH6jOp
         yHm+Y8o3YypBsqaZm2cbNrXY9tMHRvVDZTDC5WuP86GM05leNEKtY6BoG66dG6Oclv2a
         dCWlHy823tQ8+WnRHS97j+crSXZZbs9AWSDMGd8OJWjEKvz5jPS7UIViJ7xBzFyniM9e
         9jGqtE5A8hTV/mGMAoRIA8z0kthx+kUnmnROrJrrtSA4LJiDLgCAQkLuYPset/RaisLt
         co3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728541630; x=1729146430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DJaQzZsVBQ4pNi7ZfXCLZjYApmeH7omoEawSV46OekY=;
        b=RwWvWR1YOax1AS1ke0eFqqOfNeyKDqydSszcdauSeiBctKhdW3/44RowNUstGLcEAk
         jQE17GcYudCEemJZwlMn8weTc2iBLwXLSa/w6tCTbGIgf2G4YK73sfgYQ5RmbuQQtLpM
         6Aem3LxbwGMeu3/Ikyp8xDxY4oOl3QLI40JsHQ+mY5b6Mq/ULZfw7jKlb2ni7SUWjqNI
         tHXo7XlJCEQxBGIti0aT6F3Y5ub263pOClIWN4K7MHn46WMTjvngJarBEYnrfQC01OpS
         I/Qm+LGuLHUv9VcceqICvqBRBTCbrHSJlfXIEG9kbhfE9//zsF70w16RMa2jYp61p8Fs
         Z81Q==
X-Gm-Message-State: AOJu0YwSj39ZI6wV7lPx5lzzr1tCF2Or5+Xe+EIV44mXJC6M/0CeD6jW
	WF03AFzbLvtblKx52nwsE/ruJG3x4Sb00yncd9v4yvUqDGBxofFhEnXzgfMDk4Y=
X-Google-Smtp-Source: AGHT+IG8trf13n+jWHkfYQNs0jAXGzamsgifjFl/jzbdieZPwE+y/eV5VgK4wziB5cnE6mkuFWH/oA==
X-Received: by 2002:a05:600c:444c:b0:42f:310f:de9 with SMTP id 5b1f17b1804b1-430ccf43d90mr33030595e9.15.1728541629718;
        Wed, 09 Oct 2024 23:27:09 -0700 (PDT)
Received: from blindfold.localnet ([82.150.214.1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d4b79f896sm601043f8f.87.2024.10.09.23.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 23:27:09 -0700 (PDT)
From: Richard Weinberger <richard@sigma-star.at>
To: Richard Weinberger <richard@nod.at>, upstream@sigma-star.at
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, pabeni@redhat.com, kuba@kernel.org, edumazet@google.com, davem@davemloft.net, kadlec@netfilter.org, pablo@netfilter.org, rgb@redhat.com, paul@paul-moore.com, upstream+net@sigma-star.at, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: Record uid and gid in xt_AUDIT
Date: Thu, 10 Oct 2024 08:27:08 +0200
Message-ID: <3048359.FXINqZMJnI@somecomputer>
In-Reply-To: <20241009213345.GC3714@breakpoint.cc>
References: <20241009203218.26329-1-richard@nod.at> <20241009213345.GC3714@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Am Mittwoch, 9. Oktober 2024, 23:33:45 CEST schrieb Florian Westphal:
> There is no need to follow ->file backpointer anymore, see
> 6acc5c2910689fc6ee181bf63085c5efff6a42bd and
> 86741ec25462e4c8cdce6df2f41ead05568c7d5e,
> "net: core: Add a UID field to struct sock.".

Oh, neat!
=20
> I think we could streamline all the existing paths that fetch uid
> from sock->file to not do that and use sock_net_uid() instead as well.
=20
Also xt_owner?

Thanks,
//richard

=2D-=20
=E2=80=8B=E2=80=8B=E2=80=8B=E2=80=8B=E2=80=8Bsigma star gmbh | Eduard-Bodem=
=2DGasse 6, 6020 Innsbruck, AUT
UID/VAT Nr: ATU 66964118 | FN: 374287y


