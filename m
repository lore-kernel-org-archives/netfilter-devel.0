Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824591DC985
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Feb 2026 14:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770129399; cv=pass; b=gIMSisN3zokybSzQr+1tdNPYI0+7YyO+/LK5y8ER5+SAGhg3QEhWWRrqz5rSiKb6C5/0Wj5qQ2yWg7CKrfXLqQseU8dvuLp7jvM9ltzrTrD6SRe73m2DU7FVJ28KL2StubYvP477gXaRPHdXo5n0nJSWgHcPn5vKDeWDmNSWx84=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770129399; c=relaxed/simple;
	bh=odADWoVpnh46kioRwm0TBjdpIHbkpoy15QMEVhLMOw0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NuWoXqgjSlHtOurcWY4FSpTQV2NYMbEWJV9JvcIB2g7ryyuuaPgxzp6zvW0iY+YUPdjLqABMONS4xBQ0zu+KUZr3vcomm11iSttmT9mxhnjUjizLzMEkcJkaGl2uN8+fCu7C95nvEjzYHHMxo9m1eKIy+VZ/Ik24HGHAyPJDLFA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cmp/FL4Y; arc=pass smtp.client-ip=74.125.224.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cmp/FL4Y"
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-649605d3664so6364676d50.3
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Feb 2026 06:36:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770129397; cv=none;
        d=google.com; s=arc-20240605;
        b=KQkvSRx62sTswAKS/W6E2LFG7t3mk4rveI/ACMcCF5FPCX/Sa7I9ktG68lovxvxow5
         giVblZJOiaRSgAtjQsTeShC0FQyA21LdBm4E1r3IuF3Ciug/IrJ8cjVwl6gd7kTxLqfZ
         yMocol0h2c34B69qXquoSY9IBKRSRNTQuD1tZDa6Pys5cpHHlalKL/0KVD8fsRvY88Jx
         M22OmpTuDyWlpm6qyNVCfzW9xdtHqlxQkS6CoDRY0ChLpFzc9XQ7g20BISlOUVny+J3G
         BQmx3LDNwQa5eL6JYIRtJwSeCkQZkEgzVpRjFOsynQmrV+q/I56yJGXjg7QzULBOnT2y
         3iFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pBcbxMUtF8xNaMRTkP3Y2ohb5ZiU9Nml+ZgLyhJTzwU=;
        fh=VaO8LpgFr7kztSSBFJHye4ysG2IchiR4mr5y/tmXzdA=;
        b=IYqk1G/Oe0EEVtQUuZLWhFIfHdrCkDvCcPqqxkUYL7BiZr4EqOSwfT0hst1vJ8S4MI
         rd5FrZ+nKDQYwxa8K5RSNZW2m097s+MkRnIj2dKpuE5q5m0hLTwkPplTr692RNIn5j2V
         VD70g6OYRGHZuwJaXd/t20DhYQcaqvBjxlVxcCPj722vnln5UH0OTupRy+9b6IHsy6O4
         7zvH2wruQ5i7SP9uzuw55k+J3mMPZOs7z76RorsVwQ9q+S/hAr2WKk74sFoBBvaS9+HR
         srQkIMUUviPZm+KStm46ZRmKq4KExFdBCSMmnAZZJYn+gI479Pr7m5yuaFwI8XYsL9qZ
         Z1BQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770129397; x=1770734197; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pBcbxMUtF8xNaMRTkP3Y2ohb5ZiU9Nml+ZgLyhJTzwU=;
        b=Cmp/FL4YFtBZN07PeAUHkxVnGGG1q0XZVAmX8rpzYTtqYbjoDqm2RQZmmwsO6GOkHi
         vrdmILcl+1ZHN+X3Km2mis4XOcUSFWYItmLy0Q2d2qE3Z6xZ7RLKzZUjt9Gei1kOA/he
         zmh4igqkr9gqC7NVnm8ylL0FnK49YFJESW4hgZBSE/ZDlcjpIsY4aGDZKdhirRZAo4oG
         rj2FcV+CjPgCkSpev9D9h/4imXw1C/twUu5Nk2yaIIM88GIw4TYmIGAIS82b6im8eMhj
         eTAloBLMeCWf4eIiLEoBrxAvmfcDsecgsy4a0WsLkwSnp4MStcPS7jhYz0yZEnO0bULr
         nsmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770129397; x=1770734197;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pBcbxMUtF8xNaMRTkP3Y2ohb5ZiU9Nml+ZgLyhJTzwU=;
        b=QV+oyKtLUODoNzI9MbB7JsGs8Q2F1rXnu/nmATeC3DZLcvwGuFFejzc5e6YlaSNYgP
         lsAbQgQpcQ9fySqJbRAdFp9lby7Y3Ijgj/gE16XRBrNsVYt8qPuABf/uP8Lqx7CDQl5Y
         eFSLXASTZzn7lpo3nEHT7tqRHtAJfrxKSUTXehRNqJi7FS/Je1SU0sqbp/mmIW8M/0QB
         xFuNWTcSSHpyPBRh82juuZP9uCvjWCdyG/dsyXaL6ZyOmWjVZMobGga+HoUPe8JJW6K/
         4WN8YeDyYr70x+v0V1VBE2/MnsKk3UdlCwQwIN6/6dSJn+RNRIJ8j2v9RYCcijaAi6YR
         G64A==
