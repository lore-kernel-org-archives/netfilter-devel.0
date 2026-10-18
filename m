Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB763309EF2
	for <netfilter-devel@vger.kernel.org>; Sun, 18 Oct 2026 01:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792288481; cv=none; b=J0H93kwxngVv3awo0U1pUBcrRSCLpJaYCdw3ukW5cvDQ4wNCLjZuAvfn0sLk9sy+CCIHi0AXp3AZBJrQlkWt5P7NsCJNIe/klVYNzf/oGu3j6EWY2xr1FceYbqA5Cns5ribMVJpANKle5BwRTSqjIIMh1jgBuz3zK4PogNsKrC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792288481; c=relaxed/simple;
	bh=ESeD/ZAXmJY59zUgjORmhYeio5Kr8jPgw7HiOlqo0ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hOvXpyghOGU7uYMSJNq/pGHD4DEhmnYtd70bZ2DwHkZeb2Hd1Sz/cA98Sbg/ID6EtzjWIWAzZx31XFdUmnnux4aUA+ZAdHVL+u+be0NUCX0W5N3zBegJqTBlz+GplpYkZvHVdU3sSj1j+YPMXzucGjtk5E6TaDN8wUI1FY2RnsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=oYD8KUe6; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="oYD8KUe6"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6afbc363efeso1582218a12.3
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Oct 2026 18:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792288478; x=1792893278; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ng0CE/gjPTE+OIlSfddS/+J7PTYfSFF20bemZKRWDt4=;
        b=oYD8KUe6KJDoXciAtxuF/6+4gh+2ihWLWkPCqNHeBC0g38HGRiWAp3veyWmM+0k1aA
         e7Dqrg+3Nl4QkrxKUO8UxpC8W6soE9RBKhiiLhkPM4GNfJ+1HL4MEJ41LcdE7htHlBKp
         rktxdzaA1KxUQIAvhlL8POMB+VmeYe1xmz8nfXOZlK+l3IZ72Hn+FnHKG07rTn492k9E
         GI85GZNpfGVQ+wvxkk3R2zvQFxVOAPV2YrgZ8aTHapDIcs/ziNzzKVWlXnxX5jFfz+G/
         ltVo2QAJ+ZWzAnSQB0cnZk0JQrvHfuwcZ/k2j6d44VieDtd31Imp4wsJastg7gCgHpq8
         CZ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792288478; x=1792893278;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ng0CE/gjPTE+OIlSfddS/+J7PTYfSFF20bemZKRWDt4=;
        b=SnM5oDe3sVurOAyLQ917sjvmZLcxdjqa55ZD0UYKswVIfmFLMyBh/AVgppVRInA9OZ
         MDjD8SlNtZ4upjqS/FLaEsemFeqOu2H+bEHeB6bxI3CpvsqCSGleMRLDbwFAE4VNOCrj
         jL7h9BE4tkvhs4Bk94IBuHpW0TyTmwJc86EFFcP7Tub8zyfHKrvu8RJFU6oIDwnqa/Eg
         +LUMJSx/8AP8H2e14gb0jVh15UVFmbsfpqq+3XuZ1pEDb+fXp1INFuAmMS2bZEJl/lOi
         pn6h8CjYQgROctZ2DMQGlwKKx1vbze7PX4AdOtcYCebbX2NQLe4UBb2BZmkw1p30W+3+
         mkXg==
X-Gm-Message-State: AFq9FYImtzAgDlD8CrmcOi+JGqfwoU0q1I4gN41bCMAg4WS/Wl6ThLON
	Hh3vnp/r+ygRLJBazUj8BFSZJpqORA0wp/X8TW1Z3ggD7CT0GLwCr7iMaa8AAaSuSA==
X-Gm-Gg: AYBFou1QPzJ5k6w3AbMAryJDtOURvoMxGz+p2jM2ppbC3KSHUI3yvNqdHUjmVJ5kKq9
	iXZIPuoT0iT6teoJNfozte2Ki2fsoev3O8lu99TFMNC33LYCBSHWxVzE+vGs5h6LK1l9gY77/en
	S+QnSzjxW1vujXzQuPlezcQCh4Sy6eq0nRac3aFiXfSUo9fR4iCJrAXBhu61cELX14NMcXp+Ryh
	jiLx8pITZo9Fia9wybGvluADmlPTXoGjOjpjmVXZZdYAZeV+DGKXIKARWnPLo5DCTftLBuc1LNw
	p5R6wp7/zpGyAOTf8cvNr+C9mT7teJRSFNlMwDOtQL+mdja4VTR4rHFFxMCPxHPYxUnzqzYluy2
	6WRKToRSLi8yTfgVtTr5AsGgYgyo/xsrLOjGNtGlHarafgjKfIOD6CwNkBiRsZvfTl8eFUdbWEy
	9U7tymXIne1sNAYD+IMA/4QyuiIxjKW6ek80Rx3BiQq/gFkmx1dafl9Xc1bMfcr6DaI4o2mAg0Z
	CP/sLnPP0AgJk+WrEF3OuxGHjeF5eW/pHWib4bGBmQVblr8tO39xKnBPYVMUUtBjnUIQ0evgtHN
	SipcdDcjxN9JUD5nPy47fDo/2kOwv+p8Zrijj9+lLLQRRhJenQNs6ZfLliCRS8DiE9WhzQv/DnA
	XhVY8KpQWDNLH1Bpz1OI4Vgj2yTZnVelqSJQJy8YmNgE1OMgBIkBCYdoa8dYIJKrFfFXZOGxUh1
	kYK2KAr063Viv+1MrNxGKI6aiAidaIo7Qj/ObfeKQrO5RnN63127tTSit3h5rNlBISgQLltS+kX
	VQ8PgNc
X-Received: by 2002:a05:6402:2350:b0:6b1:d8fe:52c0 with SMTP id 4fb4d7f45d1cf-6b3a81c05a3mr2284727a12.33.1792288478126;
        Sat, 17 Oct 2026 18:54:38 -0700 (PDT)
Received: from Desktop.fritz.box (p200300f247424f103187cc9af620d661.dip0.t-ipconnect.de. [2003:f2:4742:4f10:3187:cc9a:f620:d661])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b38a1c7ff2sm2390429a12.19.2026.10.17.18.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 18:54:37 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	geldot@protonmail.com,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH nf-next v2 0/4] netfilter: offload a TCP flow whose reply is never seen
Date: Sun, 18 Oct 2026 03:54:34 +0200
Message-ID: <20261018015434.3326758-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261004171628.3544978-1-julius@bairaktaris.de>
References: <20261004171628.3544978-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, Oct 18, 2026 at 03:42:58AM +0200, Pablo Neira Ayuso wrote:
> This series are a no-go in this approach.

Understood, I drop it.

> Please, given we are discussing one series of you quite recently...
> let's handle one thing at a time.

Agreed, the fdb series first.

Some context on why there are so many: they all come from the OpenWrt
PR that adds flowtable offload for the Qualcomm IPQ807x PPE:

  https://github.com/openwrt/openwrt/pull/24806

That PR carries the kernel changes it needs as patches. I am sending
them upstream so that OpenWrt can carry backports instead of local
patches.

I know the rule that there must be an in-tree user. The PPE driver is
not upstream, so I only send changes that stand on their own: fixes to
the software path, or features that existing drivers like airoha and
mtk use.

Julius
