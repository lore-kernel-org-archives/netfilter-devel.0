Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997C81BD9D0
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 15:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785338157; cv=none; b=XXxkWynhP2jsOa5vfhAo5tFoT/ckvfiQyiJX76x1h/Qn5qMtvfJlU95tVdmKkkTqfMpNIL968MiMAORuaHyDyHNqmKTIhYM5ru3O6RsTMi72xR4JQkAIdJmB6bBNV8Bdm96oRsQFimEgnp6RAh6Mfq1DA/Hvf931FcKk1fvoCDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785338157; c=relaxed/simple;
	bh=2xtNYJ8KiybgH8VRtLGHQ33NdS36IpWFtd5rWxyxMYE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=YHCvo4feGFPjloNLGsICZ404OP0KHIRmuCvuLjL/4Z67MITxub+h3DEYnYMfvPz+VUVuPDn3oldKH9xXX8B9mV8zwRUha7Y0kE/oE+PUA8/zrrqKUCJdiDiTZMWObCyf3rSvVU0jm53Pc7oEEOFdjVnwhLLTBkrAuPYhnDARBnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4h9Fy92My7z7s7wQ;
	Wed, 29 Jul 2026 17:05:37 +0200 (CEST)
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id fRLpt-RcSI4B; Wed, 29 Jul 2026 17:05:35 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (unknown [148.6.40.64])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 4h9Fy72hH7z7s7wP;
	Wed, 29 Jul 2026 17:05:35 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 1533F14053F; Wed, 29 Jul 2026 17:05:35 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 1224B14032E;
	Wed, 29 Jul 2026 17:05:35 +0200 (CEST)
Date: Wed, 29 Jul 2026 17:05:35 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Florian Westphal <fw@strlen.de>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ipset 0/5] ipset test updates
In-Reply-To: <20260723103504.3175-1-fw@strlen.de>
Message-ID: <b6d371b8-66ac-c2ed-8c17-5e07630c5624@netfilter.org>
References: <20260723103504.3175-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi Florian,

On Thu, 23 Jul 2026, Florian Westphal wrote:

> These are extensions to existing test cases, no tests are
> disabled and all tests are expected to pass regardless if
> the rhashtable patch set is applied or not.
> 
> 1) Introduce IPSET_MACHINE_SLOW to prevent ipset test timeouts on slow
> machines. Increase the slack value to 30s when this flag is set.
> 
> 2) Prefer tail -n in hash:net.t tests to avoid Fedora 44 error.
> 
> 3) Use diff -u instead of cmp in tests to improve error readability.
> 
> 4) Add a UaF reproducer to hash:net,iface.t. Verify that deleting
> non-existing elements fails without triggering an incorrect free.
> 
> 5) Add a test for CIDR matching with the "multi" flag in match_target.t.

Thanks! All patches are applied to the ipset git tree.

Best regards,
Jozsef

> Florian Westphal (5):
>   tests: check_extensions: introduce and use IPSET_MACHINE_SLOW
>   tests: hash:net.t: prefer tail -n
>   tests: prefer diff -u to cmp
>   tests: hash:net,iface.t: add reproducer for UaF
>   tests: match_target.t check for proper cidr matching
> 
>  tests/check_extensions | 23 +++++++++++++++++++----
>  tests/hash:net,iface.t |  5 +++++
>  tests/hash:net.t       |  2 +-
>  tests/iphash.t         |  8 ++++----
>  tests/match_target.t   | 14 +++++++++++++-
>  tests/restore.t        |  2 +-
>  6 files changed, 43 insertions(+), 11 deletions(-)
> 
> -- 
> 2.54.0
> 

-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
