Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50CB145FE5
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jul 2024 23:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722295439; cv=none; b=dT74Z1s1Ha847wqVBrnLxyTyTPiuEZ/LkwyjWLLDbsvK++fcxUnpH4hlSyteS5IuBfkRITO65fyKtwcYBXPIOOfBFHlf/62X22IBXl0uHjRuFxHBaG61DfC/w117WH/4Mca37xVGyG/R7O4DnblLv7Jv3gSpRJJFl4A3ronXuls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722295439; c=relaxed/simple;
	bh=xB1PRt8MZbfqaHUuMo821vVtbpJrpagXBCl8CXqO1dc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W4c9n101dq1uwP+UEwAGIVw0ZQsGViucgKEUb8+mBK1JXcYqIZASQ2z5RpH6hyuBYRco6+iBVKEnUSiMX11P36oBwp4RbH4iMj1I7lFznSmgu6FKfLzD4/zYNkKPmFatJVR9LTNpRZLRnu1+x4ZhzkHCYAv3Q/Yr6Ca528xOtNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sYZib-00033w-N3; Tue, 30 Jul 2024 01:23:53 +0200
Date: Tue, 30 Jul 2024 01:23:53 +0200
From: Florian Westphal <fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/4] src: remove decnet support
Message-ID: <20240729232353.GA11369@breakpoint.cc>
References: <20240726015837.14572-1-fw@strlen.de>
 <20240726015837.14572-3-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240726015837.14572-3-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Florian Westphal <fw@strlen.de> wrote:
> Removed 2 years ago with v6.1, so we can ditch this from
> hook list code too.

I've applied this one as its unrelated to the 'hook list' discussion.
