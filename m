Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795647416;
	b=O6RNpzQPceZUkoeRzh54XPmdyPt5azU8XH52OAzNR/1HZ3VzXxUyDYt+NGLxO5vYQA7u
	 sPsONJYZWT9+0Dxn5Jv34rK9JhsKEBhzHX2GhPcrFDjuUAAuOrdj+up6EHxOXNewTbvBP
	 Y/SKVkmSt5SVJp8ihU7KpPudZEm+f0by9FqQWCwF8uiySV5syKwXLWjMh1zmr+vQi5bsU
	 eb/VKvt5f4JTvh17fFxxdmqMffbEXGZ81ab66t6XiTZSQPBir+bA4Jz4Y/92mAzbBIgG4
	 mfjV3PxUeVhUlGJKLkORaALaOgxGk4r74qCQsNYmiA/xWY/1SA9jc3OrgjAUengw/zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795647416;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 Content-Transfer-Encoding:MIME-Version:Content-Type;
	bh=fAkJfhA1e625VlHi6/CjskjkxYNTufG3gb4nVL5CjEE=;
	b=pTFaR4vfPF1MKFrq78GMXzlYyDmx1520hx5cEjd3T3cZWeQfg9UPfYgrc/EyJCakpRyU
	 lkvrqE7408/TBoTJ1xEfC2gFHYG0o065LKrUv8ZZVVarmBN8FiTfzgO8AKXDLp8okHmFc
	 a347D9NlpfNUNqWuwJEcxMaCumxTJF3Gx+BIzbzZaRJk6aT/5hkPNCBiiFmXcmGmNywLs
	 WOjY7vdTM+W0TazUqyEpb7t5Qi60BBpT4L89CiaClGi62xUjE66ykxauAsI83rJrGrIkL
	 zMvvCd4Em3XziIP0Wc1hBV5yUh33lvRCZ4j1wcvOOFWPmR9++GeNnttnO5cqesRNDcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=R24Rs4io;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09C6606A336
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2026 22:56:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D09C6606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=R24Rs4io
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a5b2be99a8so53786165e9.2
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2026 14:56:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795647414; x=1796252214; darn=vger.kernel.org;
        h=content-type:mime-version:content-transfer-encoding:message-id:date
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fAkJfhA1e625VlHi6/CjskjkxYNTufG3gb4nVL5CjEE=;
        b=R24Rs4iordavR6xw7FQ0o/DZGxqlMi1qPyiseaTCiFjx7grVaeSX5uEyVemQjN4std
         P3Qbx8EGfB7TEqZl5LYeeUmy2V929SvoaF4xo/+uvBBSlDWcVu+jT/Q+pridMe32kf5c
         3iIK8HUn9cq/1cMPqfqd/w9fZfkHQZYpRRLJang2Ujxh6V6RKnk8txMDjYJpobo70uDT
         2/Ia9ALqMOcv+hs6xhhqW91UbgncBeY8wxwlb+TPGWgASMR55W2Cy87d6A56nmzgMwMZ
         fSNjTzium6njFnxG5ATdvgIUt01ncWzg7+Sknc4eQvy1E5rZmoq4ucFg1964Tx+DKk5p
         0pAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795647414; x=1796252214;
        h=content-type:mime-version:content-transfer-encoding:message-id:date
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fAkJfhA1e625VlHi6/CjskjkxYNTufG3gb4nVL5CjEE=;
        b=mFB4VqUoo/vNrkBY/jsuM16EV6Tak3can+DZwA0WCLwB+IlJJYDGEzJh0/f1re2Mo7
         nPNraCRoMvxaYWmi+lGABXpI0yozn84Q+DgnGsVWPyYvQnlPo6EznC75Xkf5QKxg4UAw
         6YT6OHcvuEkRpZgaXIsLMQLQGefMperZzxxz+o06SPdv1AvWwdUuUK1042ER484J1zkB
         RXoe4imo8p992oCC1rwgiS5M2fK7qBlYQingEjbA0H+3owjp1w7F8gBxo6U8GdUTf9FJ
         f1bkftMN/NTpdYPbj+P6Bpv7NnhAe5v9oPeTNtoHNr6URRODJG+1rCPqqosM7j01fNq8
         jTPw==
