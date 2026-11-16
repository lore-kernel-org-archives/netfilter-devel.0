Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794824543;
	b=4he08ZMzsd7U5zdPKlexxGcrIQQcTAqJi6vh6okshDnJBXyCVoMjGbdEpcIK7BvxpNgD
	 Wp7XI2cgHHSWtqMBSLTsFW2R1PwBRD3vurrBBuTsS5zczP+MMZ21Iq2GRDtay1DpjmA9y
	 B4Ggw8dy1UAOL1rUTmr1WtEDwCda6afiNfhZYl9AfUnwGPsRuFrYPtG5IxooJt18gjzJH
	 anB4oySZWIlSx5xEtPlXk2QCoHDQj86MDMIhl6iI5WEpQL8Q1UeEOSMs8bGt8g+K6+EUg
	 UToakJ2CznXtTWUiK/YQ0Ip+0mow6OdJ0MbnoJb+Si+S6fbalhn25D6H/NqPJYX8dOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794824543;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=tvMwDlZvRR8AM6MytHxY0doJU8iadrzcZb+rby3OoZ0=;
	b=gHf0b6NecsbBCt86I38q0dgCsShQn+Oi9x2/YutVA4iHzQj7EY5cCnw0vB9pKn2TH5Xd
	 AY2DKRoQ2VdxojIPwJP3L98MsCFMj/Zfoyd7Sta/4hy228xnZEhqGKkG7nQ2fr6JI9xDz
	 Ct4EJV1wCLVlJ69y13/Y5Xfc45P/wxxqUxj7Y7jb1einxvYM9xDDjq5By5/ehoLF6d5c4
	 lXa010hhoBg67huHco6Yaozl+VdOQNBDNACoucTggGsOd5vlMaT4XDvGTxGU0QFgF/GPb
	 s4fDjNfgEJsV/IDizsK+nU1SDSSJptwt/WdoI/2LFEahzVgLByTQ4CIu+5/EamgcaAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=G+N5jeLc;
	arc=none smtp.remote-ip=209.85.218.52
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C22606A31C
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 10:22:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8C22606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=G+N5jeLc
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c506a231b88so455992866b.3
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 02:22:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794824541; x=1795429341; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tvMwDlZvRR8AM6MytHxY0doJU8iadrzcZb+rby3OoZ0=;
        b=G+N5jeLcd9TSyU0ajfdiXFor9ieMQZ5PqDuSdcLVJ9kIPEwQO+wiNCAxnVReyz8upc
         rg6CRZkX7mHyv0qPzgwkDzRG1ihFRyqz7jPbkg6q+njMzB9Hh2kI8+UMC8l/K8ctNx+A
         mvGyiK5Z5godeXEQ6aE4PcqqswcqzxPtCLASKJjDSrXBj3scoxSTDHGyxc96txeB3t8b
         C8KxmiqvsxmMfkyiHnRwskEV702Qe0w01tZUxA3cWSVkEXDB/mvHc6nYJ+DyWxSIJnYp
         dPEWUFRwKZoJJW3PEFahc4sf1VQQ7bTDpp0iQqkKUvchLhVSQKbT2MQEYdqDQq0mnWSQ
         cFqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794824541; x=1795429341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tvMwDlZvRR8AM6MytHxY0doJU8iadrzcZb+rby3OoZ0=;
        b=2pFL0gVfCGK5sklNH5HzlpREw+1Mp8PaJZD7OrHNshy7vgjHMC8mn5jUsoKusw85KL
         d9jEUtrXYXU4z9mdYrKUscWskhKe7GzIskFFZ8n2adBeLZL7GC8xRVInQjIyiwsR/+MI
         6iTL+kkac1eq+P4Iacbnbl1zU4NkYdmpKlLg2l103iC3BT1KyTb2nodZcePhL8V9HJ08
         5PI1MRIsvUZOl1UVilNR2hAVCkJHRud54R2pTxz82e6zmyqI3ra1ngIzmLTx2cYfTUvN
         VIOjgKs8jYMVJDJVUyPdy55Rd9PrJGL+fpD3VK2tEEd2x67NU21brd0gvKOl9/Rk1tj9
         pWbw==
X-Gm-Message-State: APuU4Z/0GduxZFWQMScxW9ZZxQ9uDJzKGV497GTWJNvUdQK5ZB4Nek02
	4UAMI5SV13p0So4vbp5YJVmb8xwFE6oCIg9+NKDfuB/DYRXV/03eDyQY
X-Gm-Gg: AYBFou1P8i0vpN9UgUOpQEEz/iZQ3LrNg8AhKAno+4vaKNF31Qc1kAf0M8LCQfKClaX
	SnYnHI8cMCs6MbwM31+E/QMr7ZeGWsZMoYQCVLZjqiw9bSvHPbBjYberIa4jrC/z5mxpicYCWhd
	ibyWDtblkJiTwmUw04vCv7eNQ6u+MWQYNGfd/4UcscTHer72SOoWIVv2IBPDKqX5KgVUN0F4IUl
	EvnrPaMt/L4UUiw5wQcC27lp4HICVFHR8ug0kY9ye2e92CsWgtiPkdjp3OO63HAebToqgyKEQ3Y
	zGNYv5X0YwEWpwXdnwi2AwS1exZl1nKuWNQli1A1b1mxPREijOtgr5HF5bLQgP+N8Sckqq+pTMe
	drz0nPmLfKnz7lBQ23whZbPPNj4SoB/s796XHQJpjMmtVsrm7bV4wiLck0hCylgPWKrhfVNZZED
	lKvx3f9twbQJvFYgJEty0MnlbWFvkBxWq/Ypj+MpGHK9ukm8u1ZbmQiEI9G0vYdMXk1SiOx0lBH
	Rm35z9aVjL9rgdergXgUvZ//6nNhlkDWv+q5gp26icnC8hA0YnJ0Nd+UiQLJ4fxp8ge25m/GW8x
	tYzEVGMY56Ox2ZwVO1NWGl9awujaF2sfPc+vQD0U
X-Received: by 2002:a17:907:3f20:b0:c49:df95:f0dc with SMTP id a640c23a62f3a-c509641085bmr817572066b.19.1794824540780;
        Mon, 16 Nov 2026 02:22:20 -0800 (PST)
Received: from theodors-laptop.. ([5.255.118.7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c50e95da6ffsm32945966b.16.2026.11.16.02.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 02:22:20 -0800 (PST)
From: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
Subject: Re: [PATCH nf-next,v8 5/7] netfilter: nfnetlink_queue: restrict NFQA_EXP to userspace helpers
Date: Mon, 16 Nov 2026 13:22:16 +0300
Message-Id: <20261116102216.104955-1-theodorlarionov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261116003733.2820132-5-pablo@netfilter.org>
References: <20261116003733.2820132-5-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Pablo,

This fixes the nfqueue path from my Oct 17 report to
security@kernel.org. Could you add

Reported-by: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>

Thanks,
Theodor
