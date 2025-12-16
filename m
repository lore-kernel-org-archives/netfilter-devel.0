Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D7E3624D2;
	Tue, 16 Dec 2025 13:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765892652; cv=none; b=bhA0MNxqYfbuxugHAPM0FM4pPhrtBYjMBe7yXzFcZwJ1j61Wvs1rW5MCRfZnGcDZOfNOVoGqrIZFG60eyVmty/cxCoEddjoe2BzUd0ncvy+uRsRBp46q/Fbsx+Q9Lq59adScdeLrDt8HiSBepMxNx0YTuRTx156zVPIyZZvP58M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765892652; c=relaxed/simple;
	bh=rwpSpOmsvT/7FaoN/O9aopIIw2sA4lJKYVXPdp95n0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rFUgY0qZ3UM0YAaSC8h2weR6wbhAzTLkBbjcqp20GY2vTuiZ4S+RzCamg4bMbMRc0kPsSQGrVCDznC5stZv6Ufx2ohLgZLLzR9KH2Hwih9ZxCDpPO0RS5uN84P1RUlEEhwxFwB7Z/856g67vyhTFf1LMrXaGY1yqTwYjSnqGLJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A5846605E6; Tue, 16 Dec 2025 14:44:07 +0100 (CET)
Date: Tue, 16 Dec 2025 14:44:07 +0100
From: Florian Westphal <fw@strlen.de>
To: Ricardo Robaina <rrobaina@redhat.com>
Cc: audit@vger.kernel.org, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	paul@paul-moore.com, eparis@redhat.com, pablo@netfilter.org,
	kadlec@netfilter.org
Subject: Re: [PATCH v7 2/2] audit: include source and destination ports to
 NETFILTER_PKT
Message-ID: <aUFiJ5aWIxXR0t9i@strlen.de>
References: <cover.1763122537.git.rrobaina@redhat.com>
 <0fb9e8efdc66c2bbd3d9b81e808c58407f7b4b68.1763122537.git.rrobaina@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fb9e8efdc66c2bbd3d9b81e808c58407f7b4b68.1763122537.git.rrobaina@redhat.com>

Ricardo Robaina <rrobaina@redhat.com> wrote:
> NETFILTER_PKT records show both source and destination
> addresses, in addition to the associated networking protocol.
> However, it lacks the ports information, which is often
> valuable for troubleshooting.
> 
> This patch adds both source and destination port numbers,
> 'sport' and 'dport' respectively, to TCP, UDP, UDP-Lite and
> SCTP-related NETFILTER_PKT records.
> 
>  $ TESTS="netfilter_pkt" make -e test &> /dev/null
>  $ ausearch -i -ts recent |grep NETFILTER_PKT
>  type=NETFILTER_PKT ... proto=icmp
>  type=NETFILTER_PKT ... proto=ipv6-icmp
>  type=NETFILTER_PKT ... proto=udp sport=46333 dport=42424
>  type=NETFILTER_PKT ... proto=udp sport=35953 dport=42424
>  type=NETFILTER_PKT ... proto=tcp sport=50314 dport=42424
>  type=NETFILTER_PKT ... proto=tcp sport=57346 dport=42424
> 
> Link: https://github.com/linux-audit/audit-kernel/issues/162

Acked-by: Florian Westphal <fw@strlen.de>
