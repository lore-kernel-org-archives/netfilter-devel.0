Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD792F860
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Sep 2024 13:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726059892; cv=none; b=ezXrNagLZGsOBMKqYpMz0Nq/su2RjgZYrnBy2wToWjyHH7N7ZB8jA9fC9yYKDn8ndMsPgHAJDtxlxt2mECLcnalXh34lBbNcl3ADcvom2IUmWU7CvE0V3HKl71q1DO53evC7Hh6ijt9xlIUTTyf1u8P85o8BkSF/kzjVoaaJbKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726059892; c=relaxed/simple;
	bh=XhEqLw4bCn1gaZIsINPCMwahuhELNzKbDekcFm7mPzI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WZp2gJCxFOsCkIOMtbHZpIcajjbjZk4Gvs4QNC0VmODaVl3fZdO5VIRXk52pIhpGtYCPypQrEZ4eCX4yjwqfk7ZF9iTDlbCR6hPDCc/JH9YsNfyqgqcOGlBa8XFKsNt26OKydwTA/GfxhoLHkMHm4smh8YdRXyZAJ9lmhavX4Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d4GEKtK7; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d4GEKtK7"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5356bb5522bso8694419e87.1
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Sep 2024 06:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726059889; x=1726664689; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dCxGrUoEy2OmkYiNG6tW2tAoRpm3sIZmKIp30efscPw=;
        b=d4GEKtK7r9SB3x9vNNSN3xlh/zni4BY7gMXSI9U2SeteRIFWS5ymMCwrEDWrEynl7r
         kTyd66vFoLgqrotkQlTZ5c/9Hut12ZTN+eHs4m1mmLBZlmeAwonmQ0E/visMq33l1hg/
         66cyoW5j9uT8nYpSuLfRLlMDq8HgEk+/A7M34rHF1xiuAAPchtPkjSJfIVNOt/ZAaENf
         O4LlVzHRvK9uy6y3UrbxAiBwYbomas75rbDDB3WEgS2Vd3BTIQ5xOkia1HYNktnIqpiH
         71082lijq07CNAyjzjVgblwvcwfLG6wEi1LbpzR2agQEvJUKbB3BC7UCYfy62J5rhEs/
         LLOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726059889; x=1726664689;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dCxGrUoEy2OmkYiNG6tW2tAoRpm3sIZmKIp30efscPw=;
        b=kO/Zh9C91I0pYVSA7fagBZj5Y8akaIh4Qyv3gc4Ibvlru4xfImrv7upwmm02mpFhFX
         2JurkTya3CTLZBbC/uqZiNQFkCnwCE2rY9B5g0uRUPhOvOuLm6YJkEul64QosQLv82nx
         nzsP/6+sU9xMbRMGuPMXlG8DoCRdbitb4jwWpFSYJzKJ5n0T4uKPlXtL1uFvV8dijO4U
         /OTwNTJJFokjUKXGu+UOLRQdnkinNDEeMaMhQN1C1MMahNUAN5qI7wRRqnKRkiq/n/RL
         lBu/NJfFRKG4PpC2tVi9aMz9wZ66ZzRePPixY1WLX8Kp0YPdOaBND/GFmcPdgF+D13h3
         RT2g==
X-Forwarded-Encrypted: i=1; AJvYcCWtp121ZF5VPFS5uan3Vg352MAM48K8VTEcPkK46yxo9XzFnh7CDcEBFP9PCEdJJj6pJ55HsyjaUSz6csh9Vcs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5vxeK7Hwd9Fjle6qZe7Nsk9axfWR/mj6Nm6CCTy3DNEE9cEaF
	bKrcbOsnJh59MAEUwmMIonJIGYdoiJRddjiFEmFpRHf4+hKkDGSp3VVuVGWWvSTBdg0LHxSgZrZ
	ux1yQDOLNZWDa+YwtiZ78ufgCqe7QwFH0QlxzEmgsHvzRJSZhsMDO
X-Google-Smtp-Source: AGHT+IHl1YSn0A6OxRKhGZy7XtvPnUJa6Y4Onc0Q/1+izIkNo69Apcp19Yq/UZ+UfGp21Jx3nLK9SARQN67zTuka/u4=
X-Received: by 2002:a05:6512:1150:b0:536:53a9:96cd with SMTP id
 2adb3069b0e04-536587c6decmr11111459e87.32.1726059887927; Wed, 11 Sep 2024
 06:04:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240911125727.3431419-1-aojea@google.com>
In-Reply-To: <20240911125727.3431419-1-aojea@google.com>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 11 Sep 2024 15:04:34 +0200
Message-ID: <CANn89iLSH23O-3NNvLxFxh=q8QOYm1OeGqKpDWG_7dFNqiiWHw@mail.gmail.com>
Subject: Re: [PATCH v2] selftests: netfilter: tproxy tcp and udp tests
To: Antonio Ojea <aojea@google.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 11, 2024 at 2:57=E2=80=AFPM Antonio Ojea <aojea@google.com> wro=
te:
>
> The TPROXY functionality is widely used, however, there are only mptcp
> selftests covering this feature.
>
> The selftests represent the most common scenarios and can also be used
> as selfdocumentation of the feature.
>
> UDP and TCP testcases are split in different files because of the
> different nature of the protocols, specially due to the challenges that
> present to reliable test UDP due to the connectionless nature of the prot=
ocol.
> UDP only covers the scenarios involving the prerouting hook.
>
> The UDP tests are signfinicantly slower than the TCP ones, hence they
> use a larger timeout, 20 seconds on a 48 vCPU Intel(R) Xeon(R) CPU @ 2.60=
GHz
>
>
> Signed-off-by: Antonio Ojea <aojea@google.com>
>

You  probably want to add this change :

diff --git a/tools/testing/selftests/net/netfilter/config
b/tools/testing/selftests/net/netfilter/config
index b2dd4db45215013df98756be09b5e45759c87415..c5fe7b34eaf19a39777a161ccb5=
8400d446ab585
100644
--- a/tools/testing/selftests/net/netfilter/config
+++ b/tools/testing/selftests/net/netfilter/config
@@ -81,6 +81,7 @@ CONFIG_NFT_QUEUE=3Dm
 CONFIG_NFT_QUOTA=3Dm
 CONFIG_NFT_REDIR=3Dm
 CONFIG_NFT_SYNPROXY=3Dm
+CONFIG_NFT_TPROXY=3Dm
 CONFIG_VETH=3Dm
 CONFIG_VLAN_8021Q=3Dm
 CONFIG_XFRM_USER=3Dm
