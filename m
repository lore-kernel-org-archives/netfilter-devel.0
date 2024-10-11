Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2AF21859C
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Oct 2024 13:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728653766; cv=none; b=XkjySgQKbOt4aKb2tdDpvlfY7oK9zfTvekx9W3qiHWOYwveQpvEmq+j0tglzJp+cqxvKcQLpRcoObFZFpx+SBvB/d9JzqhJg+leWvn+CQ/RPdAbpXI303q+Nv9hZTEr8QSkzuhaTLkX9gzkitY9MiYxYcHCGcmfvrr/LHT2izXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728653766; c=relaxed/simple;
	bh=fMCZau7gECEVM+5ONrqnW08JDEIw3bqxhNrPBgPYtn4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=enFnHV8GMk0Fnnyco42+EbxgH5bni1f9W1ReC5nOEdt4WZ+ZcHvuC8C/weY62YTtBkxpJHfNS5f3zH/f4VfNmHRkmKek8p0lj+rK7rar6zRwPeR/O4zJfj0D0Cay/CppStwJX0WcUi643q9NkeBc2fuKw5KoO2BP5adlL5HbETM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rWWaaNEE; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rWWaaNEE"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5c937b5169cso2684009a12.1
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Oct 2024 06:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728653763; x=1729258563; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=USKluxq12zfRKzFCFxLdF2rYYusVf4YZxk/RTGqb4f8=;
        b=rWWaaNEEyKK8kpnOTIp/leU0UgH5TlcYPCqeg/qqOLkFYIDtV/ifKTS3QFnatxYVye
         9vbfy83y14HUZFek4QJU/xVotvU4WJ6CBlARjiUvTQiCTtBL4NMcrwx1mNlXewOnAIOz
         ah0dyOfaAW8zk/mNy7I34RhW95dUK3+OqxdHVSyfWORiwA/fP/DLaRrXFrh7m7wsKeR/
         Yuig/wmnxqFgH5ScTjB0JQEtCzmVU2dk7OYp+5LaOhd4prlVUGJSZmUk170ustAjzh8Z
         +/ESs+TlaHB0wd4JxCWUGRcWflidwzUXif/o/+Pc3zLmKCNjiCVTbKX3QblTqk68l4wP
         oW+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728653763; x=1729258563;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=USKluxq12zfRKzFCFxLdF2rYYusVf4YZxk/RTGqb4f8=;
        b=BxdQeqVvInVrI3m9kLQDptePQkdMIZl2+oMiMUl18oJ5juGToFF7MoKRuC6Yv7KoJr
         ndCPElvLkd801igD6IMQJaGH7FJdva16IdpwKBTNRB3d2ej3l33q7R/Ozmps6QvaY+ct
         hQs1fkNNAaQkEvzxSN9xw/CnPPPkzWYogt0h5QnauaGqBpt3BMx+IsTVwfIsr1rmMMQN
         nxIsgf08nDDjYCOuS0+bctb5vm3FdnlfbxQSZx/Kmsn+7J5//ayUsCc6WOOqzGM1qZU3
         sCR5vHqc8EQQB4QXzHKudjNXZlx6+qUASfObJVSqkyJQCv3JwLFXo/cyBPli6TX7nSMb
         6hGw==
X-Gm-Message-State: AOJu0Yxp6CV/wlDZwPRQsNWrvhCbruRrDn86AbZyRS1Bb552SB7L3XWJ
	sSCxYrx0OimuDLTlbbGRTRLhuoLrQLTsSKDux5Obm/tTAIPHwH04hMSDZJUGEpZOxWZCfFcSmoq
	e3Ra2/rk8uePcBqbo5KFXn2rQGGd/xRVfc88s
X-Google-Smtp-Source: AGHT+IGSnoZa7RfGo90q6KOd8EjhaO24ftD7wtjE4dw4KgcMJn22Pk3uJkP/w8Tlv2Nm47JMFnDdAkHWzE63JS6x6Yw=
X-Received: by 2002:a05:6402:d06:b0:5c5:c2a7:d535 with SMTP id
 4fb4d7f45d1cf-5c947590d49mr2402610a12.16.1728653762429; Fri, 11 Oct 2024
 06:36:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241010163414.797374-1-fw@strlen.de>
In-Reply-To: <20241010163414.797374-1-fw@strlen.de>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 11 Oct 2024 15:35:49 +0200
Message-ID: <CANn89iJV-du+t1zJBJq1b=NtuSEn+mzFSXZKuAbae1UgyypQmA@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: bpf: must hold reference on net namespace
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	"Lai, Yi" <yi1.lai@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 10, 2024 at 6:34=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> BUG: KASAN: slab-use-after-free in __nf_unregister_net_hook+0x640/0x6b0
> Read of size 8 at addr ffff8880106fe400 by task repro/72=3D
> bpf_nf_link_release+0xda/0x1e0
> bpf_link_free+0x139/0x2d0
> bpf_link_release+0x68/0x80
> __fput+0x414/0xb60
>
> Eric says:
>  It seems that bpf was able to defer the __nf_unregister_net_hook()
>  after exit()/close() time.
>  Perhaps a netns reference is missing, because the netns has been
>  dismantled/freed already.
>  bpf_nf_link_attach() does :
>  link->net =3D net;
>  But I do not see a reference being taken on net.
>
> Add such a reference and release it after hook unreg.
> Note that I was unable to get syzbot reproducer to work, so I
> do not know if this resolves this splat.
>
> Fixes: 84601d6ee68a ("bpf: add bpf_link support for BPF_NETFILTER program=
s")
> Diagnosed-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Lai, Yi <yi1.lai@linux.intel.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

SGTM, thanks !

Reviewed-by: Eric Dumazet <edumazet@google.com>
