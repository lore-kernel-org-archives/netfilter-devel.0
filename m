Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A63C1F8EF7;
	Fri, 27 Dec 2024 19:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735327814; cv=none; b=lY1YL4YMp+FSLoBN09WAMpaWkX8NpGNosiAdKOma2gPM+HvjcFufyy3P3f27JFTODoyIxhJRrQKB7nPcR8RtDLxGF/YhflfkjS5jQT5sfOmrO379VFqRCQWDemKLQXcE28We3ZyPzjOu8R0dsndkaLT5utUNBjoUVI2kXLauqxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735327814; c=relaxed/simple;
	bh=RLmpCa5uCH37jWy6Jde7G4pkvf5yk45oLbgCIsA4I1I=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=ZKHInnDOmYJip0r3LgSnWwDQfW/3o5eYQY1LB9a7CWk9Cjhe7W396OmNJxEwnCR05zGKotxV77i1+bBFIMHDjVu8/BHtsfLgpQBjvulXf62MiSbOCfZAh2nQKplG8faN7t1wyz1TrWFzRCjER36yVOUN/KSkiH0qKCw/P1dihfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=njNML299; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="njNML299"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF20C4CED7;
	Fri, 27 Dec 2024 19:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735327814;
	bh=RLmpCa5uCH37jWy6Jde7G4pkvf5yk45oLbgCIsA4I1I=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=njNML299h/DKrnYZ0JRXiY5WFN8pBDLU7n9JTvbF1WHrww6aZXwyjBSxwv/0WUn+c
	 i017vqZgo9RqfL8Zc7Ax80KW9HrTOUtDtPFpPBOuBT9A1Hze7xK4+Ez1OmvcQJ9PyA
	 Y2kXwN1m8zVqrM4oyeXercKZpIJxnTNCy8i1tQ1RQRSzfmJIHyyyHXkiomshNQt6nA
	 Hi3bLXxdOxoUM5zOqIXY94ZJQ5v8FSDLKFHiw/uPFd0eIAObPy2oZEnjPRRdY1D3mc
	 8Hzr5PLBHFe7yQ0Gb9+4IJWfBvV7Zaieafmm9mrvtnNhS2K6VWrzqqHsCAdYPVQpCm
	 1vZ8befVVFbkg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADF36380A955;
	Fri, 27 Dec 2024 19:30:34 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] netfilter: nft_set_hash: unaligned atomic read on
 struct nft_set_ext
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <173532783326.575952.10054959797617516458.git-patchwork-notify@kernel.org>
Date: Fri, 27 Dec 2024 19:30:33 +0000
References: <20241224233109.361755-2-pablo@netfilter.org>
In-Reply-To: <20241224233109.361755-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This patch was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed, 25 Dec 2024 00:31:09 +0100 you wrote:
> Access to genmask field in struct nft_set_ext results in unaligned
> atomic read:
> 
> [   72.130109] Unable to handle kernel paging request at virtual address ffff0000c2bb708c
> [   72.131036] Mem abort info:
> [   72.131213]   ESR = 0x0000000096000021
> [   72.131446]   EC = 0x25: DABT (current EL), IL = 32 bits
> [   72.132209]   SET = 0, FnV = 0
> [   72.133216]   EA = 0, S1PTW = 0
> [   72.134080]   FSC = 0x21: alignment fault
> [   72.135593] Data abort info:
> [   72.137194]   ISV = 0, ISS = 0x00000021, ISS2 = 0x00000000
> [   72.142351]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
> [   72.145989]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
> [   72.150115] swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000237d27000
> [   72.154893] [ffff0000c2bb708c] pgd=0000000000000000, p4d=180000023ffff403, pud=180000023f84b403, pmd=180000023f835403,
> +pte=0068000102bb7707
> [   72.163021] Internal error: Oops: 0000000096000021 [#1] SMP
> [...]
> [   72.170041] CPU: 7 UID: 0 PID: 54 Comm: kworker/7:0 Tainted: G            E      6.13.0-rc3+ #2
> [   72.170509] Tainted: [E]=UNSIGNED_MODULE
> [   72.170720] Hardware name: QEMU QEMU Virtual Machine, BIOS edk2-stable202302-for-qemu 03/01/2023
> [   72.171192] Workqueue: events_power_efficient nft_rhash_gc [nf_tables]
> [   72.171552] pstate: 21400005 (nzCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
> [   72.171915] pc : nft_rhash_gc+0x200/0x2d8 [nf_tables]
> [   72.172166] lr : nft_rhash_gc+0x128/0x2d8 [nf_tables]
> [   72.172546] sp : ffff800081f2bce0
> [   72.172724] x29: ffff800081f2bd40 x28: ffff0000c2bb708c x27: 0000000000000038
> [   72.173078] x26: ffff0000c6780ef0 x25: ffff0000c643df00 x24: ffff0000c6778f78
> [   72.173431] x23: 000000000000001a x22: ffff0000c4b1f000 x21: ffff0000c6780f78
> [   72.173782] x20: ffff0000c2bb70dc x19: ffff0000c2bb7080 x18: 0000000000000000
> [   72.174135] x17: ffff0000c0a4e1c0 x16: 0000000000003000 x15: 0000ac26d173b978
> [   72.174485] x14: ffffffffffffffff x13: 0000000000000030 x12: ffff0000c6780ef0
> [   72.174841] x11: 0000000000000000 x10: ffff800081f2bcf8 x9 : ffff0000c3000000
> [   72.175193] x8 : 00000000000004be x7 : 0000000000000000 x6 : 0000000000000000
> [   72.175544] x5 : 0000000000000040 x4 : ffff0000c3000010 x3 : 0000000000000000
> [   72.175871] x2 : 0000000000003a98 x1 : ffff0000c2bb708c x0 : 0000000000000004
> [   72.176207] Call trace:
> [   72.176316]  nft_rhash_gc+0x200/0x2d8 [nf_tables] (P)
> [   72.176653]  process_one_work+0x178/0x3d0
> [   72.176831]  worker_thread+0x200/0x3f0
> [   72.176995]  kthread+0xe8/0xf8
> [   72.177130]  ret_from_fork+0x10/0x20
> [   72.177289] Code: 54fff984 d503201f d2800080 91003261 (f820303f)
> [   72.177557] ---[ end trace 0000000000000000 ]---
> 
> [...]

Here is the summary with links:
  - [net,1/1] netfilter: nft_set_hash: unaligned atomic read on struct nft_set_ext
    https://git.kernel.org/netdev/net/c/542ed8145e6f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


