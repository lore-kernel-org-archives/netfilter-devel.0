Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D793D1CBF
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Feb 2026 16:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770135597; cv=pass; b=VmE/HCSu4ulOZEyGox0BrPZiYw33XwnfkyxGV/EzN9GRmIZ6PTZ5L1d2RuwvjD+BvmPkmVOTOTM9A7Grsg8wPB4Uf+DtXmHEPDuGMeMxXDLWECDYHd/Qy15yieJFDoddtv+CKXwNDFopL2Av1+sLd8V/N2yh7tmRXsYTAE5bZ+M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770135597; c=relaxed/simple;
	bh=Tu4rSvNTKOOFw1ToUC6UiNxnVnQZ9GgdV42C9w5CPZA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VqYwy/3y1OFBhHu148L2qv1Dr/eVoO8vOlrqZ0ADYgKQRo56rddAaLz3bYpU1gRtw7EPGg6KPc2Cw9Xq7bWH/wdLb3h7sM/EF12H7tJE32gj9vQm93RwH6XUuJyin57l1BmiS6J8KOH9LxxSNKxvp8JXe5XVKCKYpDRjOY6VBic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BFYkuVt5; arc=pass smtp.client-ip=74.125.224.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BFYkuVt5"
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-649d4690174so895314d50.3
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Feb 2026 08:19:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770135593; cv=none;
        d=google.com; s=arc-20240605;
        b=TV5sA4lp2ty5M1p2ENP4exyTRESH/bJwDnZ8vKl/lgbEE6nwzZdheEIB/6quryHboQ
         msFxZ4/S+BVzFoBa6qDocfHGyF4H5XzxjV3jyKqNA3xMt9ezv5CbeKuqMMxw6D8T3w1q
         KhwoGD39xQFVn1iyFZyu+iSVasWPMpJ53kwIvTU1uc8uyf30D4FHmZIDFnTlOKxH8hBC
         hvijnioIhnw3xV2S7oCa1qJM1/XQpoLD6pni5B+IlnALY5uFvvoNkGLxmQtuoFQGN/ix
         Fv78uNXSIouCywZPJ0Xbdw62pIy2I1KMSBljaF6CvqIqu8DTmM9qU6UYSxMN7Ptn+0MH
         xz7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wGWKXutvMucFH05YrWha7pPDqCCm/nyM2LYOpcwTIG0=;
        fh=+lBLZF4cUSdVMzOTaNxT7h4+C/BaxHeTc8ccRSnt/zU=;
        b=fFwDNhSWT8sHhwU6Xobkevo9AdoOClWY2GboIxL9nf2TycfhI6Go0pyStdqiBjZ6gN
         fTZtLfTuZv1Wmto9rIsNMcr2gNnGtB7HRE+sTuvQBb3mz7GCeMCDY9IgQg9OR1qurHcq
         Q33A6UaRDGZPmnRKpvu/+VoIAAtG7+dFvR/MWp0hQpmErwzmUOIdmactA/iHe+7s4Dh6
         uGZ59yc9N6sSr+7eIY85WQpBbWjaFohOY5nPtEN+Z2uQPaL62dE6O1QtaXmwpArJuTxC
         qLFEQFlCoQvBtnEKIOU5vp+DJs1cwVF3ZEuQK8gTvdir8Ji0ZJACPL+rwjCMBjPTvIJ0
         Jd5w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770135593; x=1770740393; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wGWKXutvMucFH05YrWha7pPDqCCm/nyM2LYOpcwTIG0=;
        b=BFYkuVt5ZAdVXyu3DTkMUfBmRe3WuhPBcfYZhSAlHe0XDw1GAuaPo45rtnMsmpoJlQ
         rgIkmUwd8nWw7r29KnYhYIV8PX3ODYEy/AAMrkpphuoe2L0U0gIwt6P5tnjDZc89VEz7
         CuX/NQS5RoyNjhSjf2MQRazazxUj86fv8rBk5E5+mTMU0eJM/CjbGjFBq4Cx2vyfBXfF
         PsXrYJQqF2XjJ2Ojjc80Tgo3+aWP5lQ6NmIIcw5PixvAFtbJPPIXFEjtf8cDbfgYC0YD
         KgxT+abbNq2m93rfMuOCa7r3VesYLOFNdUK+KNdtmB300XkLhZxGamb2CDo5x6l6nIzC
         5nZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770135593; x=1770740393;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wGWKXutvMucFH05YrWha7pPDqCCm/nyM2LYOpcwTIG0=;
        b=OHEsShLD0pPihkVglDvVAiCSI6ucdF+KGBHbc+KuKqkDg7TLNlLuJ8Btv0v+Zyi46a
         FM9gx1s8vS2fzteFvBFLnKFeL/WNbpRxplf0XSKuytxwNWNazYF3LAcmiG2I26nszuwo
         cGFf6c4aRsfOa0OLJ33wdQAAztnY7JYTeD/h7VBjLqZgb3QZv57tIWwUuLVai/yLTCfU
         PS5623jOCY37JNa4y88CzksB1JKOdrLpkGR+7Or88V5eYQyQ/ilwIOoih1RCVFGdxVm6
         6QcCSY3xZySxxnAc8O1nBxFrV8MGZHDvw7P4nvA9C1YAbjbzAAhLanbyU9rfaaP94Ol4
         T5Hg==
