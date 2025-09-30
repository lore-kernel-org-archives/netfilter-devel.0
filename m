Received: from truschnigg.info (truschnigg.info [78.41.115.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7961572617
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Sep 2025 18:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.41.115.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759255715; cv=none; b=WmSdWfO7sgb+uNBYQ9O4iaJHx+21U6OCHax3UNmDTWoc022PJGN/HCl9/8mMm4rbhpjzRjXbjPCTlG/eB8nKIngiNthNP/ejXA9VyZcmSmNtGd8TDl/l4iBlr3+pwQEtxPQDI5DMqK2Hl8f81NcOsuiUVuzFW53UeL8Bz+xu4Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759255715; c=relaxed/simple;
	bh=/hsgsMyk7W+HYOWsySPHQOQoODfspohr2Q7Zf0phPoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2+X5VdV6te/o4SmcoNck7Ep8EBq+y58rlmGk4e30yFcjNGR5kvmtuoJAbCW0k6vmES0ou4jKoft6O7KGyPOYzzJzcfwl/fpKuskdi6VBCIKiAJNyi66LEd8kzyk/9mv/Y1Yk/eqoxt5TfoNs3+CJGvIeYKdnQz0wmuyzH2ckfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=truschnigg.info; spf=pass smtp.mailfrom=truschnigg.info; dkim=pass (2048-bit key) header.d=truschnigg.info header.i=@truschnigg.info header.b=MNZzqgga; arc=none smtp.client-ip=78.41.115.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=truschnigg.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=truschnigg.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=truschnigg.info header.i=@truschnigg.info header.b="MNZzqgga"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=truschnigg.info;
	s=m22; t=1759255705;
	bh=/hsgsMyk7W+HYOWsySPHQOQoODfspohr2Q7Zf0phPoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:Reply-To:
	 From;
	b=MNZzqggaYiTTGPznduduJ/V9vEzE+ct572nFfm+h6kHcK6L/6W2SG94kbFWar6Rq2
	 RcfTe+AH9Y7ZT8mRvR7Pkj4qydxm1LsYnhsY95ox4m7NTc1+qbysGvuHtwMNrVJBCi
	 vK59EXm5T0ztSUX4gDvG/AXwhuqPAJdQonxiI3J025UjO5urxhk/Se+VnwebyExvxJ
	 abxDHKX5Sxibkumfyy3YuR1dkBddJ9TpnK1QX6gSRGWjowd97upKWsN4s4UkKi9WtJ
	 OgZ9sX+MKo5fDdwDsfkPryaHGgOLzySva2jsECTtSt4xWJn7DVZ7U+KMxHEwYoYHYl
	 Ig4Z9pyFMsriw==
Received: from ryzealot.forensik.justiz.gv.at (unknown [IPv6:2a02:1748:fafe:cf3f:526d:1663:49ad:7fac])
	by truschnigg.info (Postfix) with ESMTPSA id A55803F2B7;
	Tue, 30 Sep 2025 18:08:25 +0000 (UTC)
From: Johannes Truschnigg <johannes@truschnigg.info>
To: netfilter-devel@vger.kernel.org
Cc: Johannes Truschnigg <johannes@truschnigg.info>
Subject: Re: Re: ebtables-save: Do string processing in perl instead of shell
Date: Tue, 30 Sep 2025 20:06:15 +0200
Message-ID: <20250930180809.2095030-1-johannes@truschnigg.info>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <aNuvKZN9WM8bVRkn@strlen.de>
References: <aNuvKZN9WM8bVRkn@strlen.de>
Reply-To: Johannes Truschnigg <johannes@truschnigg.info>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Reply-To: Johannes Truschnigg <johannes@truschnigg.info>
Content-Transfer-Encoding: 8bit


Certainly - I hope this fits the bill! :)
