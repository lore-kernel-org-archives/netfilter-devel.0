Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B40A59B66
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2024 12:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707308277; cv=none; b=YBB2nmVA1BgNDZx7IEYRY4BDNnOhfj+yJ6eqUAXVGPOsc7vV001RCrxH6aRE8h6Ycmx16rLiZwvPIN7Hk4FVYKeOc+ip5VdZecUJ7u1S6d73EXcAN3M4bqEdowM+faBOh9DuLi1m9/KNKCzdhl5N4krspUEuLXQWsLqeJU5m3HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707308277; c=relaxed/simple;
	bh=TmRmyMzLdp2YmskWP/aR9FpT708Rv7UXoqw3qvUX1yY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=AlAjA0Uf31cPbfZt6GdGn8cevfsie/NfnKHOVTjYqhnU1vs1BTEZuP15iUUPx2S3yjtR57KloFw4eEqQ3j9UKi4iyGBTWMu2HWgnzfnZqtbljDKTiPH9/ob7XlXVPqB9s3K83HfDAjPYQN37PDADTDqQARibSjSsAmHumoBrZRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b=yZuTQunY; arc=none smtp.client-ip=209.85.219.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b="yZuTQunY"
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-dc236729a2bso511253276.0
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Feb 2024 04:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20230601.gappssmtp.com; s=20230601; t=1707308274; x=1707913074; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pSdkh+ng7Yeu68weliCQGWed6e78g0TdpBEq9N2FNbY=;
        b=yZuTQunYT5/6WPgHY4U/knbiWGap1c4W6lYM3+kgqzn3zCSlD9H4UmoghBHqKiCMO4
         kFqZ2O0kprzX6LLBxJCYb6IoXw0OPdsYaI7ojHeXK+2MMSCiiS+zDw62XxtWvD5QJqi9
         Ud4mFY7wPRIMSwpO9DdPfE65vtbRYyzZRPC2xBcJzeHpjNGLghluZHhyyL3gBzbAPijB
         NZwInr6U2JgVT3OwvsWZ+V8ugQZMFoppfV5l0jRsjpGK5nOGp+xGLr+mXPx4u+WmUJJG
         pXBdhvE9+ZVovy7/LaOP5dQuBpuwNIy7Ib1pvjfEEc1qc4XYgWRmH5Asb9rClnT4KKkL
         UUhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707308274; x=1707913074;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pSdkh+ng7Yeu68weliCQGWed6e78g0TdpBEq9N2FNbY=;
        b=Lmc6/BOtmNVNzd465hv2Bogtufy6FxfUxUOlsICHj1ExiducLFpy7X8qcWoZdhFdtQ
         KNZlkwXVekcBsfEnOkxfgut7wg6eVm2HKj0tgl58SFc0cJbtQsNXLmLXlw4J1tjOXtlg
         Q5hwYtC/xxSm5COP8uJZ1jT2KzWy8NMNFyUQUZhkcZGgCNssh+jZBAbrgE9YOJJ9VRzk
         Es7c/OoM8Tt+NmOON/5sw24rfh14cO103J1XMqyukMg/CgZlXhz2KuEUaGJGZhbKMdKz
         cplkcP/Buiu368ifIwFPOtufFc8DXFFbaz2CcMaHtRmKE8eokgRcrvO41kaT2y9PXXEh
         OhXA==
X-Gm-Message-State: AOJu0Yw9CNvDH3/d27UJNpn9dI1/KH4R7j88HNcyU2wMs5EEkA744xl3
	FAZHKbSXuEChxyw9Qqh42kUyEKKoSrzlPdxcuBaY+KrTV2BNdirICVdNSv788O/8UqIDXJdnaz0
	OWaRvYXFcgW0j6K2ufQYYdNMatJ1JVOdXSiWL
X-Google-Smtp-Source: AGHT+IGomE1piNDlMKWQLJkfkkV5OEDncqJpPADNjfGpeZGIhrHl1O7OlVsG3bzGMYGNK6X5gYHVKU+jDi4MJ6VDMt8=
X-Received: by 2002:a5b:646:0:b0:dbd:987d:2491 with SMTP id
 o6-20020a5b0646000000b00dbd987d2491mr4044248ybq.58.1707308274470; Wed, 07 Feb
 2024 04:17:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Wed, 7 Feb 2024 07:17:43 -0500
Message-ID: <CAM0EoMmZSB6CyA0ghz8QL6iGrrAi5FFDLMU8uzPPSW3U8n=Yfg@mail.gmail.com>
Subject: 0x18: Dates And Location for upcoming conference
To: people <people@netdevconf.info>
Cc: Linux Kernel Network Developers <netdev@vger.kernel.org>, Christie Geldart <christie@ambedia.com>, 
	Kimberley Jeffries <kimberleyjeffries@gmail.com>, lwn@lwn.net, 
	Lael Santos <lael.santos@expertisesolutions.com.br>, 
	Felipe Magno de Almeida <felipe@expertise.dev>, linux-wireless <linux-wireless@vger.kernel.org>, 
	"board@netdevconf.org" <board@netdevconf.info>, netfilter-devel@vger.kernel.org, 
	lartc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

This is a pre-announcement on behalf of the NetDev Society so folks
can plan travel etc.

Netdev conf 0x18 is going to be a hybrid conference.  We will be
updating you with more details in the near future on the exact
coordinates. Either watch https://netdevconf.info/0x18/ or join
people@ mailing list[1] for more frequent updates.

Date : July 15, 2024
Location : Silicon Valley, .ca.us

Be ready to share your work with the community. CFS coming soon.

sincerely,
Netdev Society Board:
Roopa Prabhu, Shrijeet Mukherjee, Tom Herbert, Jamal Hadi Salim

[1] https://lists.netdevconf.info/postorius/lists/people.netdevconf.info/
