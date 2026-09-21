Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADFA3C5855
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 21:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790027055; cv=none; b=rs4rVNPSmIbzdM21hjXxH+cs5IN4UnIGdlOO14S6+CtDtuqFNg90N0RWj2s4N9LpFnoPaSI5fqsNAQAyYbOERKqTIHxdDfHK/ULygy3p4ZX4nwCfV0X2v02Me5GQ6ryU2cMShDcuexd5WRKsuOswY8vMTSHJ//eOAA+XNZ38p4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790027055; c=relaxed/simple;
	bh=ITSFGhBCgCYWwEXlvak+PK/ROh9aqcx9mXeYFcC0aJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjKhL0CjSKjWGWO+p/byFeONZ+l/YRZp6BidP8JaMwH3hwDt52L5DKN+tl43qUj/FG6SrtZc5g6L6Gyn94wmwxfEAxrVDYMwC+/wgHm9CdFoblIITjhfARiE2srEaJiJC1SLJngiumTUiVDD3LVpAWbSsQ0RlWkmav5mBEor1Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WexRML7w; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WexRML7w"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6350f89so2060813f8f.3
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 14:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790027052; x=1790631852; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ITSFGhBCgCYWwEXlvak+PK/ROh9aqcx9mXeYFcC0aJw=;
        b=WexRML7wNY9HYHVsSLgAdJ1X8hq8E9SbazwD/0JPQLRmJHuWJ2731Zpik7tOudgSOa
         G9juTmXT56C9FkAAZ8eESwPY8of6wjvVYqMKruOfiXF5yt29+ui3kaahHRldS6qbQmQJ
         UBzumqhrIJEYjckC38tUy8qRCvTpTkebtoo2koAPc0KlxXXACERqEHoNodtQiXHJx3IZ
         X5iNUM33fTgMrGkW4XIZ2tOMWtVtrGY+5lB3QxP6XjUTG5Dg4JZGj5Tngo9kqajI0jX6
         F0fbrX1JJYL/zCrnLaS3gjrsC5+MATlfb3ABcPwWKd5N3vOsYokY0J8WtAIvZm6UqaDW
         Qt8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790027052; x=1790631852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ITSFGhBCgCYWwEXlvak+PK/ROh9aqcx9mXeYFcC0aJw=;
        b=L+r5pSoL4TJw9HHL37kyHM9Cv0LcdkN6z4933k19PWeHGv/IMX1z9KJQeDo5zagqI7
         eUmAYbbK4A6VGcypUHPw07feBZhpDnziUzAAgc5FwEUT3NrX/k1cSsHSRxVgqdTFjOjB
         moicTXyK7BVHHeePbfft68Q6ELZW5OgyQieCeVkOAxKQoellwTkNlRb0IXofZnxh3VrK
         Dtj150DrVBYADMZfHNB3M4B8euJGaejKCtXdoqYILGufOa0y7p5u/mQjD4UHNYpiqZ+l
         pyPJNL4hTibzS4Lv0wd3i4ClBjacnvdXFQp9lgLzIlFEa7AjvI6a2KVpUBbUp2tr4oVY
         0MwQ==
X-Forwarded-Encrypted: i=1; AKwUvByg0NtYUgBvY/RdGwdY2HPQFuFsmVZoZwfBuiH41Pq9G4Hneo4mJ/7RFB8mkbLaCuD/8oT4zVXhT3kW5b/8b1c=@vger.kernel.org
X-Gm-Message-State: AFuF++muVLuh2N9kWXNicFFX54NrcwoOHonfrs2VGr5lYOC2MqAjqIey
	FCCDYA83Xklgb4l5mg+Hl5/qck+Q3HpLsKZAL4mzeIyC2J9zzTMkiVk4
X-Gm-Gg: AYBFou3RLInTBe+ECgHFrB5ZwUmxzPa6QI3SJIGO7WzYaD/XVuge0HrF2dVaycVJbTB
	yc5hlP3b4XmQZxwBWf2KcFNAB07fe7eCOu5HYUB1EcyWDa+9e95q+YiYx8wfzNc+WGi2PS/pC3w
	6JJqYyBH01suPDyeTBulm03CDsZEXEu3SQEAVZDC2RPMg9vQ2B3qRsVHV35vwfnlT3cAt5ViO5C
	sTc4XfjJ3YjeR8sc3ISg1k65dxE/ark3BZeKi2y6w6gcods9gBec4+sJ//4CSmTQt1o3Q7FlamQ
	rryQ7IReO0tSdeoqgSwgBfOAsTLZR8yrtX6Ugt6yIn/bnHTYvrzPYhSBX83Wr8RZoycdG66vbwY
	gzZcb2ZIhTW9D5Bg3vhQvXzJ7Rc3OdX333meMoXdsGjHWHnmhyGGmW8F7a2dd72931H/2j6k/K/
	ngiO3VTvADNtkgMzR6BCOEws9Bd5X3XS7llhidCD05fGberECesXQ9cSYm2+11jZE297yYFzg9b
	e4vR0dBqFe0/Cu0vyQ0DsDXgh+4NcqzbTSJRJ5toIy4Srug
X-Received: by 2002:a05:6000:2410:b0:486:f404:e833 with SMTP id ffacd0b85a97d-4871e363fd5mr17751590f8f.44.1790027052088;
        Mon, 21 Sep 2026 14:44:12 -0700 (PDT)
Received: from linus-personal-clanker ([102.164.100.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4886224427bsm447839f8f.8.2026.09.21.14.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 14:44:11 -0700 (PDT)
From: "David .B. Dull" <monderasdor@gmail.com>
To: adrianox@gmail.com
Cc: fw@strlen.de,
	horms@verge.net.au,
	ja@ssi.bg,
	linux-kernel@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH v5 nf-next 3/3] selftests: netfilter: ipvs: add per-service secure_tcp test (David Dull)
Date: Mon, 21 Sep 2026 23:44:05 +0200
Message-ID: <20260921214405.7003-1-monderasdor@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921213031.6160-1-monderasdor@gmail.com>
References: <20260921213031.6160-1-monderasdor@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Also to avoid misunderstanding. git added the signed-off line unintentionally. please ignore it.
