Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE35217653
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Mar 2025 11:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741346222; cv=none; b=iGosSCH+mRaZy8JkVFqJfpJOrXpR2GWG12lS1+DigWcVKBQpVXMIR+IdCIxKvkr1/zHXeMvuD++fRC1qUpj2TVZzvp7C6erq1qYC5rKlqOLe1PZ5HhOSeE8tvCFqChdm50K8RxRFElQ9VSeCC+nfWvo9ZfK5RcccWZ8SmWH68dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741346222; c=relaxed/simple;
	bh=s7NHhOXYgKopaxkfRBWWrZtijk4MGGWDVywACCmAXDo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vF1lACnncWW4f8bF/tOC64aJSulx33NsgFBzagUml9rAD1kN8ZKztKnY+mzEhehXMBEL57xzzkJs86TmamWDa05Qf2fyqwk7+nRne1RxmTZqARAbUQ4K77rivKlOijsrSMf+F4+Wf8Ez7u+QtmBmQTi66VARYaPAFuLGwtSVTc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tqVhE-0007CU-BI; Fri, 07 Mar 2025 12:16:52 +0100
Date: Fri, 7 Mar 2025 12:16:52 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nft,v2 1/3] src: fix reset element support for interval
 set type
Message-ID: <20250307111652.GA27653@breakpoint.cc>
References: <20250306182812.330871-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250306182812.330871-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> Running reset command yields on an interval (rbtree) set yields:
> nft reset element inet filter rbtreeset {1.2.3.4}
> BUG: unhandled op 8

Thanks, please, push it out.
