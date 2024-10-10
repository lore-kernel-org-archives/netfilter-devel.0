Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D0519D889
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Oct 2024 19:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728587384; cv=none; b=X4w4QIeb9GITG4Pvad094fShmBLLZl1vRSaN6Sozg786u4hFNvDYj9kTng7whAYo7qxQP+uxTGDokWzu9xGt55rNWfD8XYH3bIsa3Dsi5x+cuN7z5EjAPiMANNtdefabW39e8+CTR76KmDXZ98VyiMiS98qSCU0wEb6S4k2wNiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728587384; c=relaxed/simple;
	bh=WhVzjUdfieeUJG/hOSUYYFWGBfznG38KtyoPvazgo3o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fsKyn4sVWRBdLmeDfDMtUYf/KvTXwgOggMKZXB7ASQdDaEvm2a6Lz7DKBtD/u3m6wx7u2Rej2TCjgrEnk7p6o0dIpo7PAsgzo4xrldlkW86jl92oE6louQ7/kWDlTKBJJ2VoI9d2x6OArcSzT9xiVPILcziWHnPXElt44FPALOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=D5qHcTGQ; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="D5qHcTGQ"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-6dbb24ee34dso11772627b3.2
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Oct 2024 12:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1728587382; x=1729192182; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CikrYA4VnkuX9j2GWpHauE4P5KWQT6s9FPEdiS8GSrI=;
        b=D5qHcTGQoBVELI9n5uaFfwrSDv5WZjTbwv8mLKRsKiGIsr/uQh/WUuKIQ1McaYzTZJ
         DXQ+TuFPDKdcWJk0HKCoHg6o+AFfLvjjCdGqRLNyuVrt2cxM45O0XMU9uybI6BxVIHOl
         FZxFomLD9twd2gfhch4r1J4nabyZOWbFBnqN29r0lZ6W3mkE8CIB3EbPFsStpLRs1kSa
         DpUkF96txIe8DYmqZS1lcDX2duuaFZn4/ASa1NmbzBM2zWussaMHsdD3cEVDDZfUBi5+
         WP8YLxhCaKdL3H1SkKd51d7nXEXrO0p9Ef7qhXFgqQTtNr0NCoRIjbjPPPIw1gQqnbol
         7kaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728587382; x=1729192182;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CikrYA4VnkuX9j2GWpHauE4P5KWQT6s9FPEdiS8GSrI=;
        b=XDhLuG54GC9e6+kIfXwZbO0hg7NKKb0kP1Fl7RZ0A1NcXfYZo+TGtMgLZI+SSJnnTz
         n9Ug2+zPf4f2MQCU/c3UyVkFX9eiwfcYZK0fNg5BiN9xJ+EOembjjKPbfcWBxN8+lyG1
         mi6NtyL7EfhhtINv39bsDyeCHFZVnC43LBJso1TJqrh0FDlmzpxZsuH11pcYcHQG3xAz
         9Mnq0W5ZqdHhog/Msrew52R/pccLS7QfPBga1TO1jJ3Phhq9suSbiohjN3KD5xN4vT4y
         vbD/dHey0yTJH12+ybBK27ZvSNTipaSiB5qbx0E8D5e+cGFQDFS2Zz6lUwgpxZLJ+GqN
         TsQg==
X-Forwarded-Encrypted: i=1; AJvYcCXxD8UoQZaRM6cGXBdUc4jawuF2Uah4qRUeOgFiu/RY3TZJTcNgwhHZfIag0IlKu/5ouZBlYc8rkA58C8AQM+U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6w2qyW5mPSOPv/dHzhRXktoGw33Jnw57vjUq0eu9mExyM1haq
	qx1c9xQwyest9/InfJxsfEgQhspimfNAhn/OO6uz5Cjs3gFAAWgP9PapAHB6GO9VWIX9oFjdoNi
	nFFf5JNARGroVCseDPFOXjjSXM8JlZYKUujLc
X-Google-Smtp-Source: AGHT+IFoDnIBQx3nd4BDAUPqV49GV7R9G6VM2UACY+9eMmhbM1oMiRtHmI2qWdFhcd2ns10uTkcEpuSvIg7Fd/Wg2bs=
X-Received: by 2002:a05:690c:386:b0:6e3:220e:90dd with SMTP id
 00721157ae682-6e32e435ae0mr50164777b3.35.1728587382162; Thu, 10 Oct 2024
 12:09:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241009203218.26329-1-richard@nod.at> <CAHC9VhSbAM3iWxhO+rgJ0d0qOtrSouw0McrjstuP5xQw3=A35Q@mail.gmail.com>
 <4370155.VQJxnDRnGh@somecomputer>
In-Reply-To: <4370155.VQJxnDRnGh@somecomputer>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 10 Oct 2024 15:09:31 -0400
Message-ID: <CAHC9VhRDZVJbhCbVkfs8NC=vAx-QdQwX_jMq51xzoTxFuxSXLg@mail.gmail.com>
Subject: Re: [PATCH] netfilter: Record uid and gid in xt_AUDIT
To: Richard Weinberger <richard@sigma-star.at>
Cc: Richard Weinberger <richard@nod.at>, upstream@sigma-star.at, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	pabeni@redhat.com, kuba@kernel.org, edumazet@google.com, davem@davemloft.net, 
	kadlec@netfilter.org, pablo@netfilter.org, rgb@redhat.com, 
	upstream+net@sigma-star.at, audit@vger.kernel.org, 
	linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 10, 2024 at 2:24=E2=80=AFAM Richard Weinberger
<richard@sigma-star.at> wrote:
> Am Donnerstag, 10. Oktober 2024, 00:02:44 CEST schrieb Paul Moore:
> > [CC'ing the audit and LSM lists for obvious reasons]
> >
> > If we're logging the subjective credentials of the skb's associated
> > socket, we really should also log the socket's LSM secctx similar to
> > what we do with audit_log_task() and audit_log_task_context().
> > Unfortunately, I don't believe we currently have a LSM interface that
> > return the secctx from a sock/socket, although we do have
> > security_inode_getsecctx() which *should* yield the same result using
> > SOCK_INODE(sk->sk_socket).
>
> Hm, I thought about that but saw 2173c519d5e91 ("audit: normalize NETFILT=
ER_PKT").
> It removed usage of audit_log_secctx() and many other, IMHO, useful field=
s.

The main motivation for that patch was getting rid of the inconsistent
usage of fields in the NETFILTER_PKT record (as mentioned in the
commit description).  There's a lot of history around this, and why we
are stuck with this pretty awful IMO, but one of the audit rules is
that if a field appears in one instance of an audit record, it must
appear in all instances of an audit record (which is why it is
important and good that you used the "?" values for UID/GID when they
are not able to be logged).

However, as part of that commit we also dropped a number of fields
because it wasn't clear that anyone cared about them and if we were
going to (re)normalize the NETFILTER_PKT record we figured it would be
best to start small and re-add fields as needed to satisfy user
requirements.  I'm working under the assumption that if you've taken
the time to draft a patch and test it, you have a legitimate need :)

> What about skb->secctx?

Heh, if there is anything with more history than the swinging fields
in an audit record, it would be that :)  We don't currently have an
explicit LSM blob/secid/secctx in a skb and I wouldn't hold your
breath waiting for one; we do have a secmark, but that is something
entirely different.  We've invented some mechanisms to somewhat mimic
a LSM security label for packets, but that's complicated and not
something we would want to deal with in the NETFILTER_PKT record at
this point in time.

--=20
paul-moore.com
