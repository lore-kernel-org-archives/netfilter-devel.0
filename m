Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB903E3C50
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Aug 2026 21:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786741817; cv=none; b=NP8r+lTc5fD2rOHUSyrN9Ch/5F9ntkW6JxtkhC8CgK/zMHuTY32YergdzCvE4oSj8WpnnMvLk88RPHn4nXFZWxSHVVNXhsU0i75L0JH67tELXIjx9G7uT24tJSpH4TVsygKE++daDBOmOv4XMaZMkAUUIBl8S1pWRwF8rXNiAis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786741817; c=relaxed/simple;
	bh=8/7hGGnJL35aLPE8UStLuHGraHJHcIAKKRkE3zMeVTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TLcWlvkL6eD3AgXbOHgtfOjGJBfxBx3IfeaGGVxc2nT0V0akDK3QIaOWFAU5jctAaClFEPcre2PauNTn4pGc67xY0chChpNj8J9P+iCrxf5Yc0G7aJtieFFL7oIvMrfQLtaWZMu7PfluaZ0I3FStAXaYBvMNT5N9oJUSHdvIvBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cYMWdL+W; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cYMWdL+W"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c9cf07d2df6so920357a12.2
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Aug 2026 14:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786741814; x=1787346614; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8/7hGGnJL35aLPE8UStLuHGraHJHcIAKKRkE3zMeVTo=;
        b=cYMWdL+W644UaaXYX7vWiGtxFLBfZqzoSAC4Bo9/sjl4DIFttNuEk+jm1lRLdLyffL
         mfnwEG+vaiRfMSInxLjrjUYvMjboZAKA10aIPWUkpw6ckTypcgRB9/5qmKUzV01JTSZJ
         94t3FqeyG9gKr6iNR0z+fiQYv5R/DqNfg4uFrKIuicTg77zMkXsI0vVQU1S5LA8cIYfZ
         XhdE4n66rLAowBXmXj/+XhooUNnSkB/cmud5Y7f/5jGpI+Hn8kIQ+LbmQqjpssDG9HBv
         xyay46KJRiQZ6wLUvyQLk+SpaI//u0+4fdoLl7O4KZFUuNNT/sb+bSsVgHZ7WVpt8t0w
         AM8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786741814; x=1787346614;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8/7hGGnJL35aLPE8UStLuHGraHJHcIAKKRkE3zMeVTo=;
        b=bHSlH9GdBDcBcBoZcQ/XYR516O3mRxhFClE1ZyaYaHmBhR4pMBaZP+sAXzjkSTqASp
         fofbjk3Fu1qps8x9XVjklJhKSGr8wGWftWtTOQZIpD5OqWR5gCw+qoMxKqq0O600bwa9
         IX8jEQsvNwSdnl4+lwqN7vnypM568axtflfj9XrePcbZuf5dIR//Qb6RmueNTrFw9pU5
         gL4k2XfmlHyhN+Nt+2am7BHNYsKkso90BKKsGYstrLArkM4j5966qyuy070c2BJc7xHA
         VndII/ZRCtuvF+w+Co1yBUeyINJuU3ez64Ing1zU7q/ZbO7UKQ2Xx3LAZbEiN7EV9uad
         2pzQ==
X-Gm-Message-State: AOJu0YyTHXRVTFFY7wBTMi7Z4hYpRZGC/WaUCvS4gP9dD9vHKS6ykKJ9
	rohwEdOtOOmk/JzCq63TuIIh6SGSmtBaHEM3281IUlKgmAuTZnvnVF8RbqjJNQ==
X-Gm-Gg: AR+sD11bHRrB+HirZhUvnm9SPDjkkUjlMab2SPBwXjMl1q/8mlEaSrizXwRADVo6kNf
	zn7sBbhYGmZWhKGKkqZ4OGlXmshA/0iAL7mj7yEVm62fhsZSKmQHpzNsOIA2UYkncuzuBm0b1wN
	bA2knfmwQRgo6C8tKBufigXteap7TmWmgiyCYYeeLSyHzWuOd79Llv+B1VCWPAnoELoHmpVHidB
	sXw8l0aEBWr4cJoBway/EbFfbCSt0VmYUXtP2sRTcU2I46p6qtHTZgT/IWzHfvebnF42BkP6A3z
	NBEZiuHhgs0LWv8b3nw91YKTvDeHlsxRWvyDHP7qPnGc6YAVLvyiXgDesBg8LlsC8F736eKS8KJ
	VjqLDK46bi4TUKJYRD3bnwyP71DowBKIHQ03IPoTu+xu5S2WdTHN5bApmOVhMn3jvTPe0sTnEfg
	NZrzVmHUoAu649ZlPOQuSREDXeM6RQPgxAZqMXj42PqACSUSJLa/i1/biO9jZ90rlMOqN5n3X1H
	sY+pESy5D60dcLhLQahmOBolEYPy1TbS17BYSc=
X-Received: by 2002:a05:6a21:3398:b0:3c3:84a5:f2be with SMTP id adf61e73a8af0-3cc71a10b52mr8601632637.11.1786741813961;
        Fri, 14 Aug 2026 14:10:13 -0700 (PDT)
Received: from r912.tailbb6e1e.ts.net ([106.216.241.121])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-320d5bda546sm8538974eec.6.2026.08.14.14.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 14:10:13 -0700 (PDT)
From: Avinash Duduskar <avinash.duduskar@gmail.com>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] tests: shell: use an unassigned protocol number in exclusive_start_cond
Date: Sat, 15 Aug 2026 02:40:08 +0530
Message-ID: <20260814211008.2812836-1-avinash.duduskar@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <an2RzmRXZBV26Y03@orbyte.nwl.cc>
References: <20260808013327.2766739-1-avinash.duduskar@gmail.com> <an2RzmRXZBV26Y03@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On Thu, Aug 13, 2026 at 11:43:42AM +0200, Phil Sutter wrote:
> Instead of playing whack-a-mole, we should pass '--numeric-proto
> --stateless' to nft calls just like py test suite does. Let me submit
> patches for shell test suite so we have evidence for a discussion.

Your two patches fix it here: exclusive_start_cond passes on a stock
Arch /etc/protocols now, no legacy "ip" alias needed. Better than my
whack-a-mole, please drop my patch.

Thanks,
Avinash
