Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D85236A73
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Nov 2025 15:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764345021; cv=none; b=sdNTWTGv35ytecfxeW1aKL9euattQSI/Wk7oIaIRZXm+asrCuKdRCZgnUJKUwXuu2gLFq82bqsevXM1d+vvyoyJ2v4LDhV1thdEanZF/So4ffehjniqBf6s9S0SBU0HhXqjHrCI/K0+H2yEOK4H0Guw95y2Bb/pWQLs66tQwnE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764345021; c=relaxed/simple;
	bh=XQAqOuLtudXlMaWQRfKB+Mta505jHS4EYILiQZHx/ZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LWBhkJZt1wlFTfOMFGNdpt5COFebzZffCrQhf2JIqA7Dp2bEz9gUWSY73k/SBc2BqlijTdt/daqOBKxOunkYfQWRpjkq4dF1d8NopSsUygNaGCvxyZuZgxzteuOy6fAnp0s4jFZ28ceZFRdDf/57fuiUsbfV1cXc03XRBUWcbx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6C82D60216; Fri, 28 Nov 2025 16:50:17 +0100 (CET)
Date: Fri, 28 Nov 2025 16:50:18 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH RFC 5/6] parser_bison: Introduce bytes_unit
Message-ID: <aSnEujF5xSIrclCR@strlen.de>
References: <20251126151346.1132-1-phil@nwl.cc>
 <20251126151346.1132-6-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126151346.1132-6-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Introduce scoped tokens for "kbytes" and "mbytes", completing already
> existing "bytes" one. Then generalize the unit for byte values and
> replace both quota_unit and limit_bytes by a combination of NUM and
> bytes_unit.

Reviewed-by: Florian Westphal <fw@strlen.de>
