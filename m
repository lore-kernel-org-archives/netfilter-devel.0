Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949A71D79B4;
	Mon,  6 Jan 2025 08:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736151955; cv=none; b=YsAcxbQ+dAPUAnwm/Beew/V0VhFeiZwuUagnXQRkcVxgwJl6aQWhsbet2GSR/CnAbdW8m1a7gBNen/HCu29z5QEGYSxjgCZxc8pkxyH4H8iaDimusbNuShCjzc5+zZDq48wnZb9tuTtCNRXb6pRHVWqXpXiVvIz9LQqfKnC98xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736151955; c=relaxed/simple;
	bh=XWox8SXbsO1tvSKnBhApTKkBPW8qRlOTiyjyr6b1e/A=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ohXwt267Dse7WzD1BqJB0udU2BKJMP7L6MNG3r/AEUFw8gQaDzUwCOoyJzF1wml3CQPB7MkpgK827/619W94nB0dWwn5Bmt/aBBhj9k2bZ652uO2e+80LIisqw59R6oT1vGH09W+2+qWjkBWsMVSESJTr7UUb0aubOrhIbUJnfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=K+5y7dbO; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="K+5y7dbO"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 8E2FC32E01D9;
	Mon,  6 Jan 2025 09:20:16 +0100 (CET)
Authentication-Results: smtp012.wigner.hu (amavis); dkim=pass (1024-bit key)
 reason="pass (just generated, assumed good)" header.d=blackhole.kfki.hu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=content-id:mime-version:references
	:message-id:in-reply-to:from:from:date:date:received:received
	:received:received; s=20151130; t=1736151614; x=1737966015; bh=h
	MTy6aySoRL2nI3z83EOIV4p9YPNeXMkdWm1sStVUaE=; b=K+5y7dbO4zyvF6EKB
	PXccPcYmWhBPWM3pt0Cmm5zTK1ckIyfU5PKoR0n9qcEdYAL/Ff+B0DNyqr+xqoSP
	bFChutzfxjsBcdWNmmN8FoeWk4s/cnDmzQVCSiTLH/UvebJiQljngOjF6cRJ54tE
	5tHUlSZbC4RXJL/nQCHb2hmyvI=
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id b5dKM6WQJ3Vw; Mon,  6 Jan 2025 09:20:14 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
	by smtp2.kfki.hu (Postfix) with ESMTP id EF45832E01CE;
	Mon,  6 Jan 2025 09:19:57 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id C606D34316A; Mon,  6 Jan 2025 09:19:57 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id C3DB1343169;
	Mon,  6 Jan 2025 09:19:57 +0100 (CET)
Date: Mon, 6 Jan 2025 09:19:57 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: =?ISO-8859-2?Q?Benjamin_Sz=F5ke?= <egyszeregy@freemail.hu>
cc: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>, 
    lorenzo@kernel.org, daniel@iogearbox.net, leitao@debian.org, 
    amiculas@cisco.com, kadlec@netfilter.org, 
    David Miller <davem@davemloft.net>, dsahern@kernel.org, 
    edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
    netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
    linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v6 1/3] netfilter: x_tables: Merge xt_*.h and ipt_*.h
 files which has same name.
In-Reply-To: <20250105231900.6222-2-egyszeregy@freemail.hu>
Message-ID: <8f20c793-7985-72b2-6420-fd2fd27fe69c@blackhole.kfki.hu>
References: <20250105231900.6222-1-egyszeregy@freemail.hu> <20250105231900.6222-2-egyszeregy@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="110363376-114709859-1736151517=:36632"
Content-ID: <e194de0a-f804-58bd-df39-dfae4bcbb182@blackhole.kfki.hu>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-114709859-1736151517=:36632
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-ID: <b6ca3a8f-e1e7-8b3f-4a73-8a94353ab116@blackhole.kfki.hu>
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Jan 2025, egyszeregy@freemail.hu wrote:

> From: Benjamin Sz=F5ke <egyszeregy@freemail.hu>
>
> Merge xt_*.h, ipt_*.h and ip6t_*.h header files, which has
> same upper and lower case name format.
>
> Add #pragma message about recommended to use
> header files with lower case format in the future.
>
> Signed-off-by: Benjamin Sz=F5ke <egyszeregy@freemail.hu>
> ---
> include/uapi/linux/netfilter/xt_CONNMARK.h  |  8 +++---
> include/uapi/linux/netfilter/xt_DSCP.h      | 22 ++--------------
> include/uapi/linux/netfilter/xt_MARK.h      |  8 +++---
> include/uapi/linux/netfilter/xt_RATEEST.h   | 12 ++-------
> include/uapi/linux/netfilter/xt_TCPMSS.h    | 14 ++++------
> include/uapi/linux/netfilter/xt_connmark.h  |  7 +++--
> include/uapi/linux/netfilter/xt_dscp.h      | 20 +++++++++++---
> include/uapi/linux/netfilter/xt_mark.h      |  6 ++---
> include/uapi/linux/netfilter/xt_rateest.h   | 15 ++++++++---
> include/uapi/linux/netfilter/xt_tcpmss.h    | 12 ++++++---
> include/uapi/linux/netfilter_ipv4/ipt_ECN.h | 29 ++-------------------
> include/uapi/linux/netfilter_ipv4/ipt_TTL.h | 25 ++++--------------
> include/uapi/linux/netfilter_ipv4/ipt_ecn.h | 26 ++++++++++++++++++
> include/uapi/linux/netfilter_ipv4/ipt_ttl.h | 23 +++++++++++++---
> include/uapi/linux/netfilter_ipv6/ip6t_HL.h | 26 ++++--------------
> include/uapi/linux/netfilter_ipv6/ip6t_hl.h | 22 +++++++++++++---
> net/ipv4/netfilter/ipt_ECN.c                |  2 +-
> net/netfilter/xt_DSCP.c                     |  2 +-
> net/netfilter/xt_HL.c                       |  4 +--
> net/netfilter/xt_RATEEST.c                  |  2 +-
> net/netfilter/xt_TCPMSS.c                   |  2 +-
> 21 files changed, 143 insertions(+), 144 deletions(-)

Technically you split up your single patch into multiple parts but not=20
separated it into functionally disjunct parts. So please prepare

- one patch for
 	include/uapi/linux/netfilter_ipv6/ip6t_HL.h
 	include/uapi/linux/netfilter_ipv6/ip6t_hl.h
 	net/netfilter/xt_HL.c
 	net/netfilter/xt_hl.c
 	[ I'd prefer corresponding Kconfig and Makefile changes as well]
- one patch for
 	include/uapi/linux/netfilter/xt_RATEEST.h
 	include/uapi/linux/netfilter/xt_rateest.h
 	net/netfilter/xt_RATEEST.c
 	net/netfilter/xt_rateest.c
 	[I'd prefer corresponding Kconfig and Makefile changes as well]
- and so on...

That way the reviewers can follow what was moved from where to where in a=
=20
functionally compact way.

Also, mechanically moving the comments results in text like this:

> /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> -/* ip6tables module for matching the Hop Limit value
> +/* Hop Limit modification module for ip6tables
> + * ip6tables module for matching the Hop Limit value

which is ... not too nice. The comments need manual fixing.

I also still don't like adding pragmas to emit warnings about deprecated=20
header files. It doesn't make breaking API easier and it doesn't make=20
possible to remove the warnings and enforce the changes just after a few=20
kernel releases.

Best regards,
Jozsef
--110363376-114709859-1736151517=:36632--
