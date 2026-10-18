Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2145D3659F9
	for <netfilter-devel@vger.kernel.org>; Sun, 18 Oct 2026 02:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792292025; cv=none; b=VHqPr5ysaBQIXbfbBNw4zqhPreTMAjo+searj1/xqH6nlV1bXEXJHO+ePblDJPHaoKsQ+KbzS4ZmxDnZCPat5SuKlE6Qvz/YQukB0O48E79YZqCn9z4U5gvbwk+Q/qUXU2GXrWkICnn20dui2K8BFAtajtQpSsRTDi18PqlWCjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792292025; c=relaxed/simple;
	bh=bBj6psTg0atPzJHuE/vK78ETes9bC48NNTa8QuWS9mE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rpzhETgkaTOi7mZl6Ox7I/YJb/k8/oQQyaUj57Jdacyn7KSpBg2X5DvzeD1dJZtOedPqnzSkwUJEXliPERZDC4imwLo7zYeLSw9hnh9r8XFvvrE/1V7nySm4wb+0IDIc/lLVWuSNvuTVnSFmkckNH4zXgMfx9G3OUPW0UQu0OpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=XKl8HCU4; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="XKl8HCU4"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c2055573c8cso122708666b.3
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Oct 2026 19:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792292022; x=1792896822; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bBj6psTg0atPzJHuE/vK78ETes9bC48NNTa8QuWS9mE=;
        b=XKl8HCU4bV92icTmsQWW071t6+RYE7qqS5/zx6XPqxd5jrGr2cLXOA2wt7gylr8XY6
         YF2zHFi7DDt+wMJqp94jFuMUc2q2pRfJJN3rFTy5XYOuaXgm6CXz0I4qI8xDcJW+lKP/
         pVmyjq3QplS3YSjtmw8eWl6Ex2EagRvbGlzFtZNLzQMsDDpLw+6zAk/tqJNzLeSGC0LY
         NwXz/I5XbQsVefer7uYX/+X/HdSTZkpejUhFNkkPWiPqi2i02+S0o7GthlptOtLUFtKE
         6rnZ7BISlQO+2Qa4xC0yJTm1Hv0Y3pgEZctOULkd/p7C6RwI7OrjD8g3U/r61Kdkc08V
         vkqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792292022; x=1792896822;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bBj6psTg0atPzJHuE/vK78ETes9bC48NNTa8QuWS9mE=;
        b=HTlCrtZssLFqLfkxgU968zUvclKjfjcVrulecq2ZPMpZSLNU4mPRSmKLjfzGXnpk0f
         uB9cGy7vNk03VH/NoE6rXhQV1IWq9W9yUO6XgsTl/7CNErxSzu39avGArnCYyWjsTvNB
         r0MKWIMC66FrOitHOD+nXVhBN6fa2fkz9KOUosNV7ttmg90R1pslc3/4MgIGVBVei6kW
         sAuiXfMhCg4BS54qXWzbsqjQVa1oDuD+9Vp3lTGfjd4EnhsskcrDouZLqMKHldLjS+vq
         a0dZDPEu17bwjCSDkR2jn8Y7cpcoqOsJ+hEHmR5Uebe7VR9gbYqMS2yeYjPnXbLc+Dz5
         k0OQ==
X-Gm-Message-State: AFq9FYK7yZ3/QPlu7SXPxC+RUiYZTizM205vEmriG4AbyAm402kuD0Yn
	yEBvXaKJXgVDK3j1sXjs8+Ee6qnsAOfmdZ0VP2lRsbVqbYbedBVugib3sZZ8iFH6/A==
X-Gm-Gg: AYBFou11p7EXgMJSxk9o1NzeYtkgfipsBdYNfPxnXb9JOBPFVawJeaKi6DA1r/ODsPk
	aHiQbg0ibfX0OJEuOoc/09wOcuRYLusKoXWb9XkU+rhbC6vb91fDgkMWhIpDrWQA6yDjiIstK7Y
	qjzmv7Nl1CZjy9tr1aWnrNdDdbHI1NWUUIJV+9wMF70bs92ThDRz2ddz7VxsVfwFNlVKfwRv1pZ
	c6umlnsudosv5u/BaPD1e/c1bVVTu63AOVJJUZ/GilIh7GSi9OtdLSDrcP+NRpD7Xl9wRsaK6p7
	YEERqI8j6VoXvGQs6bSJ5KIyCJjR7hI4rHZLTS8WthYz9QTJr/QhDClcixSGjfwpt0GdhXGugAX
	zAt4X/Q8REeCLKR7FHYCi8yPbB7Icb8CfBJhJ99jmlIk+tUFXuhWS361Iur0iiaVeWKCbs2oaxN
	dkjca0PAobI4tPPt5Ii3Vi0foAYyTc6bX4oJYC1rEItbPLyfpItMILhA5BV95+YmrasjBNClODQ
	AVEFC2xH+G3W7JTbmmL5mV+Ltfh8zAF+eyp82GzZ5oA0mxLatLhoiYKd2xn4NoGpYEKwE7J5Ydl
	OAr9nZDKDFPZyI17kU2Eskj645hXv9PpkU1BGsVtwTQQi9TF7ahM+ZRvIH40JF0CmDaRhK0ptHe
	d/zPFfXoI/bN34EcyWL1k4Tf7ERddInuzTSD+GNr7MyNCcBu+D7AvjKb0K5xy3+KDw4owhZ6+NL
	nN+1qQ6NzT3BisW5408dy7RkceZfa2LA+xAhxnq0aH5gEYxr91Rm+ajDw0cRWMj2T8Xf6o
X-Received: by 2002:a17:907:94d0:b0:c41:285a:46a9 with SMTP id a640c23a62f3a-c41a08d9fc4mr265085666b.46.1792292004094;
        Sat, 17 Oct 2026 19:53:24 -0700 (PDT)
Received: from Desktop.fritz.box (p200300f24740ac10545cfe8be1a407c1.dip0.t-ipconnect.de. [2003:f2:4740:ac10:545c:fe8b:e1a4:7c1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4090dd1130sm227219666b.25.2026.10.17.19.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 19:53:22 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org,
	fw@strlen.de,
	phil@nwl.cc,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	andrew+netdev@lunn.ch,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nbd@nbd.name
Subject: Re: [PATCH nf-next 2/3] netfilter: flowtable: update upper device stats in the fast path
Date: Sun, 18 Oct 2026 04:53:19 +0200
Message-ID: <20261018025319.1445197-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <atQmpPlfT_DSd9dq@chamomile>
References: <atQmpPlfT_DSd9dq@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, Oct 18, 2026 at 03:53:40AM +0200, Pablo Neira Ayuso wrote:
> I mentioned it is a feature that these counters are not bumped,
> because packets are not passing through this devices in the bypass.
>
> This allows users to see what packets follow classic path?

OpenWrt users report it as a bug. On my router a 268 MB download moved
0.15 MB on br-lan, while the port below it counted all of it.
conntrack already shows which flows are offloaded.

> But if you insist, then explore a way to synchronize these counters
> offline (ie. not from packet path) to see how it looks like.

OK. The gc could add the conntrack counter delta to the upper devices,
which would also cover hardware offloaded flows. I will try it
downstream and post it after the fdb series.

Julius
