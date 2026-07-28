Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2202C42AF95;
	Tue, 28 Jul 2026 14:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785247842; cv=none; b=ey6PKFBB+naxxZ57mwYQmvTfoBtV0JhrnXQ1h69j8NJLJA0PBvsxG3bHo7yj3CJYUh20TeDe5ZTM1o1Y80ouVSTBbNhhR5Mgy/C4siJ6JL1MQKVcRWgR9tw5cEC8tp4KsCtFXCbIAFql5tuuqrRRPSteilijSlK5LnpoZm8Ztjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785247842; c=relaxed/simple;
	bh=7BIKyXcNolfj3UFQxHOaxV8KrdEWKzsUgY/AtmICHdk=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Q0aWI5Gs6Nlb4kVw29EtzYbwS0THxb2SeR2+4he9yniUyn1CUAbzHM9qWhfWhXkv6tWTyNc/wg1fBViLgb07305/de5xpVYfJP++H246Li6lGK56vZfm17P//uc7r1tuPqyaVD2PEqYw/xkTlS0BYdp+b8jAAapf7tCacAWhZEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XVKEya1L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XVKEya1L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF641F000E9;
	Tue, 28 Jul 2026 14:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785247840;
	bh=iVaCwy53hmBUaxlCxBmG4Hl9XTuv+ugF/dFo+D0o8E8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=XVKEya1LLndjfw3lO+XczHZJzPnYK0P7+ZIbLDufCLBjMeEoYw2dzNU5dO/v4AlCW
	 S3QB4Bdf40wr8+mjUjjATIX/9QpCGVzzyh/h9raQEpU+cNYEkELOjHf9YAeJrJyjuS
	 Wp4YIy+a6JZunfsTdinQRaWrN+qiCX7ud1VhAPfJEHh7TVw3kWzbtYf6LGbUeMuev4
	 4SP9C2sno6kW2cUdBd+SbnpVQrXbxSqq+aOdSVkHD4UCTPPbsGOPxK4eP8AK8COISn
	 +qcz9Ln8QjK4y2+U41byGGUbP1owjqDKxzV41Qp8nkYJYe/fXmQ6gcp3GnHaACmmHZ
	 7Xny7wFJmUJbA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0B6B380DBDD;
	Tue, 28 Jul 2026 14:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net: ip6_tunnel: use tunnel parameters for
 fill_forward_path route lookup
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178524780539.1745925.14296777057368080591.git-patchwork-notify@kernel.org>
Date: Tue, 28 Jul 2026 14:10:05 +0000
References: 
 <20260724-ip6ip6-route-lookup-fill_forward_path-v3-1-7b7991538614@kernel.org>
In-Reply-To: 
 <20260724-ip6ip6-route-lookup-fill_forward_path-v3-1-7b7991538614@kernel.org>
To: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: dsahern@kernel.org, idosch@nvidia.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 pablo@netfilter.org, fw@strlen.de, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 24 Jul 2026 09:25:00 +0200 you wrote:
> Reuse the flowi6 template t->fl.u.ip6 built by ip6_tnl_link_config() in
> ip6_tnl_fill_forward_path(), aligning the fast-path route lookup with
> the slow path in ipxip6_tnl_xmit(). This automatically inherits the
> correct conditional FLOWLABEL masking based on the
> IP6_TNL_F_USE_ORIG_FLOWLABEL flag.
> 
> Return -EOPNOTSUPP when IP6_TNL_F_USE_ORIG_TCLASS,
> IP6_TNL_F_USE_ORIG_FLOWLABEL or IP6_TNL_F_USE_ORIG_FWMARK is set,
> or for collect_md tunnels, since fill_forward_path has no access to
> the original skb and cannot recover the per-packet traffic class,
> flowlabel, mark or tunnel destination needed for the route lookup.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: ip6_tunnel: use tunnel parameters for fill_forward_path route lookup
    https://git.kernel.org/netdev/net-next/c/b515dc54795e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


