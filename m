Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DB33546C0;
	Sun, 11 Oct 2026 16:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791737331; cv=none; b=JqjS+lSZ5b/gfZjrCrtTxVp/zvHEf6rVDMyiqNQ3WzRCGDJwmeMmdDJV4zeP3HtKPGY5sE6lUnOiVnE8+bhPkSHP4P9PjB1PJTNopGu6+aqGQPiqPKTsBBPGw7j/GaTqJ0rIdbkGbU6wIcPZN0GeI4XqTd6FmuBHjW/1dVljBWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791737331; c=relaxed/simple;
	bh=nxVvTfq+y6YttM5vXs7lCztiog9xmGquc8X5VSTinDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nH/0K7nbuUCZ3wCrIZp6Jr16QBpzpy4evaCZ+z/XyVhqLyChAoZn3v92Nf+Xt9V3djw0RjH89DYhOUKIZp9YHerPR7MzuVikYQHrp4f3HF2xH5vQazcM4hsRzjCkgAw2Dz/KZuATF26t50/LGDkGLEN2XtFgswb2f2xVgLhWY+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DmOVcQbZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DmOVcQbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B411F0089D;
	Sun, 11 Oct 2026 16:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791737328;
	bh=COUM1f6qQzy6WuWsx94Wc1DEg5BjF4JO9Qf/Glo37dQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DmOVcQbZZE8h9JOZEaXLog0Qmr7RzC6MskyqPM3PcejNHiburSTQAxZIuDEM071KJ
	 WceOgGvSI/EoBvMtl06wPRbWjiSVG0gKDBz90XB/jC8cBuQdf9yZpKKoZWoncVNAUE
	 pIAHKHtvGzA5sSJ5Zkg0rFiQYp/UtpcG3Ko90RmmcjJSWCPy8FLkEil6dY515LRylc
	 IfdJ0pEKuMKbCvtz6uiC+wEfwEM/mo1gZPUIqmC5FGnfcUjtnZsfaVk7KGQiPl1GE7
	 CHlS5h6lilE+JQrB6P1khBatKvnoVJ+7tHpZmk62vry1c3kbxmM/O/5p3x/0qG+ZF5
	 jijurw67GPjFQ==
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
Subject: Re: [PATCH 6.6.y v2] netfilter: nft_set_pipapo: restore cloned mapping table memcg accounting
Date: Sun, 11 Oct 2026 12:48:23 -0400
Message-ID: <2026-10-11-1-daily-reply-0016-pipapo-memcg-6-6@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261010120528.4604-1-kmehltretter@gmail.com>
References: <20261010120528.4604-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Restore GFP_KERNEL_ACCOUNT for the cloned mapping table.

Queued for 6.6, thanks.

-- 
Thanks,
Sasha
