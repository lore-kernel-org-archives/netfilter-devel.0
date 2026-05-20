Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E3D25F7A9;
	Wed, 20 May 2026 00:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779238466; cv=none; b=Den9VOBiy3tQbxkbLNmCSWmn2qnnFGSx6DO9wOa7UMbC71LIyMX2p9KMAqnEKwBxaTERTjXCAf2+j4ZYJxIGcasRjhY4AHTuHf2mFozygKXc/enMUgesPhhCkoH+rS14dxb+4DQn4tty0wSwFilJMZr4rtf2B4jfHudx8R0MV58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779238466; c=relaxed/simple;
	bh=oJ/yexyTc4fld4Ml46TlMVb7vovfTZPFy5qhbWiansg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K8A/KIRN102GKwEUfGh6V9vfbTJOC19EvukPgspyRydH10H5DN4tTvLCiSv8LuHazelzduAJmeKfUZ0TVxMn8og30wuim+NsIkSy1p0EG3UAgg/bm7OJ9QH2AM+6Z6yn/PDE4c5xpUGqTbpkBEMY322iTneKvC6rO/Nmwv9L8+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OASkzpeR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OASkzpeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2D41F000E9;
	Wed, 20 May 2026 00:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779238465;
	bh=oJ/yexyTc4fld4Ml46TlMVb7vovfTZPFy5qhbWiansg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OASkzpeRG8Al+okeTA7WKpIvzC/dVjB/uNd9UWTaw3NW1vhHq/Q1MhZwkMif0ZfV9
	 Tf/vjAJYdvPipT0zms40ut02IRbVzAXpwtkGFY9urwkR8Ho/s1UqOPz0tT1nOjkTtp
	 JSlBHzmhVWwOmP8Y0jbO389OcjvXKT+MY+vGPhdGm1hUCUEGSMXjIyN62sztrMykqP
	 4joE+l+SqyI7moT+NkUiAUOVAMemJTZgcJ05aYDv7KGVjFiQgqGvGsvHLXlTZwwL+U
	 ED844J1g4iZEUkj3/QoXZGvW68IBFVK7vV6SDGuEU++IwqjywGIciyKhBUAaKSAaMe
	 3do5t9xF4AooA==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	pablo@netfilter.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kadlec@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	y0un9sa@gmail.com,
	fw@strlen.de,
	Li hongliang <1468888505@139.com>
Subject: Re: [PATCH 6.12.y] netfilter: nf_tables: unconditionally bump set->nelems before insertion
Date: Tue, 19 May 2026 20:54:15 -0400
Message-ID: <20260519220508.reply-0001@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260519075504.2064229-1-1468888505@139.com>
References: <20260519075504.2064229-1-1468888505@139.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, May 19, 2026 at 03:55:04PM +0800, Li hongliang wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
>
> [ Upstream commit def602e498a4f951da95c95b1b8ce8ae68aa733a ]
>
> In case that the set is full, a new element gets published then removed
> without waiting for the RCU grace period, while RCU reader can be
> walking over it already.
[...]
> [ Minor conflict resolved. ]
> Signed-off-by: Li hongliang <1468888505@139.com>

Queued for 6.12, thanks.

--
Thanks,
Sasha
