Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BD9657C6;
	Thu, 28 Mar 2024 09:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711619430; cv=none; b=XcAAi26Q02yogxl79zzbGAuiMNCfQkRosC6nSb+Xv/9RPaWWYCvtqmRudEdVm/2WUnq6mGXLXI6IwNU5fjACB8qpG6fGAkCbxMvsg+q9eEGQ1BnkpnZHdMdP6BoODl2LOGrnHx7iu28N1EY3N2JZVZwGvIHLe3dT58q6l7RSuwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711619430; c=relaxed/simple;
	bh=T/OibAZwWOIloOVhxmID1Y6yFKccDxG8AzFj3qVJeuA=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=oCMyOKKez5cMOWrPhCJ2vcKBE45WB+MCdKhqseOETHfZdA4Drart5XqytpEonIu3dAu3XpH/lXlEYCszAvCg/IJ78ugDY4FlBJ08wy60gkeDI5aXsbQYt5F5KFIc7Qxz2uawY9sKwasOpjulgp2/2rktSqzizI1qnBCFiWt4AHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J4DbqByj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J4DbqByj"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 47BFDC433C7;
	Thu, 28 Mar 2024 09:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711619430;
	bh=T/OibAZwWOIloOVhxmID1Y6yFKccDxG8AzFj3qVJeuA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=J4DbqByjuRHbAFJNQ4TETVv3m0pjAEPYKZoDSwhVk7Xfv+nDwZXGN1zqjLMGl+kba
	 iMC76bZ65By4/czPbwVEfMlO5yi74cgTLAeoM1K5af3T5bkx+9Q2bN2R369gZ4m7oW
	 ksM/rTDLRQTITgadNB0ac697ivcyGE2kkndMUm90hPCg92eaiNsorHSxAOQzAbxKul
	 fw4gjMmyktQ17dPAeMSS+eW0UWv8NqEopdJ5nQ9lqAdSyy/QBXXpX+R7SnnTrb2EEj
	 20L5DqeNYhgy/zPqk5VkKKogai7w0vavOmV0ByKaoD7k9Ui8SlKArGVBAlQKF7IQXm
	 v8y63edg1erlw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 35FBCC43168;
	Thu, 28 Mar 2024 09:50:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/4] netfilter: nf_tables: reject destroy command to
 remove basechain hooks
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171161943021.10354.8421836895816515032.git-patchwork-notify@kernel.org>
Date: Thu, 28 Mar 2024 09:50:30 +0000
References: <20240328031855.2063-2-pablo@netfilter.org>
In-Reply-To: <20240328031855.2063-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 28 Mar 2024 04:18:52 +0100 you wrote:
> Report EOPNOTSUPP if NFT_MSG_DESTROYCHAIN is used to delete hooks in an
> existing netdev basechain, thus, only NFT_MSG_DELCHAIN is allowed.
> 
> Fixes: 7d937b107108f ("netfilter: nf_tables: support for deleting devices in an existing netdev chain")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_tables_api.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net,1/4] netfilter: nf_tables: reject destroy command to remove basechain hooks
    https://git.kernel.org/netdev/net/c/b32ca27fa238
  - [net,2/4] netfilter: nf_tables: reject table flag and netdev basechain updates
    https://git.kernel.org/netdev/net/c/1e1fb6f00f52
  - [net,3/4] netfilter: nf_tables: skip netdev hook unregistration if table is dormant
    https://git.kernel.org/netdev/net/c/216e7bf7402c
  - [net,4/4] netfilter: arptables: Select NETFILTER_FAMILY_ARP when building arp_tables.c
    https://git.kernel.org/netdev/net/c/15fba562f7a9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


