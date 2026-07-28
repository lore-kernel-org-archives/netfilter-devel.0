Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C5F44AB8D
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2026 20:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785269956; cv=none; b=MY7LhpxFMFOnXi2PffGqJ7/eEFKnwN7XReOGrz4zSJuVdJ1mMOqnkrdrLjYchpCqJ0R31SenaUhx1BSyoJwZF5V9gXgok4WlZCG/YEPk4gPHy2/jCCJqCdUMed1imDKCDZSTnZdb0uWxv6GUAYs0rs/V9Xiq4irLgJZdJYPYC/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785269956; c=relaxed/simple;
	bh=XPVOcbNOwIIazQVp7wO9TUAK43p5NaDgD7vZDjgy7dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eVYlP/ZNlv5CQBuoRThQXflYirjWRu75abva6ThzJsAkSbW6rlJFe6JpQvnDjk50Rht1lgRD3SYkTjfAqO9hE0qtf3CnoCb7/1tGG94ShvXwgFYIAVLAwqW8EnLeLuoY1unsSHbkSCHqSR7W6d6qfBKqpq/8kzDo04NCax6f45E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W1x7Sa+6; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W1x7Sa+6"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-ca2fad0ae38so117265a12.3
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2026 13:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785269954; x=1785874754; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=edUuAsnjZP6hLqLH2znVaVTCUZQYqEhJKYNnBmk42uM=;
        b=W1x7Sa+61IvjOOSWEhKvJ2PeRZ0Ma8+4vIxt4fhMkxtkG9yVYNrv9ScSyJ9Et3Wsjd
         tIfIvA7iSyejt6SUugaWOaP2ESJGacm0DkWd+/d0YzjimVncdKLygspsE6US0sjlQcDP
         0PFuJ8aHrT5zl0CQ+eSrHxDgf5Eln1Budu/Y5kt9QZbNg89WaA5YderZQG+mEjUSR4vp
         7598N3C1VkMyWhIMgS0j4RyAbVnpomT5frzZix/X6q66mmioq3uno5L6MO31b30kf9G+
         NHBi5KDsuql92q/JsYxusG6YMmQ+MFgjbUFLlzAVTLB+2cSFsd4u+bH9gPXNOve/XbhG
         HFEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785269954; x=1785874754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=edUuAsnjZP6hLqLH2znVaVTCUZQYqEhJKYNnBmk42uM=;
        b=JimA/Qp+1YkA0rYakyGwvww6r+HDmd0R5o6I+KnuB2eErtgnO7Vnb5hjVVWZ44qjBJ
         HiWpn/YR/kX44gZd3NbE7UryW39bIHJ3DSloSVIajx3UzqRJHdggEqjstT52mAipLOw2
         NmZGpd0KMG8RDE+UyXzMlLpchg8n3Npxcty46X8iby/9ZN3tfog2SUJS0ynalIHXdYlD
         +bxWBIg0fJ9Tn6PMlWQoQ1BS1bR18eF7ukxsTCHrFUq2o1nSxX7agJYlEK8nKsZYIeiQ
         Je/AZWZ+OQ5WfoSLbHqn/QdReQbal3xnuYQzPTFKPZRqRoSGQHzQixy9XpjAbH07Rb0c
         8vdQ==
X-Forwarded-Encrypted: i=1; AHgh+RrTCRfVsrJFdubHxruI6zPr+Nn011wSq+4gbkt93L8UPqsFjA6gMQLRezSqyQRHQCbr8B/89UWjsv4gHFh+aoY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAt+1uBI9nBQgKJ0y+4TiBqrvCYyq9F+kxB4jUf+5VxbR+0Hzw
	Dk4B2SrWr+VXQwzwarzh2silrsPVU7i1UQAFabBaC53T39hqnBI1sJDuA2xcTPC3ips=
X-Gm-Gg: AR+sD10zcQoJpmESWvM4uH9FlnTG/j5u3WHwCWJWDpfWH8HBSv8Yub1np/rny7kK5WM
	jObFkg9UriqUfadC0lDNY5bPx2Lcod46VtCk0nP7nBjUNWFuwUuGLWIxfyr2ef0jFcVZox9vD3g
	YoZ4FkLt5TrvW4GofzAOBgkLGnS6y1o8ica5ehuvN5hYZ2mKZIWlgQPsgDoEOcgYx6zqup5Fx8Q
	pqXY8/gBrDIJ6Tal1yCB2aB6dbYLFog/ZJrM0S4FZF4ZtJyodbPomXPG182AQZ1EBL4pQWb2rme
	bZ6BI5Zchn3KFQq3pGRaqROi8jAzSFKjkJy18pj3xSw8EAkDBIYchex64JK1f0AfXdneRmTJ/g1
	hojrPxllpmyFqzFbWjW8dYe5LZsbpXIawIFWi3eWatUlosWnDd48HbcOMTrMF79FEUrQo9m5Bw/
	xPvSgWlv7JNrx9uBP2DXNhGYbu+FbsDytZppDn5/4N93xI1usy
X-Received: by 2002:a05:6a21:a510:b0:3c4:46ca:334b with SMTP id adf61e73a8af0-3c8aaf7ce47mr4563881637.9.1785269954156;
        Tue, 28 Jul 2026 13:19:14 -0700 (PDT)
Received: from r912.tailbb6e1e.ts.net ([160.30.85.32])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e7271f010sm1812487c88.9.2026.07.28.13.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 13:19:13 -0700 (PDT)
From: Avinash Duduskar <avinash.duduskar@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] datatype: accept a numeric cgroupsv2 id on input
Date: Wed, 29 Jul 2026 01:49:09 +0530
Message-ID: <20260728201909.1773000-1-avinash.duduskar@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <amkAJuVZmpGy7pvY@chamomile>
References: <20260727082427.740789-1-avinash.duduskar@gmail.com> <amjWjTkt1Dsh66Xv@orbyte.nwl.cc> <amkAJuVZmpGy7pvY@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, Jul 28, 2026 at 09:16:54PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Jul 28, 2026 at 06:19:25PM +0200, Phil Sutter wrote:
> > So with nft printing non-existent cgroup names using PRIu64 and parsing
> > code still performs the path lookup first, what is all the fuss about
> > non-decimal number input?
>
> They claim they cannot delete entries via numeric value, it seems.

Correct, the earlier example proves it.

A typo'd id can collide with a live inode and then list as another
cgroup's path. Fine with dropping the checks if you prefer.

> > Is this AI output?

Yes. Point taken on the length.

> > Can't this just be something like (untested):
> > [...]

Yes. v2, keeping the two checks:

	if (stat(cgroupv2_path, &st) == 0) {
		ino = st.st_ino;
	} else if (isdigit((unsigned char)sym->identifier[0])) {
		char *end;

		errno = 0;
		ino = strtoull(sym->identifier, &end, 10);
		if (*end != '\0' || errno == ERANGE)
			return error(&sym->location, "invalid cgroupv2 id");
	} else {
		return error(&sym->location, "cgroupv2 path fails: %s",
			     strerror(errno));
	}

> > out=$($NFT -j list table t)
> > [...]
> > $NFT -j -f - <<< "$out"

Will do.

> > Hmm. Looks like we'll have to update all .json-nft files if we ever bump
> > json_schema_version. Maybe json_pretty should drop that array elem, we
> > merely keep asserting it exists and that could be done by a dedicated
> > shell test.

Can do that as a follow-up if wanted.

Avi
