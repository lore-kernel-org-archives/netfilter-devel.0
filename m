Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DE0447808;
	Sun, 18 Oct 2026 11:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792323868; cv=none; b=Km0PYw1uJMVjWPZA0kHlMLCiDEZ8Kw7FW/ltikotCUY0D3ozPOrWf0cSEmt+AD8RbssL1YemrcPQtQjl/WOltJqysOAUWCZSlDE9mdKhl7m2Wwp9BcHKYkyiU8dSWi72MWTkfvKpxYKnvfvVq15OiAPQ9EYwKbUcP8gDAeifwe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792323868; c=relaxed/simple;
	bh=6To5AHxazV9RxxdQAMVGAYliVpWdryksPASbiBYhpg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i+PGALbV2yUzE0G8oK/w/8EHQCVTyIEo/ISe+FM3YP7M8wwqjPHn7oIUXnUU4WRvLq301IrnyuwFBhBk+gapGrMqqNcrXo78VsILv08vSEganb9fy+s/pThRT5HdJjsK/VDSVdF7VfO+RshB4R9/Lq2PtTf+VYqmCEK3EgLJOjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 03F1B60327; Sun, 18 Oct 2026 13:44:23 +0200 (CEST)
Date: Sun, 18 Oct 2026 13:44:23 +0200
From: Florian Westphal <fw@strlen.de>
To: Tamaki Yanagawa <ty@000ty.net>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: ipset: restore element before rescanning
 cidrs on seqcount retry
Message-ID: <atSxF1D-CRavIjqT@strlen.de>
References: <20261018035205.1008-1-ty@000ty.net>
 <atRROQfgdeGSIU5s@strlen.de>
 <20261018052302.29330-1-ty@000ty.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261018052302.29330-1-ty@000ty.net>

Tamaki Yanagawa <ty@000ty.net> wrote:
> No good reason, your version is cleaner. I'll send a v2 that works on a
> local copy and constifies the reset_elem helpers.

Thanks.
