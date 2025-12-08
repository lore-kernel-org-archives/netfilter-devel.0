Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83D92D73A6
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Dec 2025 15:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765207218; cv=none; b=MFESp6UYCeYV9eds9fw4XbPnLcmFw9ygC5+hfJzy5tNbjyoEqdc2P+RxREhddV71263Aec7HPM1vZTYpFGo31IKN0cBCdKj0xC3rtwqbFcvwIlqc1O3yVBRJh9pv4AHsyotwC9KTKRphPfTugwaHo/V6HFwljgfLA6MMkqujV/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765207218; c=relaxed/simple;
	bh=ZUrrPnJe1yfnkii0gYHzRwn03lexWWRzYbUKEEPcHxE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JxHtBxOAszMHR4vkjXy6jJzumD9tRz+KS7v/2xX6+dL2t6Scej1isV42Bl0JLbTZVyLXS2sVzffoCzGGIJdCHKZgyftq8Mdj3wOZiKtnVf1HBLRcpTffFXmbbzrsOewiVR5C/Br453uD9TgepgnFCLNTHebEtXhj8z31h27cqKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2AP9OKJI; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2AP9OKJI"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ee257e56aaso40562571cf.0
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Dec 2025 07:20:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765207214; x=1765812014; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZUrrPnJe1yfnkii0gYHzRwn03lexWWRzYbUKEEPcHxE=;
        b=2AP9OKJIHNKyT/0vXLABqMBq+kbimHKPJvZussMw8UULZAhj9/q3+NzeTeUHBkxaQN
         ClBMVyAzGE8pzknwilyT3I7MmQXhAP3x3FgIPr/ne0gbwEC/agJQ09VYR60Dm2cLpCSj
         UUKhzlhIuF05UXCmJ1tNeE/+E+8FLAJo9LhMy7ofi8ZyBxabcUh/r9Dj9DrhOpZ66sDV
         U5zHjIU508QBrXxq/NTRf4ijuxZ8f4qmvZH42JyarzzCYHJWycxnUa08rb+sEobDWbV6
         wphlAoWBagpfyL/WFnyIU30iPujwZhaSSN8DJGaSFNGXhM2INCXAC/mgLAelyljM0gNL
         r7bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765207214; x=1765812014;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZUrrPnJe1yfnkii0gYHzRwn03lexWWRzYbUKEEPcHxE=;
        b=lwcznzJOc+wCtY2/WdR7f9x45WZOCi01h+KNael67ldX2Fiw2CP4l0wn4fYYki2tvn
         FiygyBvD77v41h1/4GGOs3kJhE1UBsMMnqR2Dm+YtvwG2LPwv4A3Dqb52TOaU8Hwy5HW
         8/rtgstQsOek6c7yQ0nQ5q5TLP6Y8dq+jyr0CcBna4m5BQuwOFRBc/g12rMK+RpkwfC1
         4vswO5xGiFMFDjlR88PwnnlrqAwH55IMqNRU0wqWX27IgtQIFlDitNCVtMrvtzJiDght
         U0m4udr/3hCaJfGMQUyhMwZgcfLBhfS4DTcDOfalf7Itu6Jj4dlSkqX0ze5uRfRTRt4D
         0dHg==
X-Forwarded-Encrypted: i=1; AJvYcCXJk3N5fbGVAT2d2h8wVg8yfa6VbVXGYJ58zUIZPoYRAPbXibsYXHELKeuGHYl8rfKGfntfkLDf1CzvIBWnrto=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkUUyDfzbqhPyMwHT99yN6+PwfDMgv7ceOBrRi0la8Pc+cfCoI
	Eb31eXgpSPhCXygfE8KpkhTZPRixzWDo8lbxAbfqsCvuwwyplVYX6k8W6cD5n8waLPS5Ao61QA/
	13VLokG/NA00Y9L2BmqpeAq0ISFcOQNtDyy6eN6zn
X-Gm-Gg: ASbGncsHbitYIjKpTSSyLBaU+acQ/Jd1/zg7ZIJXKq88qn9sAUrEsrAQQqw27INIrfZ
	+e5RUp7YTtOsasdXB4R074b14djfaGLTaWdj5f4QS8AwH3yVO41+tKA9773l5jUbcpZ7dRchOBn
	5mL+hv49L2SOfRdLIObPWX4lMooeygMuCZ0gjv621bftt9RuDpTXKv7lt9+rPYaB2DFJD6yNOVK
	zr6U/SoSdYeq7fLvlE+Bc4z7ksffB1+IRu5viy9NfpsI2mLC7S+5tco0BpgKOW0+BJ0gCpspeJx
	rjN+WQ==
X-Google-Smtp-Source: AGHT+IEI+Jwv/1GCJ3oyPlYGof/NilG3ks/X42/Evg5t3ZOLDHNYGJ7gfNgux3cDJnxrB2S7HsDrtRORJWzdGaKIKx0=
X-Received: by 2002:a05:622a:490:b0:4e8:a560:d980 with SMTP id
 d75a77b69052e-4f023177514mr254180091cf.38.1765207213143; Mon, 08 Dec 2025
 07:20:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251207010942.1672972-1-kuba@kernel.org> <20251207010942.1672972-5-kuba@kernel.org>
 <aTVVGM_1_B6CGZSK@strlen.de>
In-Reply-To: <aTVVGM_1_B6CGZSK@strlen.de>
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 8 Dec 2025 07:20:01 -0800
X-Gm-Features: AQt7F2qdGqDSu63RtH90pyLB5iJFchAMhjFUy_Ap1GQiXf8l7hd7p6C-L5JEZJ8
Message-ID: <CANn89iLnznzM=77F-UMyok=9ix_PmP46DuG4h5O=_fvwSNKXLg@mail.gmail.com>
Subject: Re: [PATCH net 4/4] netfilter: conntrack: warn when cleanup is stuck
To: Florian Westphal <fw@strlen.de>
Cc: Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net, netdev@vger.kernel.org, 
	pabeni@redhat.com, andrew+netdev@lunn.ch, horms@kernel.org, 
	pablo@netfilter.org, netfilter-devel@vger.kernel.org, 
	willemdebruijn.kernel@gmail.com, kuniyu@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 7, 2025 at 2:21=E2=80=AFAM Florian Westphal <fw@strlen.de> wrot=
e:
>
> Jakub Kicinski <kuba@kernel.org> wrote:
> > nf_conntrack_cleanup_net_list() calls schedule() so it does not
> > show up as a hung task. Add an explicit check to make debugging
> > leaked skbs/conntack references more obvious.
>
> Acked-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Eric Dumazet <edumazet@google.com>
