Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176AB1990A7;
	Fri,  6 Feb 2026 02:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770343695; cv=none; b=rwfc8YQCcjrcgSjFYir0PudGFQSwyOb+MnhwRQyixcRl2wg2uvq5Wnp5HNuFNCPD+Qsm618g3S398LNt+p3NcgQFejsd9DrQcJru405oznJ4dLmKVFF2x/z+Pn8tO5GofsTkUOa2SNliGia1Yt/hppo54MadLFKwisoM4TkJLco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770343695; c=relaxed/simple;
	bh=dH0nvtriaUnYoCLi+Z5zipL5Hs4LMF08XXNr0DzOhng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IGZOr6gbY+W+Ln1oUSRkRFigNFMzf0da6joB+K9s5JTNorTKdl61v2/yOtccJifkpojt+gp9FLGlfwcHvHyutOy9RUpovKLNzhwbhltige0UxG46/W+wziLz+5IMPxm5CVnBUvnG4nLoaCIch5i/lnaapueIdbHPjFe1nIexB8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ooRXJFgI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ooRXJFgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31141C4CEF7;
	Fri,  6 Feb 2026 02:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770343694;
	bh=dH0nvtriaUnYoCLi+Z5zipL5Hs4LMF08XXNr0DzOhng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ooRXJFgIlG+g+TKD3gkg6wL7N8eHtABNh5lkkhUjE2IwHn8p6C9TMxJS1HawAl48F
	 8YSNxASweI1II7X5qaKRaMMqCwhc+MShPzGIfms0jWDr7ZHyxNRxPsyLYRT7q5WDWH
	 W4I6KfyFOLdzbXR+5Jq5lGcNWdy4Cu7qcWNrOfe/A9Q84bCKNQ19pMzHjQ5x2SDZpe
	 ThLdkNohaq9S/d0k+1StGRUAIi9tIWPdTtzseQSyZp2CsM+xo070ozIf73BqgPWtuj
	 vdbJ4to4RVX88zzgbcWFRgVSL8Li2ztGZYWtmLUP53Oz9nGRWUBPgbk4dJvIvMotOz
	 MIzVJ5t7+rnWQ==
From: Jakub Kicinski <kuba@kernel.org>
To: fw@strlen.de
Cc: Jakub Kicinski <kuba@kernel.org>,
	edumazet@google.com,
	davem@davemloft.net,
	pablo@netfilter.org,
	pabeni@redhat.com,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [net-next,07/11] netfilter: nft_set_rbtree: fix bogus EEXIST with NLM_F_CREATE with null interval
Date: Thu,  5 Feb 2026 18:08:05 -0800
Message-ID: <20260206020805.3174445-1-kuba@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260205110905.26629-8-fw@strlen.de>
References: <20260205110905.26629-8-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.

For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-local.html
---
netfilter: nft_set_rbtree: fix bogus EEXIST with NLM_F_CREATE with null interval

This patch adds special handling for null interval elements in nftables
rbtree sets, returning -ECANCELED instead of -EEXIST when re-adding them,
so userspace re-adding the null element with NLM_F_CREATE succeeds.

> Fixes: c016c7e45ddf ("netfilter: nf_tables: honor NLM_F_EXCL flag in set element insertion")'

The Fixes tag has a spurious trailing apostrophe. The correct format is:

Fixes: c016c7e45ddf ("netfilter: nf_tables: honor NLM_F_EXCL flag in set element insertion")
