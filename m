Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0A028467C
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Jan 2026 20:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768335026; cv=none; b=LSAbkoFRKKzjDuxOHrolHls2Q6PxFjeaffq6WRcAKZo5LGdaZFQSmTN+DipZ4AIm8WEWmbSyEV4txNP5mf3CGM41eTGoUZtvhAOTOHvs/6H1Y88mswPvSCYoziMrYCQT+tIxddu7C0Hy5mAmcZkKodbyilw/G7rvjWed7Mv1Ojs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768335026; c=relaxed/simple;
	bh=PISqowe2c+4RDD8+Y4LJYF6tRP/gV/zX+U5Yg9psxTc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L9jxtQ2TQJjJTAVrLKULqloLcdbCVsrdD0MLZrD0ADOwnGUnHny99J6Eas3iPDMs8mXYgRknokxFHLHWoiLN4X//SLWMWKUzwZR+bhgwRERPZq542jBgBjIzFERv8BioYfQ72nKdqYAeZ4+W2GW5V6PKyvev3YxwPVvofAYQPfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dgcf9VMx; arc=none smtp.client-ip=209.85.222.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dgcf9VMx"
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-93f573ba819so3178670241.1
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Jan 2026 12:10:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768335024; x=1768939824; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PISqowe2c+4RDD8+Y4LJYF6tRP/gV/zX+U5Yg9psxTc=;
        b=dgcf9VMxJ1/K4XNYip4IbzCvlRr6ktVMJYXp0hHpj8rc0xkbkik/EF/fkOUesDZqa7
         YDaNdIFLvRQmYZvK6dIltZzTb8gP9DP+xotlr1eudJfLMGbpEXiM1onTNpnCj4TGH1yk
         X0Z5SDx2KNFBDMP7JUTEsupinwNxlN4XBuOM2LUmUlweWPSWaDDI2IU5fvjUJwjlC36j
         SPGt2VKPH//Mtf3D1/WqPzZaxkQBvZNfiTngKHek8Zc7Jw/b/zbjVGVUNZSObY32cQXN
         GAshSYG7Z0y0oUU8Sx0UousG9sHKg05k0wmke751o0uv0vZdnVV1ELyzLdby4jluV2dq
         2UaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768335024; x=1768939824;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PISqowe2c+4RDD8+Y4LJYF6tRP/gV/zX+U5Yg9psxTc=;
        b=B0SnJ6fFddCFGjudbxc5127y+5M1cPNrBbQnZBAR5FNukUXWKnA1Ew+BvhwKSlgKXO
         P0NUruMeU+jCOs20AU6MATDEV2JxuzzFCJHT7dUM6W1qJuQ7VzKNuIvbyKa3ITJ6HkiX
         tvEwWiSWF5utxIKoaPGkOmSGNEX6rd3I6ZG4DyoP4D9OuwtLklcXR/hczWIxxlBU1E1f
         6l73LpAyv1e4qXdExWBA8vnObQgCRaME2ygvkc0RT0Tqm94i3LexG7T86BiwGoHwDP7H
         GeTmHo0By7UFvTJjJmCfg4kKM6Psa5PeRmVLaZzk7YVFH6gvMrfSOf1CXQ6jTICxFkwj
         QkEg==
X-Forwarded-Encrypted: i=1; AJvYcCXjKVFf4iNWcnTlpHOwFreQTqSkXWPRCn2bls8oqdpKvlXbpS6dAzrEcV1vsbQGlQBh1IchMHFzFIiTAHpqBic=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOxWQ5oeMcr8OdU/DYHWi2HzUk5+PH+7fha/EXEAz9CDIdghNG
	97haE5RFi3ley6B/RqQSCC0pqqVQphi73/nBlVMfvePOjGbMRL11g9DPUA0xBN73awkhfMMglBM
	i+fnyaMrGHs89Od0WsD9kRnD1CDek+Mg=
X-Gm-Gg: AY/fxX6pJOT711y2Pmp49sFb7tjiLZcfqO/SGejyho4WqSLHHgsM6fTOZuS4MTFwF7/
	AjbqgiWIG9fGtTHxj66aMZvEeYrKR38J5AJ3d4O3Pl9073nSTE0e/mjZgeonmpP9va+ZlJAtXd1
	Ke8Fh+ltPjYH7weJzx1j+8/ZFyGUXuWjv/6FNqNjsJ0MiFqGPdV/qlFz81GwkTTMj100UTJTL+U
	OgX5akySBlX0kY+rzA4KnF/xqmaABkf+k9rE86wuEVCVCsNX+//Zz5xIPRy20qV4tJxKBUFViGt
	EfIcrVX1Ksm2S9OSNbHbVONs9cY7
X-Received: by 2002:a05:6102:292b:b0:5ef:a247:4749 with SMTP id
 ada2fe7eead31-5f17f584f40mr196449137.23.1768335023609; Tue, 13 Jan 2026
 12:10:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260111163947.811248-1-jhs@mojatatu.com>
In-Reply-To: <20260111163947.811248-1-jhs@mojatatu.com>
From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Tue, 13 Jan 2026 12:10:12 -0800
X-Gm-Features: AZwV_Qh110CfAjqIeJ9pDoXr3a--Err3wGqCF4LHns3UhhlVCEjcOsKHE3kYvJQ
Message-ID: <CAM_iQpXXiOj=+jbZbmcth06-46LoU_XQd5-NuusaRdJn-80_HQ@mail.gmail.com>
Subject: Re: [PATCH net 0/6] net/sched: Fix packet loops in mirred and netem
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org, andrew+netdev@lunn.ch, 
	netdev@vger.kernel.org, jiri@resnulli.us, victor@mojatatu.com, 
	dcaratti@redhat.com, lariel@nvidia.com, daniel@iogearbox.net, 
	pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	zyc199902@zohomail.cn, lrGerlinde@mailfence.com, jschung2@proton.me
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 11, 2026 at 8:40=E2=80=AFAM Jamal Hadi Salim <jhs@mojatatu.com>=
 wrote:
>
>
> We introduce a 2-bit global skb->ttl counter.Patch #1 describes how we pu=
ti
> together those bits. Patches #2 and patch #5 use these bits.
> I added Fixes tags to patch #1 in case it is useful for backporting.
> Patch #3 and #4 revert William's earlier netem commits. Patch #6 introduc=
es
> tdc test cases.

3 reasons why this patchset should be rejected:

1) It increases sk_buff size potentially by 1 byte with minimal config

2) Infinite loop is the symptom caused by enqueuing to the root qdisc,
fixing the infinite loop itself is fixing the symptom and covering up the
root cause deeper.

3) Using skb->ttl makes netem duplication behavior less predictable
for users. With a TTL-based approach, the duplication depth is limited
by a kernel-internal constant that is invisible to userspace. Users
configuring nested netem hierarchies cannot determine from tc
commands alone whether their packets will be duplicated at each
stage or silently pass through when TTL is exhausted.

NACKed-by: Cong Wang <xiyou.wangcong@gmail.com>

(I hope I am still better than your AI.)

Regards,
Cong
