Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794915905;
	b=GIj++g+vpCbwjzKPeHWRy8ymt2kBVkJiPLyXCEYYMCql8ai7LJ4aRoOV8n2ZWp2B7iVX
	 5xRrLDiITMGADMQZFQdOUyIteaDeAAaXz+zA0YFjq9ujBGJFe16y9HaOso4OVHP8nV+B1
	 3ZCvRzgV3EmoMygMI/pVtOmnB/hG0RFQMZOYXfBosee1rIelQNycVbw2Dkbp+M3O/v8fH
	 I/EFCQqA0uqAvURpGEkvLL36C80uuofkuRvJ2P1vpDZWecZ8+7HFlUCpPa3Dq8GwU0/jS
	 6Hg2ilph3eyzE3WnXxVlU8HAL9t3sKNVd0As3vX4Zydk9Hk8wqjCBpeFdjBgO6uef2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794915905;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=EHTZ/1KUGWNJTaA44N1B6xy5DZM7ZoLUszGDdI/4cdo=;
	b=OsP4JzGG32UmyhgbhlnvzyKSWYnkoPKqyo/FAFVMkHDYNbK9okQ66ofLqLzEwW71oxeq
	 We7lbAJ4WSCLw4qCrkFzsOuv1GTUHlq8vfBOmRk69AdLlJynsr03DufrCUbLNAsgpwLG+
	 k3yNY5jvr6Q4Go0e1IZeoMlrO4d2J2WTPiTrxxqGB58JJCjLtofPBIThhCUCyQ4PBP6i7
	 aRWpreHrmDsBjq6me6TFQnBfzgRgjw1o9281w6nCIprsLftSP0RV/K84MTYM8L5jdBrYx
	 5VmMf3muBM+1ynjd4zYTnjz9JAl4iz5rE8G7eJrc3BuDNydC8kTr0dxHmuvQBdOvuSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VGiaafKL;
	arc=none smtp.remote-ip=209.85.214.179
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10523606A887
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 11:45:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10523606A887
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VGiaafKL
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2eb18f4da15so19578465ad.1
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 03:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794915904; x=1795520704; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EHTZ/1KUGWNJTaA44N1B6xy5DZM7ZoLUszGDdI/4cdo=;
        b=VGiaafKLm0Xdg+3FKaZmGIukFPRYRb0YRpgodlpQl332TOMfRYzBIo40kh43Y/yMpT
         GvI48PA2g646iMvr6fPnu2MJZ556ul+EKeH5SNIjMMw7FiPcalTQ14hpEgVkeF8qTDku
         fvBrp+hrjdWQJfpzei8N+dhaKgQiY+fyFdZuCBFZHR5Hfkf8cyrPPniI9Nv9j7yRuvVO
         9iJBKo2IWm4WNjIwGOp331BuCujIYFY+O3O7AYZ2geCUFwxTzJRC8KECDBoO8SQzuzBC
         ztDLnmG0FRlFDwZ8z5GxB2yRTws6BG31D1AWMbdNjuUURQXfxFaNRWudTvlqBG7YTDrw
         uM5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794915904; x=1795520704;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EHTZ/1KUGWNJTaA44N1B6xy5DZM7ZoLUszGDdI/4cdo=;
        b=iYUewfqgNo8UycR4IcnpCSKPSob09KH9jW1dkyXDCkj8AKo222w2KD3b6f3NVbqo48
         1o8a/cInrcmPS9ORM4CqqhLK/5AIst6G/ZD4GL/+g3Cp1d7SO/sK3aFyhl5crmZNi2oR
         DHdr6UhZecMH0/6n2fCIzeFcDzvbb3/3ZxExSeob4krBuWyo9WopFndkJ0W5LhjtyZp9
         OCX34wgSCY9TT+wKBYDOWJo2noLrcJnnsXA4uM5/kJFsycmB23RluNUKy+vdOjnz9VJJ
         JqJjwk3Kn+KMS4EerKNO644mD8OfYmDTG50p58OifJz5QaUYHOtUU9cJFoJi9SGDMrep
         0HDw==
