Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9A51F94C
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Jun 2024 15:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719416771; cv=none; b=Q24C7VWDXL95dzVacihZuDfbNzvWOKwpgn4hOKs2CyhJ7h2bVvhb+MQvhRrg5wzYKhSA3IscAbeM1xn1WaWdjyLMcsRo9fllJ+3wOq0koZ/2MRBwLxHlVHntkwVNgy3oNxjXBtcXcN5UfN+g0n2HWGlORBKJKTzOUr8RYYL00XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719416771; c=relaxed/simple;
	bh=W8s5ayzAyuH/szDA1u43YJtL5OXeq+2ubyKr9QNmmfM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NwlyoESaEuOqj/byF0UUL5vjLSZsqE/inOvE+dnPELRJJ2hTpX9OQNB8wb8qOFYrsoK/+GljZYF9Lv7PX6XH7o53JQ/omdwqUE8A170PPg4Xv7eqzsbJyCl3vxAVjEIwiSgYWabM4UO2l1cxgW2j743th3dmv2PN711iBhmvpqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=Ui6JTBI8; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="Ui6JTBI8"
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e02a6d4bdbeso6204479276.2
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jun 2024 08:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1719416768; x=1720021568; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=de8nsQ6gIpK/UpjAExdD+MjaNj2aRza2UFTo1DVQCXw=;
        b=Ui6JTBI8fA6IzVP5TMk8QJvp0hdu/WFvhnTiepVeBswrlYeqjL1/5s2KWhmnN5hhYe
         5XpwznbkbwWgM6w4pMeeXIM8XDAbkwkOr5rS+Atqd2BasAX9ZhWAx9CvooZUL/R12a+D
         REN1XssJOsrnpUEsFw+p/yOxSMoFbH0iamUlsdLgSf0OeikNRu7ocjwr0u+RDkyyALY9
         1aTbsuWadoLSkrd+UMhSw/WaAnxRPHxvvsBV+C8+a+4znCLsmmtFwFqk2jK0/HFqo551
         p7dZOGJI4xHBczDfiWVzP0PQ4eh0NnPooUyJPcuFvyvSJ8dSgvOF7jSU+vqAOziLUVEv
         tiqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719416768; x=1720021568;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=de8nsQ6gIpK/UpjAExdD+MjaNj2aRza2UFTo1DVQCXw=;
        b=EUCUpWV9SFit96oGQnZsBBPOOceWKxwteGaK5gSVsTL7yHruw80V5l67MKwrNIwhfT
         /ZYALfazywnZ+yF/y1se0ySCXHUtzfwCb3Mts475u6O1djB00R5Q3yJmErldo4nAY+Q4
         uG49iabf3gfQ2Y7P0612uTr0nGiNsPE9+9GVl2PDy12WZGTr0UHimF21mm2jbUK1ciWg
         QdVnoRr1RL1ewsHCzffpboDuYuFMu8Za//RwIZ8oicfNtReF1jDfFIqCmpO0MNxJsePv
         0b5HJ5lGPvFRurcIQ6rMoL0rw+2DB6yDOE49K3taDm4+BUoNk6UTYdKRo3v5+VRWGQ1N
         zUFA==
X-Gm-Message-State: AOJu0Yy4jgCwCGz3ZYlu+a/ZxTRYP0tYysZYdS8kLAFOrFHJ1QLfws7n
	u0egfT08KX8vWQo9M6923qyX8rhY+8fvQeed2N048WOVbZSj+1n02nmUG/8GZCzLwIFHu/REUHu
	EmMdR5XeF7zjxNcXbIOKPCYRsbYMQnXvXb7NZ
X-Google-Smtp-Source: AGHT+IEXxQ98p8k0meicIhcPd2oQQi1NDXfuezxKSMCSIvmwFO2St+fjiMm7EN3pIab3qktzqjwZcKnwfhG189NUcrk=
X-Received: by 2002:a25:d342:0:b0:dfb:441:e03a with SMTP id
 3f1490d57ef6-e02fc2c645dmr12605372276.34.1719416768066; Wed, 26 Jun 2024
 08:46:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240603181659.5998-1-pablo@netfilter.org> <Znv8HMKbgSCwdPp-@calendula>
In-Reply-To: <Znv8HMKbgSCwdPp-@calendula>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 26 Jun 2024 11:45:57 -0400
Message-ID: <CAHC9VhShZ8jiw-+HToo60d-pwPvRkeWHYtJdfJYgkMU6GHgJZg@mail.gmail.com>
Subject: Re: [PATCH nf-next] netfilter: nf_tables: rise cap on SELinux secmark context
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, rgb@redhat.com, Joe Nall <joe@nall.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2024 at 7:31=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>
> Enqueued to nf-next to address:
>
> https://bugzilla.netfilter.org/show_bug.cgi?id=3D1749

Thanks Pablo!

> On Mon, Jun 03, 2024 at 08:16:59PM +0200, Pablo Neira Ayuso wrote:
> > secmark context is artificially limited 256 bytes, rise it to 4Kbytes.
> >
> > Fixes: fb961945457f ("netfilter: nf_tables: add SECMARK support")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  include/uapi/linux/netfilter/nf_tables.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/li=
nux/netfilter/nf_tables.h
> > index aa4094ca2444..639894ed1b97 100644
> > --- a/include/uapi/linux/netfilter/nf_tables.h
> > +++ b/include/uapi/linux/netfilter/nf_tables.h
> > @@ -1376,7 +1376,7 @@ enum nft_secmark_attributes {
> >  #define NFTA_SECMARK_MAX     (__NFTA_SECMARK_MAX - 1)
> >
> >  /* Max security context length */
> > -#define NFT_SECMARK_CTX_MAXLEN               256
> > +#define NFT_SECMARK_CTX_MAXLEN               4096
> >
> >  /**
> >   * enum nft_reject_types - nf_tables reject expression reject types
> > --
> > 2.30.2

--=20
paul-moore.com
