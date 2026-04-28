Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0D843E489;
	Tue, 28 Apr 2026 14:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777385209; cv=none; b=m38rfhK1vQhfE1KB+T0HVlhxytvghPwNo8hoSVOeu2vseomJy3koW0kUH/WEOB1Ni/N9qWBRZk42O0tY/4R0RreZy0C00jM2xpEcQBhPTrZ2OwcWsnVngv1lIgFJxKW+aGwGP6Xw3yfMVkjo3U0tsVm4UY1L5OY8cos4vzdA9G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777385209; c=relaxed/simple;
	bh=MpYhIos3QpHd5ZcbWIvroPNEGS+XcMgFqE/2NWB8hdQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ajOEfEJluMEFGRArGiDfZa2G6GtMP73R9/cnFSUicwSHQ5emUNb4fPq2QtjLYscxTzYqWxXrhqjmWd+3tvJoCqCcxfxQQRFIJOSZQQNW705LoMwCByugEAWyYgaMqOZrAHyWn199QqLUtrMyT3HO2m55P1q2tFtLP9gGprFcbCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h3coAnL6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h3coAnL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02431C2BCAF;
	Tue, 28 Apr 2026 14:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777385209;
	bh=MpYhIos3QpHd5ZcbWIvroPNEGS+XcMgFqE/2NWB8hdQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h3coAnL6W7rY0i9VOTXWvINjr/QhnH/y7s7vifxvPC9UI/fBCNTTK20YYDXwmrOiP
	 w0tLPdHhR9yOKvO2F+6BW6nSAghCC6Quvz71joY+6wPurV0SB/q4MjPGOwWd44PoAw
	 iN2KgLB5zVM3x2msKOXt/n1/r/lvvtw+JbKK4CHaxFJEWptm5dsw7dKwxy6BxCvEZ6
	 q7DwqgSMaia5es0cRID69Mz1AOCKdUDerz82e4tDAXYlx0qneJn2QsWt/+Nt2byDcv
	 Q5vBiAnC876ouq/ej19YoOY7PclEf2omu0QMFfZQRlEZugXPJqx6VqocWhwymrNMQ6
	 tqJOicddsMaOA==
Date: Tue, 28 Apr 2026 15:06:42 +0100
From: Simon Horman <horms@kernel.org>
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
	linux-sctp@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Yi Chen <yiche.cy@gmail.com>
Subject: Re: [PATCH net v2 0/2] sctp: fix a vtag verification failure caused
 by stale INITs
Message-ID: <20260428140642.GT900403@horms.kernel.org>
References: <cover.1777214801.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1777214801.git.lucien.xin@gmail.com>

On Sun, Apr 26, 2026 at 10:46:39AM -0400, Xin Long wrote:
> Similar to Scenario B in commit 8e56b063c865 ( netfilter: handle the
> connecting collision properly in nf_conntrack_proto_sctp"):
> 
> Scenario B: INIT_ACK is delayed until the peer completes its own handshake
> 
>   192.168.1.2 > 192.168.1.1: sctp (1) [INIT] [init tag: 3922216408]
>     192.168.1.1 > 192.168.1.2: sctp (1) [INIT] [init tag: 144230885]
>     192.168.1.2 > 192.168.1.1: sctp (1) [INIT ACK] [init tag: 3922216408]
>     192.168.1.1 > 192.168.1.2: sctp (1) [COOKIE ECHO]
>     192.168.1.2 > 192.168.1.1: sctp (1) [COOKIE ACK]
>   192.168.1.1 > 192.168.1.2: sctp (1) [INIT ACK] [init tag: 3914796021] *
> 
> There is another case:
> 
> Scenario F: INIT is delayed until the peer completes its own handshake
> 
>   192.168.1.2 > 192.168.1.1: sctp (1) [INIT] [init tag: 3922216408]
>   (OVS upcall)
>     192.168.1.1 > 192.168.1.2: sctp (1) [INIT] [init tag: 144230885]
>     192.168.1.2 > 192.168.1.1: sctp (1) [INIT ACK] [init tag: 3922216408]
>     192.168.1.1 > 192.168.1.2: sctp (1) [COOKIE ECHO]
>     192.168.1.2 > 192.168.1.1: sctp (1) [COOKIE ACK]
>   192.168.1.2 > 192.168.1.1: sctp (1) [INIT] [init tag: 3922216408]
>   (delayed)
>   192.168.1.1 > 192.168.1.2: sctp (1) [INIT ACK] [init tag: 3914796021] *
> 
> In this case, the delayed INIT (e.g. due to OVS upcall) is recorded by
> conntrack, which prevents vtag verification from dropping the unexpected
> INIT-ACK in nf_conntrack_sctp_packet():
> 
>   vtag = ct->proto.sctp.vtag[!dir];
>   if (!ct->proto.sctp.init[!dir] && vtag && vtag != ih->init_tag)
>           goto out_unlock;
> 
> This happens because ct->proto.sctp.init[!dir] is set by the delayed INIT,
> even though it is stale.
> 
> Fix this in two parts:
> 
> - In netfilter: Do not record INITs whose init_tag matches the peer vtag,
>   as they carry no new handshake state in the 1st patch.
> 
> - In SCTP: Prevent endpoints from responding to such INITs with INIT-ACK,
>   ensuring correctness even when middleboxes lack the netfilter fix in
>   the 2nd patch.
> 
> A follow-up selftest for this scenario will be posted in a separate patch
> by Yi Chen.

Hi Xin,

FTR: There is an AI generated review of this patchset available on
sashiko.dev. I have looked over this and I do not believe the feedback
there should block progress of this patchset.
