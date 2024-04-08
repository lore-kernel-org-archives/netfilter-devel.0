Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B4E129E81
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Apr 2024 13:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581979; cv=none; b=pHwDwvoM0C7AxPOsi4CE04IN/SJJ08m1A9boBWcRloyCtGMROIZH7XnXiGdP9qvRG6yQG0WsOogA/LWsMhbDzDp89DcjreshgyVttxu2RVEDaK/ZtkG0SVW/krfGMreB5EVufh/OISo7MbuqSQWRgHLXErEeldtc7KyqgkraSa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581979; c=relaxed/simple;
	bh=0iqngNH3jEvlaOWgNf2tjTcQ9ZCKb8iGNqEUBkUj1gY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Cc7w5J7h3tSZ3RcSx1SxvB05g01lNNrAVP328AyxgIrLIj0f1bnD1dwJuGFvKjupXgGTb7yc9+ruLWelFcuc4nC6WKMKUbgf+j6TznrrG/SyYY21+KnX8jb0szY05rOdGXNUJfrOC5oikWAJIMH9WUTSXMHq0bitsrS2a1tmmFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1vMMWc6P; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1vMMWc6P"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-a51a3459f16so58834866b.0
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Apr 2024 06:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712581976; x=1713186776; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/CH4hwVso/WDr7y4pSKS9yzbDjeKeN7zzQ6h4YnWEb4=;
        b=1vMMWc6Pm+UL69POcfUInC5wjvQswyw+UcsU0PiBcFA/UOLSHn5ly97h3SDv1iXW5U
         yQ+VfLDgnaW3BH1mqx21rC9MdKIpPQ+HPXk1zKqIEvdjmITBBZKxdyKgmfwL3n52osKP
         GbyF/7GFbvHEUdX5INhLbMAlS3y4Ht0A0ZYTgEiSVqSbvQwQsiT8MQYnSUi2omc6jKlS
         90OSRuq3btGFE/dI9uPNBvy5BBZNpD7y9HWubl8rmVqP7w6aGjovprE6RhgKdwKN3VZd
         nOqHVa24IXCmNs+sItRCIqmDIF7Hin0Hyvlf0CqIZHgY4ntRfRWSA8hEpAfIuoJtZPQQ
         VRyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712581976; x=1713186776;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/CH4hwVso/WDr7y4pSKS9yzbDjeKeN7zzQ6h4YnWEb4=;
        b=Gy/r5weBlA1zrb983zeayhc4fsBevOPnX8lXfA2rNp0uYDEzH7DX4DeBGQ8fPUQv/2
         rkol1ZWHiENFApcX77ivHdBPH6yhoPC7QFBd0+hinsDObHgwha+gf38L4Y+xJUNeQZv9
         IESEZJDuiuEXJcRXe3Th3B2+LKXqnZi+on9FYIj7o9mky1gbzGEuhtySACBz9jd8qRob
         V5WJGuUdF+wCqGceESgdaPOzR35Uo43cUJZ2V/5rcU6eOv7TQxkFvNSla/6s2cTGHii/
         1nCO/M+fr2gVD79VXZye5VeTdb7R9CIlIGw4gjddmqyd7kcuhigFDjLZR+ZBxKJszXG9
         ybBg==
X-Forwarded-Encrypted: i=1; AJvYcCWZ7+PzMflOZxVfb6fby5mQFOHdHRE0FqzOXlgjUKX4xh8EO1t/ADphWZRIpt9A7Ra0AS1C6gNR/cW4bYuLw9B82DOZYcvOaeIxUbxtZViC
X-Gm-Message-State: AOJu0YyQkjuizfj2jRTKPnVDm/PuO2hxeuXwQnmsN+xgl6hS6H+IyT06
	Fv0715a5DRVKr+nWlWR+r0NQuCHmzk0tP+TYM/GwNuskyiOwTUy6QByEI2f0qjYz56Is3dTZ8Wa
	pZg==
X-Google-Smtp-Source: AGHT+IGs+m7MfAnJA9ItGk7TPmWFffmQH2vM458kWN6Zr0u30DFEEpFcIPz4OlejhsQN9AEuPXPEmINaC5w=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a17:907:77d2:b0:a51:9148:1938 with SMTP id
 kz18-20020a17090777d200b00a5191481938mr10276ejc.15.1712581975754; Mon, 08 Apr
 2024 06:12:55 -0700 (PDT)
Date: Mon, 8 Apr 2024 15:12:53 +0200
In-Reply-To: <20240408093927.1759381-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240408093927.1759381-1-ivanov.mikhail1@huawei-partners.com>
Message-ID: <ZhPtVYkVcKsUJrty@google.com>
Subject: Re: [RFC PATCH v1 00/10] Socket type control for Landlock
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 08, 2024 at 05:39:17PM +0800, Ivanov Mikhail wrote:
> Patchset implements new type of Landlock rule, that restricts actions for
> sockets of any protocol. Such restriction would be useful to ensure
> that a sandboxed process uses only necessary protocols.
> See [2] for more cases.
>=20
> The rules store information about the socket family(aka domain) and type.
>=20
> struct landlock_socket_attr {
> 	__u64 allowed_access;
> 	int domain; // see socket(2)
> 	int type; // see socket(2)
> }
>=20
> Patchset currently implements rule only for socket_create() method, but
> other necessary rules will also be impemented. [1]
>=20
> Code coverage(gcov) report with the launch of all the landlock selftests:
> * security/landlock:
> lines......: 94.7% (784 of 828 lines)
> functions..: 97.2% (105 of 108 functions)
>=20
> * security/landlock/socket.c:
> lines......: 100.0% (33 of 33 lines)
> functions..: 100.0% (5 of 5 functions)
>=20
> [1] https://lore.kernel.org/all/b8a2045a-e7e8-d141-7c01-bf47874c7930@digi=
kod.net/
> [2] https://lore.kernel.org/all/ZJvy2SViorgc+cZI@google.com/

Thank you, I am very excited to see this patch set! :)

You might want to also link to https://github.com/landlock-lsm/linux/issues=
/6
where the feature idea is tracked.

=E2=80=94G=C3=BCnther