X-Forwarded-Encrypted: i=1; AJvYcCW6QA6yBzcTCI5nU5QJMze+rHN+NIInl4zPnm0Z4yWW19grrrlbS03h2dTHe4+bfBg/0wfBGWyL+m+jRazKw3A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsmoQjAmfRmLkJ0q/SHmWT/S2Gy0h8TOjGCrvJyQY+RtuagWi7
	qHqMq3EICgi2AdC7GyEdkMbOz04SOoTLpVCi/xQOKOIE8vSdW9YGD3990DRQXhLO6AWV251Gsp3
	5zoVUkwSyHAuz/G5IYIaXJhmrvi/lHLWoi0LeFZM=
X-Gm-Gg: AZuq6aI84mx2QWlBfHM0RIkJ480u3Pw8qFczsBTBL/QQacuGEsPplyo7Cb1jaHqw1sr
	Wmjqe3ZgggejR7Xhm3v3MFFB0uTd5fnWJDraYoni9bOmF4i/mYJt2rLGjn2l2iVE1WgVFQ1JQyY
	Z2tORzj9PkF5sRc5bvEmDcna4Kn6jPOB+gyYoqaU1W5zQMwpBKZiyuIuZCBmclErWRj1DXOSaqu
	tTLIi3kfxUBPQBoGFPh5Nt/XVmK/muRWhyJreRQ9rU8yjeHB6OtRh5qm8gvYqmXvV0AqycOgeVo
	94Af8g==
X-Received: by 2002:a05:690e:408e:b0:644:71f7:a9ee with SMTP id
 956f58d0204a3-649a8599a11mr11595318d50.97.1770129397430; Tue, 03 Feb 2026
 06:36:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260203080109.2682183-1-sun.jian.kdev@gmail.com> <aYH9FwwOTD28Gn04@strlen.de>
In-Reply-To: <aYH9FwwOTD28Gn04@strlen.de>
From: sun jian <sun.jian.kdev@gmail.com>
Date: Tue, 3 Feb 2026 22:36:25 +0800
X-Gm-Features: AZwV_Qimr3FJERvaY9Qr_TnLC5dLIZu4J9bhQ8-QxUcUvNCIWNYgNPDFrut0uIo
Message-ID: <CABFUUZG87ia6AXbA=EWZb9uN=AzbBeH+gb_PDDOonJk-pyTPcQ@mail.gmail.com>
Subject: Re: [PATCH] netfilter: amanda: fix RCU pointer typing for nf_nat_amanda_hook
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>, Simon Horman <horms@kernel.org>, 
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 3, 2026 at 9:50=E2=80=AFPM Florian Westphal <fw@strlen.de> wrot=
e:
>
> Sun Jian <sun.jian.kdev@gmail.com> wrote:

> > 4. Using rcu_dereference_raw() to fetch the hook address, which
> >    satisfies sparse's type checking for function pointers.
>
> This doesn't look right, esp. step 4.  Why not:
>
> diff --git a/include/linux/netfilter/nf_conntrack_amanda.h b/include/linu=
x/netfilter/nf_conntrack_amanda.h
> --- a/include/linux/netfilter/nf_conntrack_amanda.h
> +++ b/include/linux/netfilter/nf_conntrack_amanda.h
> @@ -7,7 +7,7 @@
>  #include <linux/skbuff.h>
>  #include <net/netfilter/nf_conntrack_expect.h>
>
> -extern unsigned int (*nf_nat_amanda_hook)(struct sk_buff *skb,
> +extern unsigned int (__rcu *nf_nat_amanda_hook)(struct sk_buff *skb,
>                                           enum ip_conntrack_info ctinfo,
>                                           unsigned int protoff,
>                                           unsigned int matchoff,
> diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_connt=
rack_amanda.c
> --- a/net/netfilter/nf_conntrack_amanda.c
> +++ b/net/netfilter/nf_conntrack_amanda.c
> @@ -37,7 +37,7 @@ MODULE_PARM_DESC(master_timeout, "timeout for the maste=
r connection");
>  module_param(ts_algo, charp, 0400);
>  MODULE_PARM_DESC(ts_algo, "textsearch algorithm to use (default kmp)");
>
> -unsigned int (*nf_nat_amanda_hook)(struct sk_buff *skb,
> +unsigned int (__rcu *nf_nat_amanda_hook)(struct sk_buff *skb,
>                                    enum ip_conntrack_info ctinfo,
>                                    unsigned int protoff,
>                                    unsigned int matchoff,
> ?
Ack, I'll follow your suggestions and send a V2 shortly.
Thanks for the correction!

Regards,

Sun
