Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8272E168A5
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Jan 2024 21:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NGdfZgqV"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6d98f6e8de1so3046263b3a.0
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Jan 2024 13:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704230666; x=1704835466; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4aH1+fO0toimBzLjj8TzmKM1YZO7gqr2QtyizGir9Jg=;
        b=NGdfZgqVq9ZKVHN24G8UHChz7wLTLd0UG0oy4Ccwe/KS9ENzJYcSPTfAbcKwrSfCpf
         BHiYbXKiut6QMy1VJuhkL2788vYfOOpMLPn68eVJU7foUjqCfNzE2JhpdbBnZrwVHKXk
         4BPr/RHa+paseZU/3qN1Zv9nAZwRyLKvrgNujlLtVhtuJLyIjtNbAS28cEOJGK8aTNwj
         NwlSmlZ7LXzx2amqsVNTsJESGES6u0fHMNrZJnD9K/VW5Rwdw1WnjUFafWEWwB0tRB8z
         E+6eE1Uqx0JbGwT7yq3PfvGIAywyZDrdnAeXjWuulnuNqKcnmCklm6wg8DNYcc64eLpP
         5KEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704230666; x=1704835466;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4aH1+fO0toimBzLjj8TzmKM1YZO7gqr2QtyizGir9Jg=;
        b=C0gw6aVGNLyKTiHcKWzaxlwybl9/Q3cwlp3CEfsu2Rtuhi7HzfPeOJI50bBvgYOTfx
         frfdAuTP1d5nObH/6RpM634bmd3Y4HWfk4CQ3OS1fj0TcxSDPzqI1z4sMeQ5gj0svIFH
         WNW9apBceSDlG/j/eo5BoAxIYaGcp/EXekLOiaH++wn416pVGU4WVI5crjj48D1LRCDJ
         NifkCU25H6uKdsIzTWA6U5T1uLSCfx6C+OBXpj3tMcR8zqbi7qIsKMVRtoO3UwK7cGhc
         WBy3O9nUfDHD2dWp0UAfguI6QVc1jKMQGQR+yBk4i3Htax33oHzWzmRElxxdPajcfi3k
         1wAQ==
X-Gm-Message-State: AOJu0YxHAV6YuKSsTtUq0v6CDXxXj7yFfJnMk3l5G669gyP0kM8nlbKd
	zjRMepHTtFlDzwkPGouY0rfxVKNBYgIvMMW5zKE=
X-Google-Smtp-Source: AGHT+IHdjk0ZlGxL4jMILOf5GL28rMhkEN8eV0+pC/K1PoImAP8zcqs5AP1DLrLdH8sJi/2YhVURfdQXAheg5zIAOyA=
X-Received: by 2002:a05:6a20:258c:b0:197:1900:5f4d with SMTP id
 k12-20020a056a20258c00b0019719005f4dmr1456037pzd.39.1704230665753; Tue, 02
 Jan 2024 13:24:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOzo9e7yoiiTLvMj0_wFaSvdf0XpsymqUVb8nUMAuj96nPM5ww@mail.gmail.com>
 <ZZNuZBK5AwmGi0Kx@orbyte.nwl.cc> <CAOzo9e4o3ac0xTY4U3Yq0cgrwcaK+gYoyA3UH7xZEqQ6Ju7UYg@mail.gmail.com>
 <ZZRG_yBt8nf-cqxs@orbyte.nwl.cc>
In-Reply-To: <ZZRG_yBt8nf-cqxs@orbyte.nwl.cc>
From: Han Boetes <hboetes@gmail.com>
Date: Tue, 2 Jan 2024 22:24:14 +0100
Message-ID: <CAOzo9e6GvnSs5XY+DY8qW3b7OHNaYk_QjcDSMRS6tCntkhzHFA@mail.gmail.com>
Subject: Re: feature request: list elements of table for scripting
To: Phil Sutter <phil@nwl.cc>, Han Boetes <hboetes@gmail.com>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello Phil,

Don't worry, I'm used to people not actually reading what I write.
I already wrote some working, albeit ugly, code that converts ranges
and CIDR to individual IP-addresses. But I think if nft would have the
option to simply produce the individual addresses belonging to the
set/table, it would make the whole script a lot simpler and more
logical.


Have a nice day,
Han
