Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E28743935E
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jul 2026 08:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783584340; cv=none; b=B0PXMthRhSHcjxB2d1dshicPaM2rDy/Ce3B0rVb5S04STdR98QUW9AONCoT7v17j9SoPbVQ+8diQbJ2uzByRQ3BRB/CVysMAFEkDIjZJNhr4GN4msQzYnW5qqKa5ODOu9x2oOtudtCzKoie4KbLOmV5WzpGdttdlHZe/qHhdBnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783584340; c=relaxed/simple;
	bh=PmUK2bM3XM72E/3t3fsi1vpjayf4eWrItCsKV8zJVqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DFxM842jYgiidHZ9iLEgCXWtw9iuUr3HvPIuuBWCPsRe0FfM9/zSSdL/jWqI0SWFlZuxbubdq6vPpPI06R8o7BsQrsDiV+ikLrqfB91uyNzr0TMT+5S5OrmV88ALXWmdpOWBbyCT99TGC8hHNO6HeYFEsO1o6QJrhrJos4J6ZNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 05BDF60293; Thu, 09 Jul 2026 10:05:34 +0200 (CEST)
Date: Thu, 9 Jul 2026 10:05:34 +0200
From: Florian Westphal <fw@strlen.de>
To: Omkhar Arasaratnam <omkhar@linkedin.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"pablo@netfilter.org" <pablo@netfilter.org>,
	"fmancera@suse.de" <fmancera@suse.de>
Subject: Re: [PATCH nft] parser_json: initialize geneve options list for
 empty tunnel array
Message-ID: <ak9WRGrU4SjDxMEF@strlen.de>
References: <LV0SPRMB0026D6A74A8E3E8504609CB0A1FF2@LV0SPRMB0026.namprd21.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <LV0SPRMB0026D6A74A8E3E8504609CB0A1FF2@LV0SPRMB0026.namprd21.prod.outlook.com>

Omkhar Arasaratnam <omkhar@linkedin.com> wrote:
> The attached patch fixes a crash in the JSON parser. A geneve tunnel object with an empty options array ("tunnel": []) leaves obj->tunnel.geneve_opts uninitialized; obj_tunnel_add_opts() then walks the uninitialized list head and nft -j crashes (SEGV in nftnl_tunnel_opt_geneve_set via near-NULL deref).

Applied.  I moved the crasher to testcases/bogons.