X-Forwarded-Encrypted: i=1; AL+hErFy7zrISR4RCV9N923Cp48bNaCRAiTr21Pf7ErnDf4IC+C2YHj3UGnGs4A2zfc3Gy5W+VelQtHVPYtFAxX2SA8=@vger.kernel.org
X-Gm-Message-State: APuU4Z/potnJqVIzqR6UDh7mIKYV/uk/u4lOC5GYGS/nIHRv/sINdtoH
	0Mqq3kJGLxK2UhJvrp3SmDAdxHkIV6eF4Q4QFzu9FPn7n2L0Nn6HodzB
X-Gm-Gg: AZFdTZf8p8luL69tJ2qdRv/9TIFpZA4TB6Yqtfz0kDdgwtYjmTs2KpGcc30TzDLLOKa
	UDx88LqbpMoHQo/JsIPz54yt762SML+di3+ldBBtk6Sp3S9iGlRI9nkKYBsNqH+Se/wt6jGo/hC
	hOI2tmbIaq9c+vhw8/pNvtetU/rNbmahJAXAroFNvcpJwio0XgiqaxZqzIsIKZQ3nQhcyDBHX9H
	Ss7mHIy7x5+stiE5+xV0/bhN9EP1Enup2LzF+QblzdVZApdET3u0WrLpZnuAX6Lgb079jak4rHz
	X2e4Vu1EbTdFxjQ14bzqHcBtSBNLF4GttYi7TJoOt09syYffD8NVl5NwSLCztFjPBr6wksMPh8v
	7YwMNgRaP2n2VezIdW/b8JuOmS1zclgxu+S9rU95d3ZMe08Dty+zbd7Eisce1dNrHi8v3ZcmWAY
	TycJq1fpbU0ET2z/gHU1fNX85Kdt9BtQgXeI7FGJaXZlPNFh4YCaQJ+ZX8PqmQlqGGQ9RNchMB5
	B7k2+CT5E5Fsjxfm5m0Lia5z8ohhFSUEEX1DwyQvo1xWaqjZrgTE8PNODDUBAqFT1Ahj/v6TBqW
	6cW5UN4hqCrbcev8og6PawlhLfMbPy5+u7l/C7ioFlt/
X-Received: by 2002:a17:903:228c:b0:2e6:5ef:abe9 with SMTP id d9443c01a7336-2ee0dcd0c58mr112203625ad.37.1794915904206;
        Tue, 17 Nov 2026 03:45:04 -0800 (PST)
Received: from gmail.com ([116.162.234.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2efd7a1636csm13585765ad.17.2026.11.17.03.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 03:45:03 -0800 (PST)
From: Xue Boyang <fuchen.dust@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: kadlec@netfilter.org,
	fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	phil@nwl.cc,
	sunyiqixm@gmail.com,
	bsdhenrymartin@gmail.com
Subject: Re: [PATCH nf v4] netfilter: ipset: fix double free on kernel-side delete during resize
Date: Tue, 17 Nov 2026 05:44:51 -0600
Message-ID: <20261117114451.608829-1-fuchen.dust@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <avwswXiJh8HUPa5T@chamomile>
References: <20261117101018.523826-1-fuchen.dust@gmail.com> <avwswXiJh8HUPa5T@chamomile>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Thanks for the pointer. I had not taken that series into account when
preparing v4.

I have now looked through it. The rhashtable conversion removes the
ipset-specific table-copy resize path, so it appears to avoid this
double-free/UAF class at its root rather than fixing the individual
races in the old resize implementation.

I will run the reproducer and the related GC/dump tests against v10 and
report the results.

Since that series targets nf-next and is a fairly large conversion,
while this issue also affects existing and stable kernels, would you
prefer that I replace this v4 synchronization rework with a smaller
targeted fix for nf/stable, leaving the complete cleanup to the
rhashtable series?
