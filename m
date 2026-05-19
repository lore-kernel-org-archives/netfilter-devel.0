Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7569F3191D6
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 21:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779227110; cv=none; b=W901+z+tziqSaf8oImWUi/P7q+ucfjncDLeimOI3QGL+f0/uRoP1ZL/vjsXjBBH61qTBI8GHtp1Vu2ONc8+u1rVuEd9UeImazep6O4D13ZU4fX7U8ugCOyenJlUBB2RJJAspjrXBugFoqyISgnisBm5qeNc1S/JkKCZ0Imq5NXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779227110; c=relaxed/simple;
	bh=7kokTyk71LzE1A4AqSCZob4mFW1/ZtmAHEM9Po10Jms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNOlnI87h8b3sBhcycSjpKG9tKF0beP0+O9kYU/d7HuYolBPQ+SXtIszNyYluYuUHWvVTlI30HnAyq4GQa9P+moLQmgdwy25KVmCD/FR03c4u6P8WGETSnPxkFUf/QaxuN3O3dbyaeqtbqvs2B+eFsO9z8KbIiwUC0I5GXFJQ14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LQeJNqp6; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LQeJNqp6"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-45d96d21e82so2406052f8f.0
        for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 14:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779227108; x=1779831908; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7kokTyk71LzE1A4AqSCZob4mFW1/ZtmAHEM9Po10Jms=;
        b=LQeJNqp6SzxQtaMeXvKzzFM2mXmq8XMlTjX8VyyzftynRtfDL2kxh38Eb1M94iegsg
         gz4JYgpPJJyMiy1Zi2yxPv6Y0GoeYc6wUgQnGF9d0x0+P7IuPmC459fnNp4JWIHZ36ME
         W4IMLQbwnWVacwlbJoY1wFRwQBPkdtcbjPjVSb+msJ4t8Ub7abmIKoj0RTz6fR62GXCD
         CJd/+Gsmce/Q2STXX1AVXbgPTsE/uFuQWVmqRbs/ZYzrt9juD/usFznNBGpW+TY/myk2
         xylJFHLe2QRZ4RWsUuHPAFJI2IBZOHbcE04+X14B/kRLv936fehe5sJV1g6c8zEyeVv/
         rUKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779227108; x=1779831908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7kokTyk71LzE1A4AqSCZob4mFW1/ZtmAHEM9Po10Jms=;
        b=hX/KbCoakPBrHGMSbFQlCGRc+DJuFIUZqueFCjoAR6d7wxyzsK2GqoE7x8/rRP+8vm
         Fe4wowhEGg6ibo5V4oqQjKOjPTgT9zJU4Yb6D/Xn+Y4J0bFAYgdcKvi0XQUuoGmVEOlO
         jej+TeZpmtYkisbxZcJsr7W8HmcWFar6cBbCGmgiREeIHtMMlNsmC1rNcgmuDHIzBTmL
         x8nms0FeWskEbRRVmyK9a1klRN6z7M55KKVZC/+DiNy5xevXd/ISpCpu5zeqr/TjReKs
         2V7yJwV0zeeWyLervqlpQssvpFycDlRcgpdQarP8e4FRiB3wokv88dY5IEyhPnE2GaeO
         71iQ==
X-Forwarded-Encrypted: i=1; AFNElJ+Nk4UqU9yoUFflwMHaiCnuv19ETljDFKUXNKaxeMdOc7CLWtJ+iMWJ1fvqgIRb9+kHOk6e2pBtvOUhdp++SgU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTe9VGx338ZyER1IW9Hym1Gxvu/qkQUR7DaL2Iyvz4qN/NqSyW
	2QoLXOU8qdfJK0xHnTXKLFzhTKcfTLMxJGMUnG52Rx7QRbW7c7s4FkL3
X-Gm-Gg: Acq92OGdhIMG51LLEpCbDiKTpxdKo16oVgBa4zJsh2RhfVJuFCPBTAnBZhrzHyX7cKY
	Td6r+a+02WAX47fBdnOAYK0gfx1oSDoVc+l4IbZSQCtIwJC3X/MIzKkmECwIwhIejUackc9Y4f8
	MSaJz1Ck+wj40O566ZeKeDA3Z4GOVs0GYKfO+ka0Xz4WqW81gkz0P/WSawJMYEPp4QTNZsS8dzV
	AcMi53H6OluhcaDXLmpHX9KcVqkx4xWpPWF2hs6lEGqUvDFo0prY5aJU3pYl8ramr+9+7d1lTsv
	BuLNFP5ItKvGUHUiodnKDQf35o0v3MlR34RkNXWD9tMJWE0wHSsCtztWB5S3ZcnQoKs3ZUsihc8
	ExdIc3TquqhwdWke/EqvQwQnOWd8m0cozLEDd/5PB4o6sLfFlQxfEG8z/3Wp4fAGTOppg6iaSCV
	PBbKzoZA4LFn0MJl7+C0zA+zlnQdlhgK32DrIdKOu0XP5DyPfiiilkSjzpdZXXu1b/VPN+AFHsc
	g38dOQXqUZHMoOx5Hy1hZU=
X-Received: by 2002:a05:6000:2f83:b0:452:8286:86bf with SMTP id ffacd0b85a97d-45e5c58fe4fmr34127660f8f.1.1779227107783;
        Tue, 19 May 2026 14:45:07 -0700 (PDT)
Received: from node ([202.47.63.86])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45e6a135f0csm29797283f8f.27.2026.05.19.14.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 14:45:07 -0700 (PDT)
From: Muhammad Bilal <meatuni001@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Muhammad Bilal <meatuni001@gmail.com>
Subject: Re: [PATCH] netfilter: nf_conntrack_irc: fix parse_dcc() off-by-one OOB read
Date: Tue, 19 May 2026 17:43:51 -0400
Message-ID: <20260519214351.29908-1-meatuni001@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <agzWUpDy-32yvBcB@chamomile>
References: <20260519212328.28290-1-meatuni001@gmail.com> <agzWUpDy-32yvBcB@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, May 19, 2026 at 05:29:54PM +0200, Pablo Neira Ayuso wrote:
> Other helpers replaced simple_stroul() already which is probably the
> way to go.

I can send a follow-up patch replacing simple_strtoul() in parse_dcc()
once this lands in nf-next, if that works for you.

> This is nf-next material.

Understood.
