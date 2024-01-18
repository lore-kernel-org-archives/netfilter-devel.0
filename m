Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656672E850;
	Thu, 18 Jan 2024 21:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705612228; cv=none; b=mYOjmvt8QKcaIEzO7R/tKXHbqpFGKEnY6hQMexL/Rg7CM/Iv7zkVzgQ+jkgOr6tUoEVCpUe97jyzbtiINyCUJYh2x/SqQg1Pktnpf6v0MA/iSBcOMUKjBt54s0q0fX28jqC+byrfRiVZ/cEj85LgsAl4FFJHJEHOYwm6AOfwUQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705612228; c=relaxed/simple;
	bh=ugmveVURm0JPowUavmPnm4X9QnKoq39xWC6H0InSvKU=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Lfgy6vb5VGPzHs9Ff0E2Ah2h5vgYm+UJgjYIN2Om3UZpmNabjSoyty8nxvL9ekcyGdzvoKKRAV88fUt+xe9chtiMCeVCCusB/2ahZ9N8lrur5iDbKeIA6qwPoMbQIZIQDjHSXMhPpdPLgtKYVgD1T/OgQ2MyMhXHo3nupvpMoPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lycadVcw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lycadVcw"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 232B8C43390;
	Thu, 18 Jan 2024 21:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705612228;
	bh=ugmveVURm0JPowUavmPnm4X9QnKoq39xWC6H0InSvKU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=lycadVcwBTziZ9gNiy85oY0eDpbEJOXaO5sQqA6OTiM5NdAXvUnNY+3rFgrqX6pvj
	 aLCBdBIXQyfR8ldoGqmFnezguPQqTwXyyWEMBug/fOvQjB8JsIVqQ/ciZQVfMUW39l
	 C52rE/mcX2f9MPKD0TcsZeynnUStZlnea30KIupZUO8Kb2RZ8EUQULKYSqxBg6yi9v
	 iHB8PzGwtc5OoEbDZtL9rj7TYQZsDTQN6feDgSwv1PxqAd2WElAJsGxV+W/amoyqFy
	 rxcIa1vS0EZUwc2iZmjeEtXk1zh1QVVTINK+ITHCEgutVH3nwGlwtGl92DOexHMUe2
	 j8pi70nmSd/pg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 08934D8C97A;
	Thu, 18 Jan 2024 21:10:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 01/13] netfilter: nf_tables: reject invalid set policy
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <170561222803.18735.2435431936867197137.git-patchwork-notify@kernel.org>
Date: Thu, 18 Jan 2024 21:10:28 +0000
References: <20240118161726.14838-2-pablo@netfilter.org>
In-Reply-To: <20240118161726.14838-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 18 Jan 2024 17:17:14 +0100 you wrote:
> Report -EINVAL in case userspace provides a unsupported set backend
> policy.
> 
> Fixes: c50b960ccc59 ("netfilter: nf_tables: implement proper set selection")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_tables_api.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net,01/13] netfilter: nf_tables: reject invalid set policy
    https://git.kernel.org/netdev/net/c/0617c3de9b40
  - [net,02/13] netfilter: nf_tables: validate .maxattr at expression registration
    https://git.kernel.org/netdev/net/c/65b3bd600e15
  - [net,03/13] netfilter: nf_tables: bail out if stateful expression provides no .clone
    https://git.kernel.org/netdev/net/c/3c13725f43dc
  - [net,04/13] netfilter: nft_limit: do not ignore unsupported flags
    https://git.kernel.org/netdev/net/c/91a139cee120
  - [net,05/13] netfilter: nfnetlink_log: use proper helper for fetching physinif
    https://git.kernel.org/netdev/net/c/c3f9fd54cd87
  - [net,06/13] netfilter: nf_queue: remove excess nf_bridge variable
    https://git.kernel.org/netdev/net/c/aeaa44075f8e
  - [net,07/13] netfilter: propagate net to nf_bridge_get_physindev
    https://git.kernel.org/netdev/net/c/a54e72197037
  - [net,08/13] netfilter: bridge: replace physindev with physinif in nf_bridge_info
    https://git.kernel.org/netdev/net/c/9874808878d9
  - [net,09/13] netfilter: nf_tables: check if catch-all set element is active in next generation
    https://git.kernel.org/netdev/net/c/b1db244ffd04
  - [net,10/13] netfilter: nf_tables: do not allow mismatch field size and set key length
    https://git.kernel.org/netdev/net/c/3ce67e3793f4
  - [net,11/13] netfilter: nf_tables: skip dead set elements in netlink dump
    https://git.kernel.org/netdev/net/c/6b1ca88e4bb6
  - [net,12/13] netfilter: nf_tables: reject NFT_SET_CONCAT with not field length description
    https://git.kernel.org/netdev/net/c/113661e07460
  - [net,13/13] ipvs: avoid stat macros calls from preemptible context
    https://git.kernel.org/netdev/net/c/d6938c1c76c6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


