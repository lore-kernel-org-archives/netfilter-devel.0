Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D571FD4;
	Sun,  6 Sep 2026 13:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788701637; cv=none; b=shl7ayTb7josRunqYJSj5VuKGJBErwPO+lDxmI2fcKV0XRquiuimfxPJ0ByiGYv4xBXbLO8RBsOwLPdLeIhLRkdCqArx4gFi4PGZiumbzaenuXvq+L2ufyfGbKlyqob/3htEOobKCsh+HpZ+awjElQvrTGbSVrz/w6ITXtj9I1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788701637; c=relaxed/simple;
	bh=9WwnX6Oy8SwjYT4mkd3WfDEispkJUVrvdc0/nwSwflY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpITaReHglMXUKliIa7rlb1Ba6qlTgEVphVAWGfjwkUKmNW/roYm3jdlQbIJg9ke3aMS0q5X8rWJrEcxF1SMyzwYVG7tiXL9hNaXIItEvBoaat34f5HunV7gAmlQNYS8NLwH2a/n6aIRNFUqw2UNnSseoy7Hf9cBdSYMo/F/5Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mDfCcx3u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mDfCcx3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C371F00A3D;
	Sun,  6 Sep 2026 13:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788701631;
	bh=O+T+CEl3nX4kKk1DcMbOHHCsf5QZslg9EhYziHwEqP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mDfCcx3urStXVfz2B4nEUy0ELt7erimu+XlKQzi2pswO3mT23Ui/OoteS/9TFFp/3
	 pNcD/wSH9zodFD5jtjBgazaEOB1+7NTzY/gL23DKu5W/qNRoZJe0+jPMgrDtrkYdBt
	 sUSturo0Uu6UOJx7kuqo1qLMGytb6pMCjZV71Ry0ga91znL0FLFMRK86OtUqDYF0qM
	 jA27ngbfbvfBL841Gcdpad/ROEmpz8H+LeuFWrnGK7tGb+rZcdHN1rLLvAj5pE7qSI
	 HM669usB1d/hm4czgJUV4yyU6Vg6nZsgDzh9ZGi2CDktLwrHr8iLlcQQCGQSvn+yye
	 /2DChgD+CvREg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	Suraj Jitindar Singh <surajjs@amazon.com>
Subject: Re: [PATCH 6.1.y] netfilter: nf_tables: make nft_object rhltable per table
Date: Sun,  6 Sep 2026 09:32:56 -0400
Message-ID: <2026-09-05-daily-reply-0026-nf-tables-rhltable-6-1@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260904013102.22326-1-surajjs@amazon.com>
References: <20260904013102.22326-1-surajjs@amazon.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> The nft_object rhltable is global, this allows for accessing objects
> that are being dismangled from lookup path by other existing netns.
> Given the nft_obj_destroy() releases the object inmediately, this might
> lead to use-after-free of these objects that are being released.
> Make the existing rhltable per table to address this issue to deal with

Queued for 6.1, thanks.

-- 
Thanks,
Sasha
