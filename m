Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E509E392811;
	Sat, 20 Jun 2026 11:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781956512; cv=none; b=Euj0j1zllXel7X7CNotVB9ifJMjqPSvPVspDGxR7w07vnP70puuZBaveHeOW8s6UE7AOGzeq9OZXg64JopumVm38lIEv40XJ4l5eNP6lxus3Duo7eXJJ2c6QhKEMu/qvJabaDNz0Cb8J3cLsxh3kMwNonfSFn6NyKMFIPd40LUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781956512; c=relaxed/simple;
	bh=iWm/Wc8FtOsVNd7psrl8lFVgWfPKBqQljnMtnBTipEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Js8Q/CYp9Kgv/X8DZ+GWhRQSwDr7Nodv9zMtt+3pB/NdYIZFLYTg1YkPPrxDwID2zHrxTtYA6H0WZ9yk0jOmNNhdPqvsn90LqPf20qtoXnXFFIKzxv6w66mmdSBDqiUmeOjNVjzM7cKV9NFHjup/BrzqNisxhAoe1+K8lJQYXxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BQiL/Gt7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BQiL/Gt7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B033C1F00A3E;
	Sat, 20 Jun 2026 11:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781956511;
	bh=lCxqgdtEKQ1aqjvBRGrrR9PiUkEsMnWdhzSSoNxvuas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BQiL/Gt74Xy+5NpZSnggTrx+bFYKtQMeSTkzifr6KNZceojswTPo1o8icTzEkTT2C
	 XVG/M9BxDyCvR2I2uL77R70icUvrlNKG1McsIeLcNuwWWrHn5FOdKW4OcyyKdES6el
	 m7siGwwwIrogvra6U6n4vhY4KtigEiljhy9Pd6uqJWibWY1FgqtGJDItGgXP19RBEQ
	 TXtThIQg4w381CROHkEfp+PZLCMyzNzCzFW9/8aXtfJ9B5wtgJzAfXHgkzl4/oxIon
	 WNb2w8a3zUWTyVCrBTK+fTrDCP2YoG3lA3+qhAl9bRmXrZr3+iVGEDQJHhAeJocedw
	 YFfWxYLfBkkRQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: Sasha Levin <sashal@kernel.org>,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	vamsi-krishna.brahmajosyula@broadcom.com,
	yin.ding@broadcom.com,
	tapas.kundu@broadcom.com,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: Re: [PATCH v6.1 0/3] Fix CVE-2026-23272
Date: Sat, 20 Jun 2026 07:54:57 -0400
Message-ID: <20260619.0009.reply@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260619092850.1274076-1-shivani.agarwal@broadcom.com>
References: <20260619092850.1274076-1-shivani.agarwal@broadcom.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [PATCH v6.1 0/3] Fix CVE-2026-23272

Queued the series for 6.1, thanks.

-- 
Thanks,
Sasha
