Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3ED3155308
	for <netfilter-devel@vger.kernel.org>; Sat, 15 Feb 2025 04:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739592240; cv=none; b=koAo8P2Z+hvQA95yXvWPpizswQk1faarXsjr//R4abraq+CRlyAyv2nVwNdrL3RBsWa+NmI9kDEFOfBm917YZmJqZ3xWV4VA20FM7/9wlzBIyGLD6MapnKmxV9tz2Fkdo5dMKYURzzMgX43JipyP9x1XteCL5fWYp20g8P1yC3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739592240; c=relaxed/simple;
	bh=+gSG5mFD2ImCICOouk7U66CMCQtDPy3WgautKb65Xpg=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DaSGpx44e4JmMxSHKnNEgrK/6tc8lZOjkIBExSe+Wxj9FePUdWAkpM3ofyqTRSQPM18BVPWX/GqxShV/S6k6iIu+0mzef4YdBO3V+AecKorSdsV9ePP7SW3YieiP+qtZ3kaEZA0DCHaSvfoaLMbv+J8KcCociwGvFn0+M4HKdPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=Tz2R0scx; arc=none smtp.client-ip=185.70.43.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="Tz2R0scx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1739592236; x=1739851436;
	bh=+gSG5mFD2ImCICOouk7U66CMCQtDPy3WgautKb65Xpg=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector:List-Unsubscribe:List-Unsubscribe-Post;
	b=Tz2R0scxsdKEhYRdTAD88wnAvJBH0dygemq/3oUTrhQS8XTG24385vgo9fzR2siWl
	 5TviiZ3sDDdIv7YmX933/JwmgbTEmGaosI/Y/F11HHc9geUUC1jDJSpZGJLSEZUT7e
	 LF/LyHNbg/YunwYu3iDx5eCicyMQjlPItph8YcB63LiuUs1bOUEbVunJ/WX9+nDYF5
	 8yQip7I90zDGAhk0ef+AY4j07g/gLiEFxHvNhQXM2ry2HfZh8rBHn+dL1gO2hQ+3Zp
	 P9xWzcMavaHJSv+C4jK24/vUjb2+sn7DKzjssQPFcgf4HunPLp+LPq7auQt1g8zvPB
	 alXRt7jA4QPVw==
Date: Sat, 15 Feb 2025 04:03:52 +0000
To: Florian Westphal <fw@strlen.de>
From: Sunny73Cr <Sunny73Cr@protonmail.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: payload expressions, evaluate.c, expr_evaluate_bits
Message-ID: <FmZlnYqaRkZyHfgzvEHUVm4wh1XXZbioIgmvSOHDRX1eb6SRZW-MvnEhIxvgWn7RBaY_iC_ohZN2q5XVehN4zPtXtVkMetAih-a2xZ5fNtA=@protonmail.com>
In-Reply-To: <20250214071816.GA9861@breakpoint.cc>
References: <pEHO7WvK0prMNgZ-F5ykdLmclh4sY_7_tM7aC-AkyCPTDU6izTFwHj0tJsLHGONPYZKM3zt7B2wVJihfd0Vdxv71PjrpxtuRKY1AlVmcyBc=@protonmail.com> <20250214071816.GA9861@breakpoint.cc>
Feedback-ID: 13811339:user:proton
X-Pm-Message-ID: 46312e03178de31f61e69a1a3fe5c4ff9baf269b
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> Fixed last year:

Apologies, thank you for the information.
