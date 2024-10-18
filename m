Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A5E201022
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Oct 2024 10:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729247758; cv=none; b=hhdNXdMvcFurdkowZlWru4DmjX273JaJYTZsMaUGUm4fIpYAc2y118MCAAMwna+Insd0Sj6t74Kl+ubwRK4GpAFkSyY8vT46SpxkQsatvatSeLqne3+BxzoaPOtkgiLEfXCC4AkdphltFg1a6WC88RWGYbJv9zpConoYbHVePfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729247758; c=relaxed/simple;
	bh=MYW6dbPyv1LA2KO8BAnlhzC9LvUw5Q9ucfBBjD7XiEY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=jHGjUUiappqnZn91iZjd/c8VDYVgjGj80syJMR+mW4rWnpDny7k9hu+w55UyM/+KF39WRdtqaxvg2EznJ8zIwPTlNKyhmc7r2uXTtyzMJm+GiQbyV8F4dlZSpgNhe0fwacBxSwpW78iqVb0naZQJKDb3FBuVWZJPqAmJE5A1GFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YwLpEOAD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YwLpEOAD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729247755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HrTOHGvby1w1ZPMwlyiQRBjU/VK2YYsb8ixcq/NW7Fo=;
	b=YwLpEOADa1wTKcJ0kupaZOLeZjr6MaBKm70SeJMrbnYeP8darKY/rXlUWynWYm8D2/Ze/F
	YCEKdFq/+SMPkz2g1f8sMK1asFFftcVO9ODcMnApcpf3l2yn+DQtf9pZ6u0yJI/YDQmr+u
	ZhCnbwsaaOMrCW4IobU2mmnsGpi+U/I=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-PxVXT4oANcKw-sUhTxMuZQ-1; Fri, 18 Oct 2024 06:35:54 -0400
X-MC-Unique: PxVXT4oANcKw-sUhTxMuZQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-37d5a3afa84so961395f8f.3
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Oct 2024 03:35:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729247753; x=1729852553;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HrTOHGvby1w1ZPMwlyiQRBjU/VK2YYsb8ixcq/NW7Fo=;
        b=NBa9jwfEP3+N7FUFpWUAhUQDOxUUYoRiVbLe/7+RS3VSwSga2TQaTsUB7H/dp+ztUg
         db9r5x55v+p3zZBwoWa1e8VCEznWS/3R0dRlhaPuBNjzUbyVIXKzHe8E4T02iJDRJXbQ
         XnqGJ87K395XTru6xXmfhZMbWm3UpSAB/yXd9wt2B7fcbXRCjNMWCdMgrx+yFMNM0Hu9
         z+TxxJUvTGoqFxNiyuh0+kDWE33/uyhZgCe6kS0OO+dMEQj3NmutsOhQVcZjo5zY9jIM
         oHqCSVhORh5B0jhHpaCKbYXCZlqN4CHvRydpDQdMG9Ii3LuQqLOCRIL+WPuIRRk4AL2b
         cLig==
X-Forwarded-Encrypted: i=1; AJvYcCV3qcOhH2MF51EZddHmDTGAF7a3sPW7AtXSVFPTJMl0i5XWvw4CF/nxA/i3tpLTYEgreKxY58V4MGDiuTx9el0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwI6RKc1Cb7S5JE6oqUhpUhOba8mWhfDWIkR9QoDePvm2ssRrnk
	sgmCWeCg4gH4Lb4hIf+SNFcxRX6BmDXulcIGK4vbcuFHyRzxw9U8B0DFVxwuc2A0ZASEtlDiqad
	w/JMQO+TH++5SvjEyyNIAzOQmhmCeu83McRlR8IWvcNy0XRSbYt2FMPSILm5aVS7pyA==
X-Received: by 2002:a05:6000:c81:b0:37d:52fc:edf1 with SMTP id ffacd0b85a97d-37eab6ec059mr1250830f8f.58.1729247752867;
        Fri, 18 Oct 2024 03:35:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFugxrw1zdOmWyzIUEN18vLVXOK89+UGpHiLlPe5ww0HM+JYH2Pkhn6/X2q66XMH9V2lOuQLQ==
X-Received: by 2002:a05:6000:c81:b0:37d:52fc:edf1 with SMTP id ffacd0b85a97d-37eab6ec059mr1250799f8f.58.1729247752374;
        Fri, 18 Oct 2024 03:35:52 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37ecf06922dsm1569144f8f.40.2024.10.18.03.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2024 03:35:51 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id 97D28160ACB6; Fri, 18 Oct 2024 12:35:50 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To: Simon Horman <horms@kernel.org>, Pablo Neira Ayuso
 <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Nathan Chancellor <nathan@kernel.org>, Nick
 Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>,
 Justin Stitt <justinstitt@google.com>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
 llvm@lists.linux.dev
Subject: Re: [PATCH nf-next] netfilter: bpf: Pass string literal as format
 argument of request_module()
In-Reply-To: <20241018-nf-mod-fmt-v1-1-b5a275d6861c@kernel.org>
References: <20241018-nf-mod-fmt-v1-1-b5a275d6861c@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Fri, 18 Oct 2024 12:35:50 +0200
Message-ID: <87ttd9y9yx.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Simon Horman <horms@kernel.org> writes:

> Both gcc-14 and clang-18 report that passing a non-string literal as the
> format argument of request_module() is potentially insecure.
>
> E.g. clang-18 says:
>
> .../nf_bpf_link.c:46:24: warning: format string is not a string literal (=
potentially insecure) [-Wformat-security]
>    46 |                 err =3D request_module(mod);
>       |                                      ^~~
> .../kmod.h:25:55: note: expanded from macro 'request_module'
>    25 | #define request_module(mod...) __request_module(true, mod)
>       |                                                       ^~~
> .../nf_bpf_link.c:46:24: note: treat the string as an argument to avoid t=
his
>    46 |                 err =3D request_module(mod);
>       |                                      ^
>       |                                      "%s",
> .../kmod.h:25:55: note: expanded from macro 'request_module'
>    25 | #define request_module(mod...) __request_module(true, mod)
>       |                                                       ^
>
> It is always the case where the contents of mod is safe to pass as the
> format argument. That is, in my understanding, it never contains any
> format escape sequences.
>
> But, it seems better to be safe than sorry. And, as a bonus, compiler
> output becomes less verbose by addressing this issue as suggested by
> clang-18.
>
> No functional change intended.
> Compile tested only.
>
> Signed-off-by: Simon Horman <horms@kernel.org>

Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

