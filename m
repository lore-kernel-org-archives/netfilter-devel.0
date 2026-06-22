Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4BD29CB24;
	Mon, 22 Jun 2026 23:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782169826; cv=none; b=RsQ2+WzX3OJhoU5tuwIYcwLTG3KVIoryjNPNwxdEBVxFudS8Dsk3l6PZ6XskQVR7K8/iJ1ld+sJTU3NCZ8ArTFigU3sHV08tYZm87kuAzVlLx4ED9729X9Mks2EBFI+JN1xokLzdam5du3GfxbWAPMj7GkOUjJpmxEmxsE1N4VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782169826; c=relaxed/simple;
	bh=STEl2Z4kxI31gKGBfK6tI5IIEAw0GWWLYzl89Bb6H/s=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=ZiV99OGY7sDACqV2df6vcRqZ52ml2POhfpkOASDHp/1CNmX9wYLgXC2/mpgARARaHuK4g48FX2WZ51vRAU2LsQ33RZbo+/KK19YicUzEJcIAescC1i8WtiYdfhlmrOL8Mqq7DvPCaHMR8n4FyZT6cMJUdbOSThmGkXy1HzMWqtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YvFK7JRp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YvFK7JRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D27D1F000E9;
	Mon, 22 Jun 2026 23:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782169824;
	bh=BS9saIHILXZPG3mQmL5nkidGhQkkaqt9SX8BVeZ56Hw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=YvFK7JRpQN8Qgv5LGY1fk35fwyKlLYjlyML2+zEiUpUDhDFqzM2+qGLv4UWx8w6w4
	 ys8qHvyQkW0BIcgXZW5bcC8xAwraAeH2Hx/iomYHdaD2lZ1L6S1o5anEWZWrRcIKjj
	 GqHFHWYx8wM62CWVcS58nv+5sDR3Y+4cdCwMcsa7PfxU8Os5YM6kZAfDTJ3n71WdSw
	 eFnct4qA3MtMNLGcA+dj+150UIF+MQvlLFuzAZJAT24QoKU+TJ1W91d7+/p8KlpXxe
	 bvlzGSw54QFQm2OfqF+IEhHnMj8lx5BOAYXNCc9CR0cp3RDLSRz1V6KcinRCuYhu3c
	 OoiONX7C+peAA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19917393098A;
	Mon, 22 Jun 2026 23:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2 0/2] bpf: Guard conntrack opts error writes
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178216981480.1454866.14973638867733224422.git-patchwork-notify@kernel.org>
Date: Mon, 22 Jun 2026 23:10:14 +0000
References: <cover.1781765747.git.chenyy23@mails.tsinghua.edu.cn>
In-Reply-To: <cover.1781765747.git.chenyy23@mails.tsinghua.edu.cn>
To: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
Cc: bpf@vger.kernel.org, netfilter-devel@vger.kernel.org, pablo@netfilter.org,
 fw@strlen.de, phil@nwl.cc, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, andrii@kernel.org,
 eddyz87@gmail.com, ast@kernel.org, daniel@iogearbox.net, memxor@gmail.com,
 martin.lau@linux.dev, song@kernel.org, yonghong.song@linux.dev,
 jolsa@kernel.org, emil@etsalapatis.com, shuah@kernel.org,
 kartikey406@gmail.com, coreteam@netfilter.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org

Hello:

This series was applied to bpf/bpf.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Thu, 18 Jun 2026 10:18:42 +0000 you wrote:
> The conntrack lookup/allocation kfuncs expose an opts/opts__sz pair.
> The verifier checks the caller-provided opts__sz range, but the wrappers
> currently write opts->error after internal errors even when opts__sz is too
> small to include that field.
> 
> Patch 1 writes opts->error only when opts__sz includes it, and uses a
> single helper to fold ERR_PTR returns into the kfunc ABI result while keeping
> the local nfct result variable in each wrapper.
> Patch 2 adds a bpf_nf regression check that keeps a guard in opts->error
> while passing opts__sz covering only netns_id.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2,1/2] bpf: Guard conntrack opts error writes
    https://git.kernel.org/bpf/bpf/c/6f6183a39533
  - [bpf-next,v2,2/2] selftests/bpf: Cover small conntrack opts error writes
    https://git.kernel.org/bpf/bpf/c/38ba6d43af38

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


