Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072B1208978
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jan 2025 22:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736547656; cv=none; b=rRM+/vhbQ1MbormbYutS2QoO3iaBkYGl3UDR2HcFiD+hd1srOw3ARh6AOnFZ84O3UOfc/UHe6H0W8UcEVECLw/qlvP12w2oEC4UrwNltftb0Wxhz3ElFsHTcVKTlMqV84Kz0iZiuTJFMPwicQVZJvM0//8GcGPi3RBp5FW+SZx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736547656; c=relaxed/simple;
	bh=P9MFuxDmHg2c1un+TczCnOBEzGtbxnQAe9gvqqjJgDU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=NKP7r0pZH6UK4KCBprdsh/UYGnVqWcQDVWQk23XuLK4M4f5M3wfludXiyMEe6qOoy6W9is/stUMaqA1w7dOXIm6foGdOXWU6Ytue0AaqO0r9jd4KqyrmT16OGYkv2hQcuZsuG+KDuc4bCzE/VgmBbwjRLv2fz0ljxZTA2t6jZW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EO9Y/MF7; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EO9Y/MF7"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-aa684b6d9c7so455594366b.2
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Jan 2025 14:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736547653; x=1737152453; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=S/FRGL7pFqiBxXNMKE7s0klBHrsVAiY19xXP9JBQfqE=;
        b=EO9Y/MF7ElXkk/8VsVlN0fCNX/BsMuC+t0CXI4fh8UceFTXTpvFg/TYjIYxRNjhQIW
         0ANXo59pfQS1F1YZ7Y5cipD1r4wcjtsKxG2Fwjqsg1f/7IoVmyWiTQYhg5sGGf41iwC3
         jUSb7EWZ9gVeICR8u+EewlMTUHuSyvU+CG1OXrVKlVnobJWg0aVJH/8XqzK/feJhZGkt
         wdJB5CgmFKRJhgQSTwGvj2d8GlKMTNJb+7ln+ZfAUTAN9sMLu0bP93AnVB2OgwQDq0ox
         FxRr8CmIZMurzsQy6lW6diS9KefC2Sv7ITewxulkG72ZPdufhGhE90ORQh/kVYXBkfkB
         r+Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736547653; x=1737152453;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S/FRGL7pFqiBxXNMKE7s0klBHrsVAiY19xXP9JBQfqE=;
        b=bEBMLQrdm372LiaPb6Y+FrzbkynA/0lVoCP1RMu4N29F1Qr4quAmofQ6MKIsUmYc9Y
         kFnAiEMZ79OOTmqBOBv+k6q8X1iyhokeIdGgsj7UsXnImoaTOpHLr6QJvqi6sN8GpB1h
         VyWEZbmtxtu28SNvGtIQff4D53+h6htjHlw5lF5Lw7D4D3lOnhFzms8CtXBZf0rRwv/X
         6sWeGHM3yYjCZhbF00DYDT27VOV+JZk7V9ILifquEXcYC50rv4Wov7zMtoDAedH9zGBc
         wBEWZEkl5dleJf28ciicZD/h5H+xsORKL0N+C/W6Ct4dTbGiIhrnsic7ec6/tGCWlFy9
         6c9w==
X-Gm-Message-State: AOJu0YzbeeaILvbY4hDdMgG5K/U+XEYGgHf7MijYh0w9zSrJeTRip5D9
	88FTOJ0ZSHOxUuw+k4aydIbBR3rS8HIx+8pRxQMTHO0QYLv9FNCjoSXW52wWeSgXfXO04QGKNjn
	bgDycdaBJZeFgCL0k/C4RA4HfRlyPFhUl
X-Gm-Gg: ASbGnctl2IaLqiWM9QdOJryGdR4GrYpJW6QXguKRlLEjD4Jjb/hBMaVWnLlLe9wbb2n
	jRIK1DDDjhIxs+DNhAj9Bi2tr1sboXvEh/Jeyb4ZuZRD+FTzRTFeSwa8NrhfP7QjBmx7NW01h
X-Google-Smtp-Source: AGHT+IEJSLkrS/GxVsORlSeEaNxE0mIM0VKxwxYqpzmY9GWA2m7DpkZE+wCJCRVeWttjFYn5a8bELkkXJjbjrW20p9g=
X-Received: by 2002:a17:907:6d12:b0:aa6:950c:ae18 with SMTP id
 a640c23a62f3a-ab2ab6b5406mr942508466b.22.1736547652313; Fri, 10 Jan 2025
 14:20:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date: Fri, 10 Jan 2025 14:20:41 -0800
X-Gm-Features: AbW1kvbjg-eQzeJnjI212_hqguV6RVMO_FnKNf-1ATp3b_Xn7SIMI4fK6C_2NSI
Message-ID: <CAHo-OozVuh4wbTHLxM2Y2+qgQqHTwcmhAfeFOM9W8thqzz6gdg@mail.gmail.com>
Subject: Android boot failure with 6.12
To: Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>, 
	Pablo Neira Ayuso <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"

We've had to:
  Revert "netfilter: xtables: avoid NFPROTO_UNSPEC where needed"
  https://android-review.googlesource.com/c/kernel/common/+/3305935/2

It seems the failure is (probably related to):
...
E IptablesRestoreController: -A bw_INPUT -j MARK --or-mark 0x100000
...
E IptablesRestoreController: -------  ERROR -------
E IptablesRestoreController: Warning: Extension MARK revision 0 not
supported, missing kernel module?
E IptablesRestoreController: ip6tables-restore v1.8.10 (legacy): MARK
target: kernel too old for --or-mark
E IptablesRestoreController: Error occurred at line: 27

But, I don't see an obvious bug in the CL we had to revert...
