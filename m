Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527233D3CEA;
	Mon, 30 Mar 2026 14:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774879659; cv=none; b=gVXWKcYcRf9e/MxJ4DmWe6mNXlLJVfyo53VhjRU9cz49EblHcupVCqoJKzU6ob7y9wXU/3RHOxBCsoUtlRIAz+KTRofYRHWTNnhvaMQWBBf8vJkBcLfXVjqhzedSaeqoKEabI3mTK3U0ALO4gzncwTHGb9159UV5Hr5ZYHRHJyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774879659; c=relaxed/simple;
	bh=MqhQRXiekbXYAnbDrF1Z48HnVe/n0wah/MTzk4wcG5M=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YVaCuvO4kwWwYmNC3fNTulyPRDy1+u1UFTKgoL7unrtVABVNbdkBVTVdufRWZzidLBO5fZ1E4WqdytbS8b/UD4FsoZCUHP9QRN8EURQmmjfvAqyFgNsJsWxwsX9yxbHFpG+HIzOe49nkWFyLbCK5ZSsacgPYUJhyKZUeIi5CSrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gKZAwtRJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gKZAwtRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95542C4CEF7;
	Mon, 30 Mar 2026 14:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774879659;
	bh=MqhQRXiekbXYAnbDrF1Z48HnVe/n0wah/MTzk4wcG5M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gKZAwtRJaTlrV52BE9zrThokWXrJE2CpKfiKuLbJpjXacpX8NhgOhYNlsX8937COU
	 yOgPih7ztHMhjJ9zNcZhygbustS3wot0UPBRAnmRruezRDoHNJ0NB9tEP9JprrH5Tb
	 RWDfSiRfXugqHHh8t8u3vGFgwV6vpLDu+9/EndWkyKbF6TGPztWwJykakM4pp9mP4a
	 3tVs/L0t8io3AnrOL46ypr1Q6/QFWKVzVv7l35w56f5zBp6SWN30SkznrxqqGBYXOp
	 hu3iSCKk5IV1rqo6WjSGJoAc5C4NR5M0YxOaRaIfYE9wLd7rhhKk5WGty+ceV5MVMw
	 RPMg1mX7k6gCA==
Date: Mon, 30 Mar 2026 07:07:37 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Yi Chen <yiche@redhat.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal
 <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, Long Xin <lxin@redhat.com>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, Shuah Khan <shuah@kernel.org>, coreteam@netfilter.org,
 netfilter-devel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] selftests: netfilter: conntrack_sctp_collision.sh:
 Introduce SCTP INIT collision test
Message-ID: <20260330070737.3efec19a@kernel.org>
In-Reply-To: <20260330113509.23990-1-yiche@redhat.com>
References: <20260330113509.23990-1-yiche@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 30 Mar 2026 19:35:09 +0800 Yi Chen wrote:
> The existing test covered a scenario where a delayed INIT_ACK chunk
> updates the vtag in conntrack after the association has already been
> established.
> 
> A similar issue can occur with a delayed SCTP INIT chunk.
> 
> Add a new simultaneous-open test case where the client's INIT is
> delayed, allowing conntrack to establish the association based on
> the server-initiated handshake.
> 
> When the stale INIT arrives later, it may overwirte the vtag in
> conntrack, causing subsequent SCTP DATA chunks to be considered
> as invalid and then dropped by nft rules matching on ct state invalid.
> 
> This test verifies such stale INIT chunks do not corrupt conntrack
> state.

Now it fails in NIPA:

TAP version 13
1..1
# timeout set to 1800
# selftests: net/netfilter: conntrack_sctp_collision.sh
# Test for SCTP INIT_ACK Collision in nf_conntrack:
# Client: rcvd! 6
# Server: sent! 6
# PASS: The delayed INIT_ACK chunk did not disrupt sctp ct tracking.
# Test for SCTP INIT Collision in nf_conntrack:
# Failed to recv msg -1
# Failed to recv msg -1
# FAIL: The delayed INIT chunk did not disrupt sctp ct tracking.
not ok 1 selftests: net/netfilter: conntrack_sctp_collision.sh # exit=1
