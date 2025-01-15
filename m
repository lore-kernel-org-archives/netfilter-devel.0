Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBEB3DABFE;
	Wed, 15 Jan 2025 13:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736948662; cv=none; b=RIEpmk3impLNsN1TA4lz4TkcAxTDRodmypFJEUWckCvp1Xf4afQKgbdb17pJe06Q7mOkPLpFlfWauJ1J83hiC+iKgbgXZFofk1xHeUuSHju7NxlNqjgMqelfWQ/qz8uq964kujsr75zfCH278oLe2uzI5S0jmB4UfiiSFRhZgWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736948662; c=relaxed/simple;
	bh=DXW3JTwqo8qxI4mI5ou6PZ0hWOlpZpaQP5DWdfFfu0I=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=XowhskmjDecr6wLiTUs4Wt5iKZY+GOBfutLKGSYNW8SH5BNNDWDHgPYcBZQvgrSTkC+d7wWPU/mJpDHqbGDEFhLrDne4RbFA4+zejL52bm88+vw9kf7B0njoQ+5WKiAu0PKR3DDwC2fLwSxFbHruE/NF1rjxIbKU8QV8aUBVfEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PUzoueGy; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PUzoueGy"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e53a5ff2233so12763656276.3;
        Wed, 15 Jan 2025 05:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736948658; x=1737553458; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DIuefMS2TFWQq7a0G7FiWAIf5w2bWtUsqwCzJHosvCo=;
        b=PUzoueGyw7TXoBgQy6hBaKv2KOd8WBOFpSUikRBb87FlrFyrqwgYlrRBBCUSAic06H
         4WCHaQ1dax73l2BPN7wxcffzqTpaGQNWMF0zcXS0gwHIOn1b5tK8YssyTUqGFrSdSEqs
         jik3yU/rYJilDiFZ8X4LUJNsDmGp2RMppmuWXGp4+DtACt/c2Oqm0/V1O9fhLAbhRpoy
         RHE0l8r9RQtlL+hhpMdZiO2eRlkmPd/p0WKS80mqNtWMJpju5v5YB2oSjhCkDq+oK19u
         +shP4L2J4pfim7MnwXLZhmLpsZUcTD7xz4zhfKinRWSsfbG7Y9rmZzWhlgJQmMbO6bME
         3zKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736948658; x=1737553458;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DIuefMS2TFWQq7a0G7FiWAIf5w2bWtUsqwCzJHosvCo=;
        b=wax+F5fAXc4y9N+xlAmES2HzOChLqqbpQRbjHqdxXvvhLCHV1qs3m2WtYWE+dWOjpt
         asbFFgJGshVW+LAkCF4NXoydHEi0TqsA+XgqtxOlKuAtQppiXNfp1EQwqaRGVp3FNUOI
         7v06bCNw2JaRcxgadE4Wkc14uQ2ia3IqJGXESaqS5OxZw/1yWyl57Al+3jjT+wXHDanN
         HcR+rTO97NXo88eL870itZzLkBtSZVmljyw93kOB8Cg6qLklmudxlUa8Wtycg7dQbhru
         eU74b/ORJa/K8WxBJpgt5in4GEtC1p6LKyXAmqC/zN58nRLFGgBU0z9zTA3HB74th80I
         qoag==
X-Forwarded-Encrypted: i=1; AJvYcCW3bgj95Fe0vj10Vp+HRsj48Q7mjimCwXVAm6HnZZZ2nOPrug6SJn8QKhVMrkWB4sZnmbypZSzK2Bu6P55W0HQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUn7BB+M3tUkNhYQq5vwkP8x0RTCjPjckchTXREHm3q5bwMLF0
	WtEkKX1T1LCWQN3jay4O5f/woab2WbK+DGpmdgRGWgDMAtCHj1feDXypUJ2/bgoBeMF/sadGVz7
	QH6oTYmM2ZiDNWIYl+7giK4WrAKOFw4gx
X-Gm-Gg: ASbGncv+OVye5bzPSnPO9hHFBNFFF+s5USpIP05xHqMp6cq+K7uuaqth4siQNamGRnh
	e0vLK2L6ViFpAz+n9hue1GWWaaV03Mad8svOo
X-Google-Smtp-Source: AGHT+IHyGprOtplnxTh00KgWrUmJIKAy6RAEd91Jv4u93XNd6nnme7oQdOC6MKL0riAI6u+BIgA7stQmBnhZbxtN8Ho=
X-Received: by 2002:a05:6902:1184:b0:e57:38e8:e48b with SMTP id
 3f1490d57ef6-e5738e8e997mr12631349276.17.1736948658195; Wed, 15 Jan 2025
 05:44:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?Q?Laura_Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>
Date: Wed, 15 Jan 2025 14:44:07 +0100
X-Gm-Features: AbW1kvZjRomcYhhW1X-G9fJZ1EKm0d81IaShbDxzmCOU7_GmH56i0qS85up5v78
Message-ID: <CAF90-WjyJAW7B5U9ndVbYAJ1o8c+_iZS0McUAfkENkJpXy++Og@mail.gmail.com>
Subject: [ANNOUNCE] nftlb 1.1.0 release
To: Mail List - Netfilter <netfilter@vger.kernel.org>, 
	Netfilter Development Mailing list <netfilter-devel@vger.kernel.org>
Cc: support@relianoid.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi!

I'm honored to present

    nftlb 1.1.0

nftlb stands for nftables load balancer, a user-space tool
that builds a complete load balancer and traffic distributor
using the nftables infrastructure.

nftlb is a nftables rules manager that creates virtual services
for load balancing at layer 2, layer 3 and layer 4, minimizing
the number of rules and using structures to match efficiently the
packets. It comes with an easy JSON API service to control,
to monitor and automate the configuration.

Changes in this version are:

=E2=80=93 allow several farms with same helpers
=E2=80=93 fix tests
=E2=80=93 ignore reports
=E2=80=93 rename zcutils to utils
=E2=80=93 server: enable only loopback interface by default


For further details, please refer to the official repository:

https://github.com/relianoid/nftlb

You can download this tool from:

https://github.com/relianoid/nftlb/releases/tag/v1.1.0

Official nftlb project web page at:

https://www.relianoid.com/nftlb

Happy load balancing!
