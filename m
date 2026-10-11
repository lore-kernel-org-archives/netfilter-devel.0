Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC1135676B;
	Sun, 11 Oct 2026 16:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791737332; cv=none; b=UoaL9HubT9OSB5tPxm/kTmjweLED90ChwCPmuu9W1viWQhkw956ZbwDZnxJ5ZWCLlP+EfsPEukDElJ+vdKa9mtQn9GI8Vto/xRd0Q4AyWftsgLGNS/OnpWbIdQFcWcy9XfCbXodoS4yH93YyEnNHIiqEa//SOiV+2TKmtjoQzw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791737332; c=relaxed/simple;
	bh=xz1fcru0w3jgCWOKiYXomhxJPDZkuAgO7tfKuCyR5B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZXCVuBYGkDvd6Jcb1MFJG84AiEc4s9hLFfsNBV9VO8ZAYwF/gtyP2NB+j3hytqha8cW1HTqCCUtBatUNvw5ZljFHLrJsWSTKyHvCER1b7FvGjZUwljUVGXag/nqpBLnLIbFFFgEyTB50TlkLoCCFrI1k2FZJRabcAX7qNK55I+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jqRXblvU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jqRXblvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB45F1F0089C;
	Sun, 11 Oct 2026 16:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791737330;
	bh=BAmmrYukOtywqz1c3pD4NRu3KJ5q5Ov68ELO+BhBP6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jqRXblvUDQnSkb4vBR1qbVJ2S868rnpPRBBH3QLia4eLScQzOxA24pEt1Ef0RsvaL
	 DJdq8Edw/i7Do7t/GF2l8a2Kz4fwo3rKyp5T20QEb5W12hOrLMNH+mZqKyIW1Q3BR0
	 VgKm87dVIj1KabR4/jr7aoeQuYNPsGY+DPz+cGPV6hOvsbtqZ3BdAS5x8Z29rULJnZ
	 SHJs7DU1gMMRqgynQT0Y3k9lc+xMpAFQSxc4I15fqjYaLWEnjN5+VXJ3RcCl9+fNli
	 p1xnbzzCQFBVeFOOEljl3h+N4xbxAMQMaNif/fp6Jz/2KWCSGRasxUKb8ldvVytSXt
	 ocaP1gY+p4ZUA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Mukul Sikka <mukul.sikka@broadcom.com>,
	Keerthana K <keerthana.kalyanasundaram@broadcom.com>,
	Stefano Brivio <sbrivio@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Brennan Lamoreaux <brennan.lamoreaux@broadcom.com>,
	Bin Lan <lanbincn@139.com>,
	XiaoHua Wang <561399680@139.com>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.1.y v2] netfilter: nft_set_pipapo: restore cloned mapping table memcg accounting
Date: Sun, 11 Oct 2026 12:48:24 -0400
Message-ID: <2026-10-11-1-daily-reply-0017-pipapo-memcg-6-1@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261010120624.4946-1-kmehltretter@gmail.com>
References: <20261010120624.4946-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Restore GFP_KERNEL_ACCOUNT for the cloned mapping table.

Queued for 6.1, thanks.

-- 
Thanks,
Sasha
