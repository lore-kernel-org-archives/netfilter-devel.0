Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACAD82D29C7
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Dec 2025 11:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767008785; cv=none; b=r+bCmdKEvtWTKTpL73b7PnzeeynR5+VrLDSxzwT4gi0n3B6ZjaBM1ziFO2dEY26JurIV7PIscc2z9pMlRIvzqTcU174ED+L2ecHjR4fPKs71d0cSx7Tr27eVMm2Zp5VWqfdL1XPT7/elZqwJws9T9lzUu/LoZTvu93fmqmFomZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767008785; c=relaxed/simple;
	bh=oZN9xvntaNPMN/kUpYbGDYfYxniuHtlasoJxn1YqAjo=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=rc5wrTgi9th40XpDdKbS7Ztdo4H5fT5JEtLYI48Rjdo/cJs0JebWM4PlTfkaOfhqdSW+Iz2rgZrg9IgFFzIhiSZflnE1/rhOveLKax0YetgV6TLc9LW9YdHNP3MVDT5qP/2NMAGsr1kZsB8e/tjG3+tgpEvRTlSF8qAWIt3m5+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 5BB001003CA2E2; Mon, 29 Dec 2025 12:39:11 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 599A0110014C09;
	Mon, 29 Dec 2025 12:39:11 +0100 (CET)
Date: Mon, 29 Dec 2025 12:39:11 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: Qingfang Deng <dqfext@gmail.com>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH xtables-addons] xt_pknock: fix do_div() signness
 mismatch
In-Reply-To: <20251229062607.755-1-dqfext@gmail.com>
Message-ID: <o5o612q9-1860-o0s6-747q-r5712opqsqn2@vanv.qr>
References: <20251229062607.755-1-dqfext@gmail.com>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Monday 2025-12-29 07:26, Qingfang Deng wrote:

>do_div() expects an unsigned 64-bit dividend, but time64_t is signed. On
>32-bit arch, this triggers a warnning:
> extensions/pknock/xt_pknock.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>[...]

Applied to the git repository.
