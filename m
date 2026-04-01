Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92A642EEC3
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Apr 2026 13:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775050240; cv=pass; b=hX1iBeprn+xh/y9h5iI231JwOIHTeSK1W3QE7paBS35pOLMJ4HXWKHj9nF+3HJm9iJ7HHp8WC3xsvlOFodiJGktgN1L+AL0HVIsUBdU04LFnQnBO4K5DbJbRfhYy2uIzuPgpborkokBzb9D07I55KDNvfn9xPonxXJp+r/7IZIY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775050240; c=relaxed/simple;
	bh=BRfaxlgXcaC4MwKGbrVI1gU9LqJpM6bbpHxRtdhQuco=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=G7ZRvxkGmdLbNSTTcyqQwKjCM2wAuaiCzePiQ1fqTz0s2ls8ezzDti0bhngyyGIChaPN75Pe59aTr+f3S8loWtf87a+NppXmQTJUx8rRkrdnMMrh4wMgd8Z11fCA/4JiIzmNlqeShNl7d5Q2DotPfXpkTdgnn6xmhgx6+vQSzTQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b=cT6XySWH; arc=pass smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b="cT6XySWH"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-82cdb4ab547so881611b3a.2
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Apr 2026 06:30:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775050238; cv=none;
        d=google.com; s=arc-20240605;
        b=T/XywXZywqfL+PGqATo5x5ATtMlyDVcrZfJNqnqRqAOE439YRyhZY9//2sI+q4Dhez
         KquqsDRMV6eyvA6h5bTwtkYcZzcrDRRJQ4GvKFbT/DVxbyJQrxN+CSYrA4Zf3h1m0bvm
         fwkLHiTKizMPxmqs+M6WgnNkP2S8tmcC7Gs59gJBhIl0oXvu0Dg13cXGwOFffKpAlcak
         EqkYUvNCvJ1nuMJW4s7vLHHtpn/SfHcQykUP6EZGc01G5/wDTvjqsuk4AAt5FO4Rc/KH
         rS7moP2UZ6h+OXEDceF5f9kWpxLVY/RwiL/Jn5WxnH6n3+J69JiFhsHK1cy/08yaKeGO
         ItSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=T7NuR3Bw6Qb5rckRbbyyN8y03wjGHotEoDAqQmFwpLY=;
        fh=uJAyq4SE7/ZZNiyxnDVdxHN8Jsiykw3Q+tGoBVeh+xg=;
        b=fmoVi70QsKEcUvFQrp9lNVq1/OGBmv6rJB+lUlEWdP7B1I4jLjm5Qn+ETngw6boJFv
         2Pq27uog+a2P0Bt5m06nBfLOJeIeBBSXE+3kEV6/7JrvJBK7GDM5v8QdOM3n/BjhDflL
         EQT5YhtdOOZkFdx2gK4A/aDj/6JT1tP0ZYG9VxMVQFXqD2wUQq/8k7txU1mWvLf5sMtA
         06aNRzZfs7+i7QWOn2g3f5zSMmIIOeIrxl4/kkGdExtw6wG0oQSDo3abhV5+7KU7w94M
         pB8XSqiLt9ppZ3H+ubD0tsxulZN3vyMKRydztk48+RoL6dsWdJqPEwQ+2kRgGn17JObY
         IsNg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20230601.gappssmtp.com; s=20230601; t=1775050238; x=1775655038; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=T7NuR3Bw6Qb5rckRbbyyN8y03wjGHotEoDAqQmFwpLY=;
        b=cT6XySWHg+aq2S3NYpIbVDLzA6BLpKc/ISkf9xBq6afb207oeqC1/cdQe1m5xDu4yf
         eTd43MbdP9pd4TUhtWRGmYqt6cakNFdgF76ZA7OkRT22JnSu+iwLLQs0Hxo0aKSVCk1u
         JBYMnulLL5ck1Gdha4ujyJHiBMzhX5nXyZ8m2td9lP/Jc6niogzJ6WgPlMS1iYw2eBEZ
         s1QmwZOynzNhZBbcuLnSTkYJ4YeAeKBKP+ISSia+7Gtc1YBUtjm+QuBiGgurh1irFyIC
         t8/DGgQjZOqjDHdCd7/zcuM5VzPU6KRqcCWaoekQ+pbfr5IaSFzCXg0t6Uu+M7o2X8XV
         l/lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775050238; x=1775655038;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T7NuR3Bw6Qb5rckRbbyyN8y03wjGHotEoDAqQmFwpLY=;
        b=ZcjjAo0E2LIPFxM7VAthUzRPqrflKK1z++AXJTiaiVd4BR9+lhEFI9IoK4COPlQ66B
         HQsGsHxACYQhh8bwnkfI+XkTlH5VMurzf1TvpaAIh8iDhr77c3QJ/qVFN3ryftFCkPpc
         nI/3TFuskCOmJSpptnNpz8Ugtxdg7sTaevLUbg4QKBn2/TjcmMHXwktVYJGZFcYkZYRz
         koqrR2tpwnW+66iffJxNVLaOqC5NFux1dzWnwGqmY+zLoZE8hang2c3jjqhSptomZq5d
         ZHWqUvgh13TxHGaV1rS2kU/ABkKce9G5RTFxg50h25vEFJcqUiv/G08R0GK+ax5ZFugU
         G/jQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdWW37TGrF/ickDVeCKKFKEawsSY6ZNCIDOgKV66+M/Fr9n6VWFgdWEtSLoQAVBp/kx7cMvI7ilgU7NpZLmac=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvJMPX7tYdwhZUaDmMoCq9Yd63AY6uqgvuaWO1qnch3c9JVrrY
	6ToXzLl+/+/Eg9uoR/2f6dA/P9PjFKdFBf1CMj2B1EM26y4cDDnTah3KgJlYv4ZBIU4hBE/VilH
	Uoo/0cAlzq11BjmGFEEdy8G1fILRq0Tn18rrYEsK8
