Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E8426F2AA;
	Tue, 18 Nov 2025 00:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763427488; cv=none; b=RhA4buCx8v+KdcWXTPs9XqVqI0h9cvQrtdpTyH6F3J5V0uHQ66XVbkQ/rNxnuIRlE76qZ5TbZoQR1sNHtOdQWbYEAj8l848bfj7/dxqRI4BK8t+cC68sNTc1bZ9HyihM1AhLzAUx0V6gRnYu2LrNfrV2wkwc9lFL7k8hk5GdL64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763427488; c=relaxed/simple;
	bh=QjpnzXEjt3J/zuxMaUqbHJ+O+bL40zA0DJnjCVWJJ3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cAkiUzGrS0DfRZhqibcox+eJl3G7tBL8HPOP313nYpE34tLCJl32k53GBiBPfs0l0xafvaS+OXDDyqHuUzqbecgz+F/n6OD9lPvC/0tcxyE69d9kSckicHvIc928HacblYPoAMtxVLa1e+rd5NXTDehrJEVieZa3fsOt9As9Pbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FoXthtZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FoXthtZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4B7C2BCB6;
	Tue, 18 Nov 2025 00:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763427485;
	bh=QjpnzXEjt3J/zuxMaUqbHJ+O+bL40zA0DJnjCVWJJ3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FoXthtZcUwicjg/KVOsngCqVwuid8MSPI15k8p9aaeMDDwYLvyGdInIHPisWQ3bA+
	 F1SP20o7PF/jpeCOpx0jW/9ZjNpcpCELw1oRhK/7lfrsm3oFcUN4gQYdhJxJgYUHu2
	 5RloD5Wk1+dwZ3fh9KE1qWpU87g+Pt65hlVgwZVApPORAm19pmMHhp7bk+XFt6Dkgw
	 Dvwom2fNTDyGWafruMxtk4hr9rXKWtSJuQ2SjRulfeymOFsXrB46WAuC69DscxwXG/
	 cyqJ2kYtkcKR50e3CE3uysBtoXsw5F4qN3bFxgexfafMxBhgsX+QrmmiqjQiLCALGX
	 6qAbqEGQzidZg==
From: Sasha Levin <sashal@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH -stable,5.15 1/1] netfilter: nf_tables: reject duplicate device on updates
Date: Mon, 17 Nov 2025 19:58:02 -0500
Message-ID: <20251118005802.4137812-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251117214023.858943-2-pablo@netfilter.org>
References: <20251117214023.858943-2-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch has been queued up for the 5.15 stable tree.

Subject: netfilter: nf_tables: reject duplicate device on updates
Queue: 5.15

Thanks for the backport!
