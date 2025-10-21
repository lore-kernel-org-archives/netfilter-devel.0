Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A17E2F0C6A
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Oct 2025 10:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761043235; cv=none; b=QT5KoA3q5K7smqq3gwnsEMLYqkEC6HzBDowB3AdF7PuNOgz/UAD0raPj5+BTkG/M4sh7rhH4sSxLP/0u97zmNLE9TVaDh7KsBIfdkAj6GBTZPUhzUZw5dguMzpvpsagAaW0LTCcv6QbY1Tpol2zdKTcaWUR6eLJAB0XEZCkB+Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761043235; c=relaxed/simple;
	bh=8F1NOrVgd9uu+4AuRJ6uLDhYScA380u03Wgpa6J6fAA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OhOES5whgNBY5m+ZIvNeI7mGpHHx2RsLBLQFmga3LZiihPH7pwy9LhIyRiMVpN8gCx1ca7mu/htm6prHL3AHb+8MLTzhfq9uietTO2eFX+DF+vc0pB/S7QK7at5nXfSjsPC/MjAm1HzUxDBq5W9939/23SMOl4b5heAdtDD4b50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xmrxtuVg; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xmrxtuVg"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-46e6ba26c50so35163535e9.2
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Oct 2025 03:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761043231; x=1761648031; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8F1NOrVgd9uu+4AuRJ6uLDhYScA380u03Wgpa6J6fAA=;
        b=xmrxtuVgdvMlBObUrSFvsGVa6cfOZS/lRKhMyQQjPMhxb+sgm++dXcPYwegOq4jFHl
         Ia5tVOZx48L6EqeslmQFjKK5JqmcW6ZENx4o8ydBAUMpHGLn8kAWuTptlJBcUUqHx/tr
         N4IJXO1muJRv508vePodIWJrL978EI41wD9yFUQcWXW5SpftX05bs9t9mteaC/vznlo0
         K96C98kFQXMgCa6UOqIU6eDwERBpraMJawxdIVKuo31A64RO1MQePnzTyX/QFX/1tBDc
         OAwCibaRIAiE5eS/2/luLrOLvgLAG8JqPlxnFk8ltU4Wt94H7tJrey/wurCw58R9oyDE
         v/LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761043231; x=1761648031;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8F1NOrVgd9uu+4AuRJ6uLDhYScA380u03Wgpa6J6fAA=;
        b=E08z1SQYEku3oozlo+s4GZaahFlWxt1a3EnUYzDa7S8NeImWPckfrnkt70B6W3LFH6
         xWG4UFZsdVohC3bb5gn1uHUU2FcJeakzIrJfL6cAvfO+B/vYdrZfAbe3oU8XWYX9Tl9u
         iysO40HejkEqZuYRX/iJJttCRgcxGg5NGGd5RYhzN6puQBMRbbpDKM4Lad6smEAiBj6K
         ucT7hasKrzbtEcuO0z6BgymwS/Z8ld7ZemL+b7il1c5BK9ZHFZl6IxDU3JjsO5kj5q2j
         w8CjgPQI+zSK96HgRiazRE/VpWHyKHK7NqCPy9+7LU/WPsiaLRo52IdLjSULx1op/0nm
         5IaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxhKWnkyqNBmUjLuglcmtNj9JvbJ3XmxHUaSXY9z3M0eKDVyb+eWP28Zh+Nmoicw1CLf6aktDC1T4SOE9jHnE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDRQ3HrkrppgBYw0uCqGEMOfJHT2YPNY60L96NLDuwd6IZozGs
	kuQau+m7pd+5msxig+K6MuPBXiTPUrbiXLTPytEVX2xfb5SP4vaQ9VJCKJX2YUlSvWG5HN2IDEJ
	SmzyIP9feQV0QPLZb4/iUBEVXPkJlMVa4Yq7SXjvb
X-Gm-Gg: ASbGncsHbjnh2RBwWkqTCDrJZ5QkRL041g4uM0CoDloc81WWy7id3h96ClOYI0hwmE1
	o+b3NPtipo0q1VJjb1PfeYgGkMuGT8+enyvVxeLTYloB99Pr95SW3taJzLdM9m7JbIIVLrhZkGg
	UBbOuvj6KwadGw/Ehz/p3l1/DeAXei8nV282mR0TWZtvVbszcV88y5XP2tCICOA1uZS/8lwKSjn
	sBnoMu2d86wwXQnoBsVVY6vCIDJ0EKRHH2TvX/2cdl9r00RQh8jkLH6BLU=
X-Google-Smtp-Source: AGHT+IFba7yBjvzP7XBZzAYCLOpuzTGFirL8kQ4AF14fIIPFRTJ08aUIJxjN0LAo2BmZokuTftwqpXui5UEbRahHhfI=
X-Received: by 2002:a05:600c:870b:b0:471:9da:5252 with SMTP id
 5b1f17b1804b1-47117919c1cmr128383995e9.29.1761043231285; Tue, 21 Oct 2025
 03:40:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251020200805.298670-1-aojea@google.com> <aPah2y2pdhIjwHBU@strlen.de>
 <CAAdXToT14bjkvCrP=tG4V4XJhhyGMfuJz+FdfTO+xJ10Z-RezA@mail.gmail.com> <aPay1RM9jdkEnPbM@strlen.de>
In-Reply-To: <aPay1RM9jdkEnPbM@strlen.de>
From: Antonio Ojea <aojea@google.com>
Date: Tue, 21 Oct 2025 12:40:20 +0200
X-Gm-Features: AS18NWDu6TPe3gBJM_zhH5qNkxNBGNP2jWfrsrdsWhEERxbDv8C5J7KXs4GRZuw
Message-ID: <CAAdXToQs8wPYyf=GEnNnmGXVTHQM0bkDfHGqVbLhber04AyM_w@mail.gmail.com>
Subject: Re: [PATCH] selftests: nft_queue: conntrack expiration requeue
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Eric Dumazet <edumazet@google.com>, 
	netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

>
> Or, set/clear the label from the nfqueue program itself when setting accept
> verdict (via nested NFQA_CT + CTA_MARK/LABELS).
>
> Same with connmark, but I know that this might be impossible
> due to those being used for policy routing etc.
>

This works pretty good, and is really neat

ct mark 0x66000000 ct state established,related accept
queue flags bypass to 98

So I just need to set the mark/label on the verdict and clear the mark
or the label via netlink and it gets requeued.

I can make it work with connmark very easily but labels seem a better
fit because they allow me to set different values and avoid
compatibility issues.
However, I'm not able to make this work with labels, I do not know if
it is a problem on my side, I'm not able to use the userspace
conntrack tool too.
I think I'm setting the label correctly but the output of conntrack -L
or conntrack -L -o labels do not show anything.
If I try to set the label manually it also fails with ENOSPC

conntrack -U -d 10.244.2.2 --label-add net
conntrack v1.4.8 (conntrack-tools): Operation failed: No space left on device
