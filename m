Received: from mail-ej2-f1.google.com (mail-ej2-f1.google.com [74.125.228.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72022F6562
	for <netfilter-devel@vger.kernel.org>; Sun, 23 Aug 2026 19:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787512337; cv=none; b=YbhihAae1P706A9kKd82Oubdz+4l8Fil9h5mQeM6keDuQ9Nqth1B8vWmkT8BpFffMWntJyHq1eZXB0SEzD5g0fmnUbkzURb9gkayfEpiZ4jJevZ2UJsl1dbrqMSrt87hcQBrhpbPDxUlZPNyE237daTJ07dX01iQ5qpL1i1tYMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787512337; c=relaxed/simple;
	bh=bCZO65107Zw67SaivJ+auwgRTrcxaY7YXiKV7VzHv6I=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=LAqGtlQlmNWoAzA3JAkBSrCV15T2E01NUGVMDljmrtCX1Nd3bSvlkK7WASa4jmqomLwomFt+VEKetBW9RxYwYaT1FuomBVpahYdtbC6/vLHxDfYHXz4h0hp/QhEQSv847zfEWEL5uaVmlwMkBGsYLQiaCDxkh2gxhcD7b76UAQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d7WsQq8o; arc=none smtp.client-ip=74.125.228.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d7WsQq8o"
Received: by mail-ej2-f1.google.com with SMTP id a640c23a62f3a-c15de09d5c4so178044366b.1
        for <netfilter-devel@vger.kernel.org>; Sun, 23 Aug 2026 12:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787512334; x=1788117134; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=bCZO65107Zw67SaivJ+auwgRTrcxaY7YXiKV7VzHv6I=;
        b=d7WsQq8okdU+iCcPHihGMFp/2AutGXHQO83L5ezqBkq78I2xvTwKeydq+WSy4QT++G
         z11c8irE0djh/i4UJaL4WR3/FmiRJvQ26z+tNdKv06teuwIodSCzd+TpEd8FHrBIECQ0
         de93q7al+TVABQ6xwGrK5vGo6pF68FuXqBdHPtJqSmK+tUc4kDxpfzDetzp4TWVq/C1m
         HyVwoulewIIkn5uaCaM2Tq5FtP8t5XOOJOoLJ+tvNgTyUo/J3gZ6K2kxOTJ1hs/3zERe
         suuF9Zz3psdRqDCU0MSykMYsKJiMcO1hlG1z7vVUJsROUkGCppBOyKMu7MyAq0RgMWff
         ZFFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787512334; x=1788117134;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bCZO65107Zw67SaivJ+auwgRTrcxaY7YXiKV7VzHv6I=;
        b=qYmDiLWCjlPwp7JOaV2I1tK/WYpQjUDEZmQSFBKdW03sscENr48do4k8ODMUqIPXIu
         39y6/2wRdyT3f9cToRYuKMomofar3wlEXxoXAk0LP+sUDM8MvOzE2sR6wgtanfxosT84
         ZpFZVEvQQOh9rncJHgpV68V5az9m3DRUn5Sh7jewwKNMyyZG95ZJbAVH58BB+KJl538h
         8Mc3oanCqJkitxVlEE54aBEdrvECxezv6Tr2PaxZA8GRVUId8ux0iiShR4nwpbfU+bk8
         jFdddupVNGb3WBhXoYzAS4LgjniTdg2JCTyiH+C/0xzcYBA7oVgpEDnezLYIa8Y0Jce0
         bAgw==
X-Forwarded-Encrypted: i=1; AHgh+RrO4bed6PRxK/gUsDGjs6PQqXKcV2iwlbsWEhCjgWoIllpFvifVCTkh7riycE57W9BWkKejH10k3Hg5nQrIAms=@vger.kernel.org
X-Gm-Message-State: AFuF++nZKv0HgrTwKu8a14FeEEvd8eI/1TF2Fvtm52Pz9mEo4tJtBU9K
	LmO3wfFXhPjeQW14a7MJWrcz5YrToWZ+b6o8PCIIKOrs17NiBSNOpwnL
X-Gm-Gg: AR+sD11rNZ6gKWW0ju6rHqdWmjSEgOf9shed8t5v+/0cUQE15/VTxDy5s1ZQ6JChIK6
	N7io6wSRr4ya7q7Ccbn2jKCYQied1tXBIYFJKmIjn/ReJ33N9uvy8y/IBQsnLTGcdWgF3n+ubIo
	8f+TMA/TTyjJe1bqZva9RtPwATcdy5vQ3j9In90tuohDWgGQe16wpnZFW6xYE+LB5W1AmGK+mpI
	SqUdV4NoQfnhZhrgIUYhq5e82VSL2c2so4Tt6MGellTcZ0gmo4Da5JzTrM1948sHYix643IZyo4
	fSxweU+MNWl/mjF+qE+bAB7oVWVC4qwGc5crnSsf56BfAPoQLsB7kQQ+th4a4G4vwtmXgvp6Mtx
	E03u39u+EmuQT/HuhVooLdg9TGDGEW3LcAAAgz1owdQJAvTo6xqGKzt9r6yt1JmUodDbKmZqPsI
	Kq6nzcK/TArlICzKf4aveY5BvcODALhrIyaRJWNvszCPEShdjJ6ixzpPC1ku2XW8kHE3TX7lc2f
	jRtH6xvcFYp1HVPW+DAY4FgugnTtiPnpsVWUQVpIUxaVQfuj75LQ0+9mZH83njFexPhFgkDI5sx
	X72scxIju7MdohDYF+OsH+SKL84=
X-Received: by 2002:a05:6938:a093:10b0:c21:3c4e:cb8e with SMTP id a640c23a62f3a-c246a654f43mr1785408866b.12.1787512333931;
        Sun, 23 Aug 2026 12:12:13 -0700 (PDT)
Received: from localhost (nat-icclus-192-26-29-3.epfl.ch. [192.26.29.3])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24962bd8fasm1270648766b.28.2026.08.23.12.12.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Aug 2026 12:12:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 23 Aug 2026 21:12:12 +0200
Message-Id: <DKWK8L9QBA37.2QGA0WNXIBV9C@gmail.com>
From: "Kumar Kartikeya Dwivedi" <memxor@gmail.com>
To: =?utf-8?q?J=C3=A9r=C3=A9my_Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
 <pablo@netfilter.org>, <fw@strlen.de>
Cc: <phil@nwl.cc>, <netfilter-devel@vger.kernel.org>,
 <coreteam@netfilter.org>, <netdev@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: Re: [PATCH] netfilter: bpf: disallow conntrack kfuncs for token
 programs
X-Mailer: aerc 0.21.0
References: <20260822210945.1003967-2-Jeremy.Jean@oss.cyber.gouv.fr>
In-Reply-To: <20260822210945.1003967-2-Jeremy.Jean@oss.cyber.gouv.fr>

On Sat Aug 22, 2026 at 11:09 PM CEST, J=C3=A9r=C3=A9my Jean wrote:
> BPF tokens delegate BPF and network-admin capability checks to the token
> owning user namespace. Conntrack kfuncs nevertheless accept a network
> namespace ID relative to the program context without checking whether the
> token has authority over the resolved namespace.
>
> An XDP program attached to a veth in a child network namespace can use
> the peer namespace ID for init_net. bpf_xdp_ct_alloc() then allocates an
> entry in init_net, bpf_ct_insert_entry() publishes it, and the lookup and
> mutation kfuncs can subsequently access that host state.
>
> The verifier retains the token in prog->aux, but it cannot determine the
> runtime namespace selected through bpf_ct_opts. Conservatively reject the
> conntrack kfunc set for token-loaded programs. The kfunc interface is
> explicitly unstable, and ordinary token-authorized XDP programs remain
> available.
>
> Fixes: caf8f28e036c ("bpf: Add BPF token support to BPF_PROG_LOAD command=
")
> Assisted-by: Codex:gpt-5
> Signed-off-by: J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>

So your solution is to just begin rejecting its use? Proper scoping and
containerization of programs is a bigger project that needs more thought.
It needs to be addressed properly across the API surface, we probably have
several other helpers/kfuncs that have similar ns-unaware behavior.

If we went on to simply reject each case programs using BPF tokens would
basically become useless.

pw-bot: cr

> [...]
