Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9D31353E1
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Apr 2024 13:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713877564; cv=none; b=psRUEKka8tvWFa9ut6NyLzkk8H3gGZqT+OeHOfHHRPu7IeuRSzgnVLvL+sDVM5lPfIyN92qmJ7X3+TUfLRsMFLaPSJwHfRSXRVRZjtqL8UitBLLbZlf/j/rnig9Kp6jgPKiSBG4pcGU8Tl67geQ5biRwe+JrwDTSqCbWOm1Bk4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713877564; c=relaxed/simple;
	bh=ux5EWmXubuummNw++2sR6J21s1IWSmyk0eLVSXTMJRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qrIviDNzBohZ6+KBxO9S4Iz9yCZ5i7y+Pj9KWC0Wk9RebnOyxWN1hfXpxcjTBpp0rZEFe2s0w/AtakTGigb/0Ka/ijC61Q3Xb5lmqrZyaTrxc+Wa77cQ48TypD2cREVLzPY49JkxrPXlaRVnljVDGLxDdfiWPyAk7Rfmscg657I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rzFqL-0007yY-8t; Tue, 23 Apr 2024 15:05:53 +0200
Date: Tue, 23 Apr 2024 15:05:53 +0200
From: Florian Westphal <fw@strlen.de>
To: Vlad Buslov <vladbu@nvidia.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: conntrack: remove flowtable
 early-drop test
Message-ID: <20240423130553.GB18954@breakpoint.cc>
References: <20240423134434.8652-1-fw@strlen.de>
 <87sezc2rro.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sezc2rro.fsf@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Vlad Buslov <vladbu@nvidia.com> wrote:
> > ---
> >  Vlad, do you remember why you added this test?
> 
> I added it when I introduced UDP NEW connection offload. As far as I
> remember the concern was that since at the time early drop algorithm
> completely ignored all offloaded connections malicious user could fill
> the whole table by just sending a single packet per range of distinct 5
> tuples and none of the resulting connections would be early dropped
> until they expire.

Ok, so it was indeed this:

> >  and maybe was just a 'move-it-around' from the check in
> >  early_drop_list, which would mean this was there from the
> >  beginning.  Doesn't change "i don't understand why this test
> >  exists" though :-)

In this case I think this change is fine, ie. remove offload
special treatment, its not needed.

Thanks for checking!
