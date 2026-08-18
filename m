Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9619F33F58B
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Aug 2026 08:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787040265; cv=none; b=DddpErkQN88V+NOqG6D7SRFyO3k/2NmGD1cRj12GaR7XpPcrGv2LA2+QHhIgSuRjD7HUbPgLw19C2NhBmRCK+eBZI7OIMcS4RW59ptZcUARiSc/Jdk+s+tQoIWwlpe5LNblBaCrbAjeOI20i5hjTZFCDKmG4hVTqySK4zALWNOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787040265; c=relaxed/simple;
	bh=LKrN61ccwGYTuqJKWPzFwonmpu5oedMbHNhJHDPWLYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uhjkv1BCAzV/9lUaGVP5FQOuYUJyydQFkeu9yUd6tk4orEUuL+AHl8b6zRubLE5sM6KntD2gqMFzllE5fxUr5t1XRTm4NB1vaRd/KWk5WDu4SV9/Es/FBaIcFXFvSHjPGJxy/d4kfllic61Ai4+88Ln1/iKHqBO1tc0JfKC7axk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NVquhfh9; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NVquhfh9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787040259;
	bh=IbBZgpWAUzspFh6vL8velDUd0l8UyyrUxMt4dEF2Mzs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NVquhfh9Rt5JKC1l9bkZr1VNnGOvQCJMpDSowqNe4vNBLGFA+SyPCeH+EOx4C1F1g
	 VPOmWh0mwz2cSBwIigMyhtAHzLf79/vp7+BAjSJVn/vRxHPVQuP8BmC0+r2rIn34hL
	 G+k7AJwsqumz8aBTzpotES2Y6FSBijogoWMt5LNX1gUj/eano1rbu7hjFXPpH92Eg1
	 hKUPykgPQYZox9bB/juYr9pWRm4VWHUXTGk7Og78RKHjMYMQ/1ohD6+in4s8Zte4m7
	 O/YjSZ4l+zPFkIoV+a7A+YQvTaknLkd3OFKVqrm80/LIbkixS0puV0EEpxoPm17S51
	 wKXiRAr5frwAw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 5863660057;
	Tue, 18 Aug 2026 10:04:19 +0200 (CEST)
Date: Tue, 18 Aug 2026 10:04:17 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ren Wei <weir@nebusec.ai>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org, luciano.coelho@nokia.com,
	kaber@trash.net, quic_manojbm@quicinc.com,
	quic_subashab@quicinc.com, vega@nebusec.ai, rakukuip@gmail.com
Subject: Re: [PATCH nf 0/1] netfilter: xt_IDLETIMER: fix out-of-bounds heap
 read in checkentry
Message-ID: <aoQSAcH4DzbI9riA@chamomile>
References: <cover.1786933680.git.rakukuip@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1786933680.git.rakukuip@gmail.com>

On Tue, Aug 18, 2026 at 09:56:47AM +0800, Ren Wei wrote:
> From: Luxiao Xu <rakukuip@gmail.com>
> 
> Hi Linux kernel maintainers,
> 
> We found and validated an issue in net/netfilter/xt_IDLETIMER.c. The bug is reachable by a non-root user via user and net namespace.
> We've tested it, and it should not affect any other functionality.
> 
> We will provide detailed information about the bug in this email, along with a PoC to trigger it.
> 
> ---- details below ----
> 
> Bug details:
> 
> Both `idletimer_tg_checkentry()` and `idletimer_tg_checkentry_v1()` in `net/netfilter/xt_IDLETIMER.c` invoke `pr_debug("checkentry targinfo%s\n", info->label)` before `idletimer_tg_helper()` validates whether the 28-byte user-controlled `info->label` buffer is properly NUL-terminated.
> 
> When an unprivileged user creates a user + network namespace (`unshare -Urn`), they obtain namespaced `CAP_NET_ADMIN` and can invoke `setsockopt(..., IPT_SO_SET_REPLACE, ...)` with a custom `label` containing no NUL byte.

You have to enable pr_debug to trigger this, you cannot do it from
from user namespace.

