Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B65239B4A5;
	Thu, 26 Feb 2026 14:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772114402; cv=none; b=iVmSNMP4mr+ofYREXWyv0kxR9ht9siTGC5LnTntLLGaDB4D4IIo48Mc3YmMA28uBcIkw7dSTAy6AmvFYSfOncOzCGF8DwGf8MUTmd2AmD3s7h5FHsdidrfcgfgFKeYgzD1slu5Tj8wNtocgdbKblR/kfhgeZwSADn9NcXXbhclQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772114402; c=relaxed/simple;
	bh=kY839M1FiQyG/rTWUN37NiUx9KNkhkKWxJrdxAzSGjE=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Ll/F9omib+bHfydnaxWQgv4TV+5P/uX4/Ub0TGR7Ur2T6DubB1XKUDB81TTk8SYtCziZZZ2xOhD/f5Cp9UUZ2j+FXkAc0VMmuYbGg0G7wnHJoWbPY6F3XQS0c6Yb2m6QHxn8CGbX8u6J9il/Zy88wxQR/WM1oiaZzsyBrm6Lmt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MNXSi6NZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MNXSi6NZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382FFC116C6;
	Thu, 26 Feb 2026 14:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772114401;
	bh=kY839M1FiQyG/rTWUN37NiUx9KNkhkKWxJrdxAzSGjE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=MNXSi6NZIZEHa6c4wrlYy6s6gHYzD3uENmadJrr/NnTggjNGK0rOT1Cv4qN990HkY
	 8nd0SPqFzWvwgcoPIAV4x+rGkSpbJzcclgmeCukhDFxj+NevfRRnyOY+sDiCN90CpI
	 m3OfH7KUeu4ka5WPBmCg7SmjfX3Whkv/y4z37zTpJrVITwYmFE5UuG/6y4pOSAKxI+
	 kCMplXRj+zOyJJGHFMBxVaVEYxTemc6Ikfy/W2490G3+7qAcNEDgkCWArH/EmC97Dx
	 aS030HX1TVyfk895tW10gOxcLDBaQWaSDhSL3icE/PQ+TcqBBrZNr4/r/TRUIW5rUU
	 4BfHXwr9/UHsg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FF373930925;
	Thu, 26 Feb 2026 14:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] netfilter: nf_conntrack_h323: fix OOB read in
 decode_choice()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177211440505.1230752.18207522034751824623.git-patchwork-notify@kernel.org>
Date: Thu, 26 Feb 2026 14:00:05 +0000
References: <20260225130619.1248-2-fw@strlen.de>
In-Reply-To: <20260225130619.1248-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 25 Feb 2026 14:06:18 +0100 you wrote:
> From: Vahagn Vardanian <vahagn@redrays.io>
> 
> In decode_choice(), the boundary check before get_len() uses the
> variable `len`, which is still 0 from its initialization at the top of
> the function:
> 
>     unsigned int type, ext, len = 0;
>     ...
>     if (ext || (son->attr & OPEN)) {
>         BYTE_ALIGN(bs);
>         if (nf_h323_error_boundary(bs, len, 0))  /* len is 0 here */
>             return H323_ERROR_BOUND;
>         len = get_len(bs);                        /* OOB read */
> 
> [...]

Here is the summary with links:
  - [net,1/2] netfilter: nf_conntrack_h323: fix OOB read in decode_choice()
    https://git.kernel.org/netdev/net/c/baed0d9ba91d
  - [net,2/2] netfilter: nf_tables: unconditionally bump set->nelems before insertion
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