X-Gm-Gg: ATEYQzzgPfbWKbDsvF+4UB7wUs8fA+Z4iL0tBc/ULbV+sdvVLAxWpRsJgjKLAhqsMdF
	uluGdMZ5yuWu7B0p62JarytOZCO6cQl5vM5LrE3i4P2UfUQy9dFAouo+YxInfqzraIkcilamIfP
	vYlYJvHg7s7IgxCtz0VZze1XZoINXMzsylUJzGBkNHkIKaWLE/yfe2rApQbFgQciSzOeoqMDULJ
	f1UE2bKxU0IXoXUu7ZVHxR1/QdVKEDN55bdp6r7tqhrWmqpSKtqcg3HjigjHXg60SONL+rYrPry
	hoePdCzuGdWM2GIiWKlsGL+v8aUAQw==
X-Received: by 2002:aa7:908f:0:b0:82c:ebbd:9eca with SMTP id
 d2e1a72fcca58-82cebbdba6cmr2579095b3a.11.1775050236598; Wed, 01 Apr 2026
 06:30:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Wed, 1 Apr 2026 09:30:24 -0400
X-Gm-Features: AQROBzBVzmwXdf2WGM_n4Zy09fnWYZkggVAvYshhunotULUmqQbgAETJrZK1gAM
Message-ID: <CAM0EoMkHo-e5Smq2yi7c4HxA1dJWzXRYkOo0A6NmbF-HkzaAgQ@mail.gmail.com>
Subject: 0x1A: Dates And Location for upcoming conference
To: people <people@netdevconf.info>
Cc: Linux Kernel Network Developers <netdev@vger.kernel.org>, Christie Geldart <christie@ambedia.com>, 
	Kimberley Jeffries <kimberleyjeffries@gmail.com>, LWN <lwn@lwn.net>, 
	"board@netdevconf.org" <board@netdevconf.info>, linux-wireless <linux-wireless@vger.kernel.org>, 
	netfilter-devel@vger.kernel.org, lartc@vger.kernel.org, 
	Stefano Salsano <stefano.salsano@uniroma2.it>, Andrea Mayer <andrea.mayer@uniroma2.it>, 
	Carlo Filippi <carlo@common-net.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

This is a pre-announcement so folks can plan travel etc.

Netdev conf 0x1A will be a hybrid conference.  We will update you with
the exact coordinates in the near future.
Either watch https://netdevconf.info/0x1A/ or join people@ mailing
list[1] for more frequent updates.

Netdev 0x1A is scheduled to be in Rome - Italy July 13th-16th.
Location: Universit=C3=A0 Roma TRE - Via Ostiense, 236, 00144 Rome RM, Ital=
y

Be ready to share your work with the community. CFS coming soon.

sincerely,
Netdev Society Board:
PJ, Roopa Prabhu, Shrijeet Mukherjee, Tom Herbert, Jamal Hadi Salim

[1] https://lists.netdevconf.info/postorius/lists/people.netdevconf.info/
