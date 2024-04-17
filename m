Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E39B6A353;
	Wed, 17 Apr 2024 09:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713347430; cv=none; b=ZBw9AI1g/aLlnaRBE0TZT7v5tSqCeQTGim/qdlqr2JdPs5PMaBR61rrkusrhfnO4TZrfHO2yYzAkdCKGjz5EK7BX9ePD4d8BCS7qohZEKaGNsZ8Eryg4L48hqNX8ng9PRhskFVJBbF9jw4naiRe6YNnxNNYKl7D0vGQ/bNHHql8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713347430; c=relaxed/simple;
	bh=9m38jLti7vEEOVjNiPOKf79/T9Jgd9GGlaJEsAlaI5g=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=nPclXTbRrioEjVtusa5SDDyd+4VY0P23VKUGL+teQTW2Ah4RVwEPMOdDeTRbBeknJTkOSkoEJdAGjvXMpgRT35q5jnFwl+ahibMin66AMshjx/6RAgXT/rO7g4JoXzQHiGELo5v6bgNElEK7nB9yTgaMhkhDVW+YMt0T63IpTTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I4kTAL/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I4kTAL/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPS id CC331C32786;
	Wed, 17 Apr 2024 09:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713347429;
	bh=9m38jLti7vEEOVjNiPOKf79/T9Jgd9GGlaJEsAlaI5g=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=I4kTAL/YO5Ku5t0wRFlTJWKi4ESGaBBp75VwQWeepOEwPGJMNpM/yIe9RIqekQDIK
	 F0Tad3DLUJx32/mt0dZsCQNAdBsR591gdSQ9FJsPX+vhvA6K5hDt61ILW8zgF07mqj
	 zKMJ5Dl5b0JpBjJfzhV+LE24naIMz1tWhWNcA+lRTWUUq8vNntAm4qoAUARYQQXzbK
	 wP/umc1d8AohwIk0GJK8SeqX4y9JnfPMVB1i8t/MAtsgw4pcp8fap19K3ouQf3P15a
	 S7yoqYJN5O2D9tDOGVJ058rfPHnbhgSgXOJ8tChAV8BuoNlYewjE1+/DinmldkF/jg
	 FrWUzEKTqM5mQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BAABEC54BB3;
	Wed, 17 Apr 2024 09:50:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: fix netfilter path in Makefile
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171334742976.18271.5668344541939574035.git-patchwork-notify@kernel.org>
Date: Wed, 17 Apr 2024 09:50:29 +0000
References: <20240416053210.721056-1-yujie.liu@intel.com>
In-Reply-To: <20240416053210.721056-1-yujie.liu@intel.com>
To: Yujie Liu <yujie.liu@intel.com>
Cc: netdev@vger.kernel.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
 pabeni@redhat.com, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pablo@netfilter.org, lkp@intel.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 16 Apr 2024 13:32:10 +0800 you wrote:
> Netfilter tests have been moved to a subdir under selftests/net by
> patch series [1]. Fix the path in selftests/Makefile accordingly.
> 
> This helps fix the following error:
> 
>     tools/testing/selftests$ make
>     ...
>     make[1]: Entering directory 'tools/testing/selftests'
>     make[1]: *** netfilter: No such file or directory.  Stop.
>     make[1]: Leaving directory 'tools/testing/selftests'
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: fix netfilter path in Makefile
    https://git.kernel.org/netdev/net-next/c/9ef1ed26a67b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


