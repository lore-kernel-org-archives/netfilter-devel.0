Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E6B28D8D0
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Feb 2026 15:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219654; cv=none; b=V6cR8x+Nhklo/dqh7uzOdJUs4f6G95c2kaX1uQXHfahavQADxaj2+ONeXbWUmqeUCOcHtgWJ+PURpt1+8KJoSwEYOYLebpcS5OnvyNSSB/8Y/oeJsmvhrP8FY4jasrjBIKlh23lfntf9EQe0hPZlNdpHdX3cKfKrs+Fq12YaCE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219654; c=relaxed/simple;
	bh=InAW7YHG6cdwNuNe0ky7Dbw7LiAq1n8bggffosa1KKk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=A6+cSHL1oMw/e/Oyo8oCH1R11mkWPIyl4BK63mNN1jijTObU8FdMp532UVEv1G6k2RlLPf6xiJBOsJGKpkcGSS/83Eh8G0SipTAUS+jSDSjLUZSNFs/ZJDRkEB0ZrfPV09BCisY0SohJwXR1ZrBd1DSlUzY7lgo1UNwsNNSL+sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4BC176033F; Wed, 04 Feb 2026 16:40:52 +0100 (CET)
Date: Wed, 4 Feb 2026 16:40:52 +0100
From: Florian Westphal <fw@strlen.de>
To: jeremy@azazel.net
Cc: netfilter-devel@vger.kernel.org
Subject: Bitwise boolean operations with variable RHS operands
Message-ID: <aYNohGL7fPQtVZfC@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jeremy

This is a note to let you know that I've marked your old patches
that were remaining in the patchwork backlog as 'archived, deferred'
(a few were marked as 'accepted').  AFAICS some of the features were
applied already.

If there is anything missing, please feel free to rebase and resubmit.

Thanks!
