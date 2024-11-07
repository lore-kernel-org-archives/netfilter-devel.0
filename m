Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A421E2019
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2024 10:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730975147; cv=none; b=I7lqse7gXkejzrGPTPdcq8dp1DZEWrLi37R+jzOAASypnlonS3JAwi1gISKqH+MPUQ2PjBoi6Oj9SHATkW+IWXPL4M4jd5rDTMwZs+S3jWZ795LuaMIUTzwkMAho0LrQgBtyVryMl5wIBtqQ5oC2UXDzLxrZ1E81w7NnZuKTJp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730975147; c=relaxed/simple;
	bh=CrKn0ncj4UPOD7ltuDxP9BoA99oYardMCiwfQBJdUNI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=giw29X6kG4e0MqnzYSxQoqaJMjsFd4rH2gB0Mi1xgPHYocKXXAjIWeBCqsY+yBxoEZvBNCbLsnny3E+Qs2gNKv60RS+GKJIJemRlRCZkOeJQrpYFl0zJG4lgX6y3+tgsac2lZOzyiOhcIQLb/4IMAEoEIMyeFLKABoTML++wuRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fxL4NPKW; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fxL4NPKW"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a9e44654ae3so104991166b.1
        for <netfilter-devel@vger.kernel.org>; Thu, 07 Nov 2024 02:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730975144; x=1731579944; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CrKn0ncj4UPOD7ltuDxP9BoA99oYardMCiwfQBJdUNI=;
        b=fxL4NPKWwXSBz2+Y/XLs9A0I+kjHTYItN60UYcNny8iXo/+o6obGAMUJEmnFHfR6xn
         tNTkGPValbguMNm2Q/wmAkfOEcVlbF6/IO6r9uW4cfKDvFqyAsqj6ssJqgX/R996Rhpt
         XvIx5QmcrXFhhzrmq+Gf2auUGghw2blwOPUhEkBymgafhqB7Ut+JMpn7PZeDGEeCsE5P
         9a6Nkv90GD61j5u5Z6PWLCVosg6ZM/GpPOqwpRVrXaHf3JZFUx4E7tBYYiJZOAqXmZp/
         OSL5MQZXq9/KP15n1Sgb/rg/0k41c3GSu3fJROs/L8qA9wN7D7Es4w+PLm4EWPtF+gXx
         ecag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730975144; x=1731579944;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CrKn0ncj4UPOD7ltuDxP9BoA99oYardMCiwfQBJdUNI=;
        b=iWwQ6kusvzirY+YdBecZjgnqJEeLAiH0/1jmKNPOykcNjF0q1xmwzKkzyjfbKTxIq3
         cNNM8KtVTZqeZHzebch082ma6sWRSBIhgKx27oM4x77l4I/bz1CTkhB08JSAJVJMj0Qt
         0DGZiIESB4yeDPpUTXUuecNKgSqY1Mudnn3LJkOgf11L6VYJXGypHIDKA0YogDyYjR7C
         aMGUTCDTA+eWS0iFKEpaEdCt82XWuMj9RHBtNuIbowDqqauP67SElVpBBO1P4fXaOSgQ
         oyJhVvXJk8ybLAqc4UDrkninEZrAX1kg7sZS0apynpFHB4jrne5ap4xGI7CcUaLKYBSX
         O6+A==
X-Forwarded-Encrypted: i=1; AJvYcCXWEarcZ0IJpKnxHu/cm3ul+T800Fui3FPrsMU55hDdscXakXhBVdXJbEaHpMBQAjCpneul4fXUpDD2YG6h3IM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzswMdXzpgX+hB2sdP3+Acz6RXMJx1divg5UxbI0Y0o1vxGDB3s
	gDoHt/qBxcMr716evh40F1nnaX4aBFq3/Yk5YYWPb/pqb4nvp4bPjgxcWWHg3MMzyUr77jN6bbL
	t4Sy77mlZ/kZaNgL6jMHoqXdqWCxBlEcWW51l
X-Google-Smtp-Source: AGHT+IHZLsVFBntb4ie5BCSaC9k5XgL6WJ95PL3h2d88YHNjEAVk6k4mLN6m0hTM14TiBWmGbBTjOgx9IbngPPnogU4=
X-Received: by 2002:a17:906:dac5:b0:a9a:67aa:31f5 with SMTP id
 a640c23a62f3a-a9ee747a42cmr46309166b.10.1730975143770; Thu, 07 Nov 2024
 02:25:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105100647.117346-1-chia-yu.chang@nokia-bell-labs.com> <20241105100647.117346-6-chia-yu.chang@nokia-bell-labs.com>
In-Reply-To: <20241105100647.117346-6-chia-yu.chang@nokia-bell-labs.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 7 Nov 2024 11:25:32 +0100
Message-ID: <CANn89iJzF+NPX6NS3gbMCw1dUd3KB1Eo-GqhaAdfQb3meXLA8w@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 05/13] tcp: reorganize SYN ECN code
To: chia-yu.chang@nokia-bell-labs.com
Cc: netdev@vger.kernel.org, dsahern@gmail.com, davem@davemloft.net, 
	dsahern@kernel.org, pabeni@redhat.com, joel.granados@kernel.org, 
	kuba@kernel.org, andrew+netdev@lunn.ch, horms@kernel.org, pablo@netfilter.org, 
	kadlec@netfilter.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	ij@kernel.org, ncardwell@google.com, koen.de_schepper@nokia-bell-labs.com, 
	g.white@cablelabs.com, ingemar.s.johansson@ericsson.com, 
	mirja.kuehlewind@ericsson.com, cheshire@apple.com, rs.ietf@gmx.at, 
	Jason_Livingood@comcast.com, vidhi_goel@apple.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 5, 2024 at 11:07=E2=80=AFAM <chia-yu.chang@nokia-bell-labs.com>=
 wrote:
>
> From: Ilpo J=C3=A4rvinen <ij@kernel.org>
>
> Prepare for AccECN that needs to have access here on IP ECN
> field value which is only available after INET_ECN_xmit().
>
> No functional changes.
>
> Signed-off-by: Ilpo J=C3=A4rvinen <ij@kernel.org>
> Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>