X-Forwarded-Encrypted: i=1; AJvYcCXaylgJM7AOppSpZ0O5i9CfDhmJDJRZhFLMaJqWRkIIjzWmZuVN0/foBzSW+WCk4ApfQOybUUDKy5Bdz/50OUI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyR10R0ueLA5oePpTCzH/n3yqcCSaYn4SU0uTMrS4augSb6YCg6
	QnBdBH7p7lsnGh29/5yfgPauXwwgy4vqbRk7PNK1SFT6LBOqUBIImXY0wXAhc8/lpGOGFDxpzCU
	IuQ6SBssEDCncGXd9Jgw15mkkANUv9VE=
X-Gm-Gg: AZuq6aLUXOLuH85JsDY8fYcYJsfwsYT/GuxKH4mP/+p7wHpI3AZ1PdIfGxh+N/w3SwP
	QW6TayiWUqDBFGgjRxA4mkW/QDpB/2WvjB1mwNndZ9dwgBgwFcR5JLeqdpunBvZlXHYtlp8Uz47
	yxYI87R4zrPEs9qBdsht0G65AqNyZ8WFktC13rxxLWAB29PYzU3IgBiq6GTXVU/u4jTHH0E+BW6
	ec6iRCWQA5eeyJa2xiPr5mi45Z51zknms/Xnv4nYhK3j30PD9hmch7cE6P9wHrvYpmvQMPJuOpA
	0fQ1
X-Received: by 2002:a53:e038:0:b0:649:399c:d964 with SMTP id
 956f58d0204a3-649db4bd04emr32126d50.77.1770135593302; Tue, 03 Feb 2026
 08:19:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260203080109.2682183-1-sun.jian.kdev@gmail.com>
 <20260203145511.164485-1-sun.jian.kdev@gmail.com> <aYIOXk55_DRFKCqo@strlen.de>
In-Reply-To: <aYIOXk55_DRFKCqo@strlen.de>
From: sun jian <sun.jian.kdev@gmail.com>
Date: Wed, 4 Feb 2026 00:19:40 +0800
X-Gm-Features: AZwV_Qjfv0Y1awKscWXbDj4yy-HnV-BM8KoCg4M6DTECxWm-KSh8hCQxRruGgdg
Message-ID: <CABFUUZG9LnhXc+nsQA28WHiiT33_5wQ82E1bBSBncWkxkXaKZA@mail.gmail.com>
Subject: Re: [PATCH v2] netfilter: amanda: fix RCU pointer typing for nf_nat_amanda_hook
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>, Simon Horman <horms@kernel.org>, 
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 3, 2026 at 11:04=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Sun Jian <sun.jian.kdev@gmail.com> wrote:
> >  enum amanda_strings {
> > @@ -98,7 +98,12 @@ static int amanda_help(struct sk_buff *skb,
> >       u_int16_t len;
> >       __be16 port;
> >       int ret =3D NF_ACCEPT;
> > -     typeof(nf_nat_amanda_hook) nf_nat_amanda;
> > +     unsigned int (*nf_nat_amanda)(struct sk_buff *skb,
> > +                                   enum ip_conntrack_info ctinfo,
> > +                                   unsigned int protoff,
> > +                                   unsigned int matchoff,
> > +                                   unsigned int matchlen,
> > +                                   struct nf_conntrack_expect *exp);
>
> Why is that needed?
Correct. Manual declaration is indeed verbose.

The reason I used it was that typeof(nf_nat_amanda_hook) carries over
the __rcu attribute to the local variable, which triggers a Sparse
warning when assigning the result of rcu_dereference().

I will switch to typeof(*nf_nat_amanda_hook) *nf_nat_amanda in V3.
Thanks for the guidance!

Regards,

Sun
