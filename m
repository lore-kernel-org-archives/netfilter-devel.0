Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DAC2949E0;
	Mon, 17 Nov 2025 22:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763420281; cv=none; b=UNp4aJSEcyYTPoUQFq4jJpANyW0RpuWsuXFYrCtbxzlsdX61up8kD+sIAyCozqoHou8xxqTxnfG/uaeFRMHaymPQysiqJUZQs/IUgGbrTotBhdLFgxI8pW1hqXwauh27VIu+NcUj3dHsSkqKvAuhE8nZ4DjQm+h6ACUJuXKl89s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763420281; c=relaxed/simple;
	bh=Z2nOKB4BeNgDhKEkbgrNxGPg5B8oV6EhoU/jbksRrbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ja3ZO8u+fbQ/zHYcR3Q785Na1GqQkmu4b1qhDJGsFd2itwl/9CqKXz4iPCSypW/FOlFhPYVdX9mt3ItRFUr8Fdbf5tFr6I4RYBBoNvoAR+FZVEN0+urA6hJPa6ILTpLU7bl6xEC+Y/iJOI0VYhMtnQbzCVpKpbu9/01lwkw2raI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iww6WZiA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iww6WZiA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34AD7C2BCB1;
	Mon, 17 Nov 2025 22:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763420279;
	bh=Z2nOKB4BeNgDhKEkbgrNxGPg5B8oV6EhoU/jbksRrbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iww6WZiA6H/1Dz4kBzrhRc+E4knorfiHS/SKgUFuz3seNAoZMjQOGisuyQHmzEXja
	 EnDSk/n8LYPCij33V34hmJBOw1ZnHKv2qCQLo9cYIZt8Tt0yrDoRWmpr4fdFcZ9uyU
	 EAs09F3fJJDsHz/Eauz2azqgJ0cFKH0vm2kFMR/sbvGmjWgwGJsigrc+tinnIERigW
	 MfOQOeLUkLDhjWfUkAqSFJJdP1q8qhRHMxXXHjd0jJum8MsVvlyRo6yKzmDYrK70Lp
	 cdLSAsBnRPhaRToGixBi8BBVnKIcHLZCrOpudxu271VAlTWfoHg9K/SJbh7hIEhRre
	 e2aKLJtyqZ7Hg==
From: Sasha Levin <sashal@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH -stable,6.12 1/2] Revert "netfilter: nf_tables: Reintroduce shortened deletion notifications"
Date: Mon, 17 Nov 2025 17:57:56 -0500
Message-ID: <20251117225756.4104730-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251117212859.858321-2-pablo@netfilter.org>
References: <20251117212859.858321-2-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch has been queued up for the 6.12 stable tree.

Subject: Revert "netfilter: nf_tables: Reintroduce shortened deletion notifications"
Queue: 6.12

Thanks for the backport!
