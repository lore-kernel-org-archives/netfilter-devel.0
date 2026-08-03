Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D9C3368B7
	for <netfilter-devel@vger.kernel.org>; Mon,  3 Aug 2026 18:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785781948; cv=none; b=NUxCIx4d40Ok2qn+l6ndo9yvsMp+P1E0+RyPghhGaaLNyA/afn8X/lwW9t8wutxaf0/42lKuyXenrxTMh38ZIKms1K3IU9Yp8kOPloJB7HrFWIcl4Qun1CEhtUKzDcoFKqgn0cLXrBwHqM0STLhWrVzberk441JGkrfkX4LrPZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785781948; c=relaxed/simple;
	bh=1YLPD34mDOJgzlHQalJZ4k9whj3JrExeKSbQStjjpsE=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jcxzvg7TaW/mxqUK4Zwu6g+xckMEeDRJx4LPZwGkQYJhIJL2J1/SoXdeRp4QIxci9xY0a/v2f23uY9dYz3bhrfCSSqDMaiV7uQAkangXm0Otk+k+FKGwXEj+VXS6unfGq7FE/YcHPU6A9yq5xokpJEDak+0+0X9aOasCdjuNK8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B15E16059E; Mon, 03 Aug 2026 20:32:23 +0200 (CEST)
Date: Mon, 3 Aug 2026 20:32:22 +0200
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nfnetlink_log: wait for rcu grace period
 before freeing pernet state
Message-ID: <anDetoVAYqu0Hv2I@strlen.de>
References: <20260803084329.10282-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803084329.10282-1-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> sashiko reports: "nfnl_log_net_exit() calls nf_log_unset(), which
> clears the logger pointer without an RCU grace period.  Immediately after,
> ops_free_list() frees the per-net state while concurrent packets might
> still be executing nf_log_packet() under rcu_read_lock()."
> 
> Clear the pointer via .pre_exit to make sure rcu readers have completed
> before pernet storage is free'd.  The change in nf_log_syslog.c is only
> done for consistency: it doesn't use pernet data.

Forgot to add:
Fixes: 9368a53c471b ("netfilter: nfnetlink_log: add net namespace support for nfnetlink_log")

The sashiko review can be ignored, its correct but there is a pending
ebt_nflog patch that resolves the issue.
