Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBC526B0AE
	for <netfilter-devel@vger.kernel.org>; Sat,  4 Oct 2025 09:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759570721; cv=none; b=fksx35pYr8U/7o3Tpar0VBzWHG+2no21NOGQvf7znb8zpFR+87H6TwmSb7XHmTrmm9KhjX5xxe4jMOf6PR2Upg9rTUejvG3+i42izjxr4iVVjqaKLxoJlsnBCvSQVYJNDO5x9oMo6UaNw6FMtNIKI/ShuVR8O7NdVe5jCrvNkKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759570721; c=relaxed/simple;
	bh=kyBhUKjFFdJT27UW7Ah+fZSE+3MHnKn/GRMZG57ZZFY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t+hpAJViSIZdx9C+qvT5mQgE5HDM6ERnwZyDa33DfZi+Ko10kN3vAd6I0OuD2qvFD3U4wOxzsZXIIEemrjXcSN+XidlKwuOnSiFUmVgHB/7RcTGGjoLecIstA+H1N50un+cYJhMVJtTDrS26AD1wftVC17uDk9BPJyr4NK6ZiKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eRasUco5; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eRasUco5"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-57edfeaa05aso3844511e87.0
        for <netfilter-devel@vger.kernel.org>; Sat, 04 Oct 2025 02:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759570717; x=1760175517; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4oNbWBDakTv2tBd1Z0xP905T3lanmD3ykRCfmX2PL/c=;
        b=eRasUco5l7/73qhp9DpyQj2iR93OyAGy+whuJ8P6fz1T6YqAZdqHN8vZwWAF/IwEt/
         DIxGLNn9uQ1eRh4cbxQfQVNFBG9ojWDwNBRZd4u2k9EFVxSVloDCnMzwEdG9gdXqwAc2
         tQun/RsSVVprcwg2mwUzn/HNMslQUScLLxSClPB6UhjXFcix51KYsBQ1PIotu182hPcS
         KqrMlxwZs8k6OQkmZzSqUPrp8i3Tn5ZcOZJtS2htQ4524Yr5RobttCUtF/xRtyxRE181
         6iFX1MTKvWWjMzhDhssotXc9o1rpSFdv1AaIHIw/fr95/QiJcRgP0pHgNuNLEWSs+ou3
         YC9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759570717; x=1760175517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4oNbWBDakTv2tBd1Z0xP905T3lanmD3ykRCfmX2PL/c=;
        b=hRVow18PElVaNiUTPK+q3ZtqBrqjK/V3tkiecl/PAmPbw/aC68Uc9ChtLc6p7JIziR
         gLW2IiBBKkzoX2qTlHZppQ7qB37ZL8vfIRwqkVtFNJIs0AConBXbvd4W9S7lSfRsi5tl
         9+sYKFZyu1PYdRhKrAu6Ughlbi/1YVFg86uvLC2bAUp87y9z24Ln8cGxJt7xEn9lIEOD
         W7FGUfWRKISabewDE8j0l8vliH52cU0drhaTOlocN5Gea2Z5Q7jfDIyBXry+x1l56jEz
         VdvTVdvuXo/qHGiGNorqj81pwZioGlMr+vefTO5cDrz6ZHTcH02Vb4qOOseLGJWYzeQT
         dKLw==
X-Gm-Message-State: AOJu0YyZQD552yDWIiIM4/VeIu0QP+6lETr+NZ/g3GU1S1/HlV3SlP09
	SloSErlwGMrZkNUA68zXgZAfhNdxXxgIDUN4wtkchQutLCxMkP9XMBHLPzkXNlD4YcfslA==
X-Gm-Gg: ASbGncvfer4lPK+IJH8P3hHaDeu0FiMvfT2zvfHPebNfF23x9eSD8b87HHzqNN0hzDR
	cg9JI30TNKX/jB86+YCawD99QhbKa9isq7+dxPg/bwPXq0lcMJjZ9wBbvACvAry2jF68SkmVz+N
	89OgA3coitqrxXZnWrafCDM0SlKty4Sw8/ppMMUZ0RxGZsEwflDxSGdgo9mepags+KR7pQfsC3K
	CcOTwxo4H1QZJx48aWcvWisJE5m8L9DLtpBYn1u/onVYLHipwD0DumO6Z9j3bjeFfPzHVWEthjo
	HWX0tH+EZwssJxHqw7vFiFwbfWWB0UqTGJp9/oUvvyE1pjtgybg5zB5Nqh4xwYdKZk+/huvU/sn
	nOZo7XjIgJoxu/I7QTvp32Lc4+joa/d8AH6J+Mpr453ZSj2uZO04XMb6nw1Xgz9EjlOKwlY7yXh
	QluVmeTyxDegtCpEEc10k2bsV6akMO
X-Google-Smtp-Source: AGHT+IGb8WgLY+8iqXWh9OEDj/4h8EUxFr6R6RRpLeduSoLGf6hcoFoSSxh3NywFdXPL8zyRTj7d6w==
X-Received: by 2002:a05:6512:3f14:b0:55f:3e82:9c7f with SMTP id 2adb3069b0e04-58cbc7763c1mr1870583e87.51.1759570716984;
        Sat, 04 Oct 2025 02:38:36 -0700 (PDT)
Received: from pop-os.. ([2a02:2121:347:bd74:5730:2ad2:716a:41f])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58b0118d21csm2689953e87.86.2025.10.04.02.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Oct 2025 02:38:35 -0700 (PDT)
From: Nikolaos Gkarlis <nickgarlis@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	fmancera@suse.de,
	Nikolaos Gkarlis <nickgarlis@gmail.com>
Subject: [PATCH v2 0/2] always ACK batch end if requested
Date: Sat,  4 Oct 2025 11:38:01 +0200
Message-Id: <20251004093801.242220-1-nickgarlis@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <0adc0cbc-bf68-4b6a-a91a-6ec06af46c2e@suse.de>
References: <0adc0cbc-bf68-4b6a-a91a-6ec06af46c2e@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi again,

Apologies for the delay. I have now added an nfnetlink selftest as
suggested by Florian, and committed Fernando's suggestion to also
check for the status. I have confirmed that the test fails on
kernels > 6.10 that do not include Fernando's 09efbac953f6 fix.
The test could be made more extensive, but I think this is a good
starting point. Let me know what you think.

This is a resend to fix threading. Sorry about that.


Nikolaos Gkarlis (2):
  netfilter: nfnetlink: always ACK batch end if requested
  selftests: netfilter: add nfnetlink ACK handling tests

 net/netfilter/nfnetlink.c                     |   5 +
 .../testing/selftests/net/netfilter/Makefile  |   3 +
 .../selftests/net/netfilter/nfnetlink.c       | 424 ++++++++++++++++++
 .../selftests/net/netfilter/nfnetlink.sh      |  11 +
 4 files changed, 443 insertions(+)
 create mode 100644 tools/testing/selftests/net/netfilter/nfnetlink.c
 create mode 100755 tools/testing/selftests/net/netfilter/nfnetlink.sh

-- 
2.34.1

