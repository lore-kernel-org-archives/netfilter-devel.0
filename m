Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFA020C00A;
	Mon, 17 Nov 2025 23:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763421111; cv=none; b=MRYmmB77e2c8Od+GHK4jahM7g5XxyUODmx76eUWTLBoAZR2jYWROq0YDpRRryyFwlhiNawpKDyaOP4WlQa83S8MtH081w7gr81rkbBntMjfegG+m1vV5RH+uGksnLVKY0cJpWoX49Lch6Kp3BS+o5aVgg6kF5JSiDITsk/2U3xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763421111; c=relaxed/simple;
	bh=nKZ3SCNuzLJoW6Yqw7QcR44y+lPfBHvWonuxwpbHNEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=huIxXa+47L8yv/Fyr6slkkq/wkQvh42mq3XDtPQbU7O7LA0ooLHT0Vm4d/0dANRCPiNBKBIvO72zh5JLMn65C11GYfo3OLUe8aOFIio5QuIBQy7DriOBTSDGM1uJYaCbuxManYKZmJKJpyFcKJa4Q2Ch1QMdtAi7pESWsedV9AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MpT9dkrw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MpT9dkrw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B83C2BC9E;
	Mon, 17 Nov 2025 23:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763421111;
	bh=nKZ3SCNuzLJoW6Yqw7QcR44y+lPfBHvWonuxwpbHNEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MpT9dkrwKRpKV04lHuo2GUyR0N0pGLMjV337H+w/Mwdz2gQv3qNC6OzgfP3N/e/4u
	 UOzCoQcVS2G2UDeyNBV4aKjMkquVFS30R0btZK5LHHJGSmKVyty/dtg6PiQAXH0xCd
	 xkTNlnAx/WSYoTG0jxOr+aBeJ7ASEffIU/+OcfVpDZT8K6L3+eSWG4G6OulyOeIcM0
	 uiwDxHKngK7UsGWX8MSAaqzEMAdak5yOOw8iyh/TNjFXgj1VUJ+dpodVblsCnalYEC
	 xHC1AzDDSMBoQ0x5C3tVVcWLOejLV5iZlEkwydnx27Mq4Mwqn2rSHD9hxHt7DVvRpX
	 FXfTyCF2mF43g==
From: Sasha Levin <sashal@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH -stable,6.12 2/2] netfilter: nf_tables: reject duplicate device on updates
Date: Mon, 17 Nov 2025 18:11:48 -0500
Message-ID: <20251117231148.4110724-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251117212859.858321-3-pablo@netfilter.org>
References: <20251117212859.858321-3-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch has been queued up for the 6.12 stable tree.

Subject: netfilter: nf_tables: reject duplicate device on updates
Queue: 6.12

Thanks for the backport!
