Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C803E1F3FE8
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Mar 2025 20:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741896702; cv=none; b=d2v5f3kxCdvvmx+n3xEk3Rsro0PxMa4iEP4hUN3a4Qr8GoMm0uJIE3Zqk9hRbj8tES9ny9fpFgZg9scMDcrqdbZ9PqHQw7pNDrm0ZX9QcPL+qZipe3wqgGub8U5rssMes6W4QJby53oPbbMqYqEq3NZXeqNxOqmazSJGS1HSMJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741896702; c=relaxed/simple;
	bh=/5Sgix6uGWbYm5YW4ZnPz5sTIEv3C/XlEVBUIEx7gx0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H2dWNIpBt7zqHQPOmszm1US1w/23KQXOdD+b/OmJMD82mTiux3MeiDwm8yEpY4FTmkV3RyToZco7C8OPpGOgTd1YZkFtuJ1e2ajC5w1wUTI4B/wJl7T1tffUj8bbVHag59BqIYCd0JsFRE8IxV4nqOI0CaAbrLPaMME0XFkY1yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tsoty-0006uq-85; Thu, 13 Mar 2025 21:11:34 +0100
Date: Thu, 13 Mar 2025 21:11:34 +0100
From: Florian Westphal <fw@strlen.de>
To: William Stafford Parsons <entrocraft@gmail.com>
Cc: pablo@netfilter.org, p.ozlabs@nwl.cc, regit@netfilter.org,
	kadlec@blackhole.kfki.hu, fw@strlen.de,
	netfilter-devel@vger.kernel.org
Subject: Re: Replacing DJB2 Hash
Message-ID: <20250313201134.GA26508@breakpoint.cc>
References: <CANBG-UO0xoUQq_yah=mLQWfvNQQwJng8y5UPkMSF9daYfQGe-g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANBG-UO0xoUQq_yah=mLQWfvNQQwJng8y5UPkMSF9daYfQGe-g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

William Stafford Parsons <entrocraft@gmail.com> wrote:
> Hi Core Netfilter Team,
> 
> I'm messaging you directly with a critical, simple patch suggestion.
> 
> I registered with the username *Eightomic*, but I'm having some issues
> installing *pwclient* quickly without allowing *--break-system-packages*.
> 
> Lines 176-193 could be replaced in the following file.
> 
> https://git.netfilter.org/iptables/tree/iptables/nft-cache.c#n176
> 
> The following code replaces it.

.... but... why?