X-Forwarded-Encrypted: i=1; AL+hErEWt+HpAuNwPTYLNyqSRGWPvc0QD01GAmnTf28o+Gy2Wo+hN1u60CKlUJDZpTT84yHnBLeeAuVMyLubbTGsu+o=@vger.kernel.org
X-Gm-Message-State: APuU4Z/Ecyy27ucaKUS1RAr1hfNC+r+qYR2tAZxk4w6MHNIEvQRNN9UL
	zHvPmRD/AeqrEB8BvbtotosbgvcWQekZWXG5m9XS3Zw6ZW+MPDd939AN
X-Gm-Gg: AZFdTZcLS6Z5Xx6ieYLLOydlNo6j6bv6uk/UcUqHG7R8XXW7vKNX+Xx/93DulIPaxo8
	hKKp44TdsG8FwP9p5+RafH4g7Ct015kH8dZhWoyXcinSrIYtnB8bE8WjMWcisp3M3FWcexiOZhZ
	j1qDMq8bSD4CF61LX2rwtuSfT8YLX6NQk5WxwEqm3wZA7yS2WcxrTts76AhfqIwQn0nbZAr81hE
	S1u8T9hvjaJeC1y10YdeDbcyD+EyRZWX4kFAn7csZgY1FvHMsmQD6sSHxAtef+XKwBQ2CRV/8UW
	Hzq14HxFQ77Mq3LdzoS3yNqf1A+NtCt/WCtKbE8lLgDhdQPdjLb0w805FRcWdljwobeyr9CP82L
	oXVN29+cqAgESP8sdoZckmoWDu3lae/xRbPCCLQF2x5b1KKah1kuW2ELFTXAdoV2Ieapv6GNPax
	f4oQ9xF1dgER5mWH+FQ9SDv6GRZDaXf6lg2Xghhqeh4ZDOD87QbNN/Hl+vfzcQ9TmrgqU16lmvg
	QyV0xEgC626rz0jyKaeHi33HHcOnaZFFztukriZ1iyH59ynrBTiho5FMuxdIITYEIeLxjuUxI0P
	qm3OG5XUIOXAm3SGUZup2//bta9Kem4OpsLfaJTM1nSBUF+XGMx3IKY=
X-Received: by 2002:a05:600c:4515:b0:4bb:659c:b8db with SMTP id 5b1f17b1804b1-4bb88813b27mr402625445e9.12.1795647414193;
        Wed, 25 Nov 2026 14:56:54 -0800 (PST)
Received: from [127.0.1.1] (ip-024-180.users.dtel.ru. [91.210.24.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884b8429sm865695085e9.14.2026.11.25.14.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 14:56:53 -0800 (PST)
From: Fil Dunsky <filipp.dunsky@gmail.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Vladimir Oltean <olteanv@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Florian Fainelli <f.fainelli@gmail.com>,
 Simon Horman <horms@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
 Hans Ulli Kroll <ulli.kroll@googlemail.com>,
 Linus Walleij <linusw@kernel.org>, Russell King <linux@armlinux.org.uk>,
 Christian Marangi <ansuelsmth@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
 netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, linux-arm-kernel@lists.infradead.org,
 linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC net-next 0/7] net: cortina: CS7542 wired IPv4 hardware
 flowtable offload
In-Reply-To: <5e9d9808-3917-4706-889d-ae1c360155e3@lunn.ch>
References: <20261125-almondplus-offload-rfc-v1-0-703175c6340c@gmail.com>
 <7252b836-e375-4550-90c9-b0e3ab7fbb6d@lunn.ch>
 <179564372798.5.10006827612276789857@gmail.com>
 <5e9d9808-3917-4706-889d-ae1c360155e3@lunn.ch>
Date: Thu, 26 Nov 2026 01:56:38 +0300
Message-ID: <179564739825.6.2717872099061772018@gmail.com>
Content-Transfer-Encoding: 8bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="fixed"

Hi Andrew,

Understood. I will focus on getting the basic Ethernet series reviewed
and ready first, and hold further offload RFC revisions until that
foundation is settled. Further offload development will stay local in
the meantime.

Thanks,
Fil

