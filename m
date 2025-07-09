Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108A12E613A
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Jul 2025 13:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752069490; cv=none; b=jCOdM4GFrZa88jmbY7Sp7DAPKllBAUCOhNsv4kmk2kfOvo9VQrXDkIj977k6Qda2d7eWDXatb2uJNPmWtibbmszg+8pacOAdXrZVRQucNytMuOXSiC7jWYI7Psv+Ey5XG5QXdlmLcHlGDigISnoLNEDqoKZo/lI7ruke3Is3k9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752069490; c=relaxed/simple;
	bh=TJtVIWnxtv9E/XePAAsYe63Q8LrPGMzkrvcyYK23ous=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nEYyfpl4M0hqhF46gx24FAelUCg6Y2L0RG+V/BbFSRLS2qcItbiJETaBk1J9VxMzIi5BFPui0c5hzAAn3zYKAtLuJN5PHFtYITajN7hR56fMwWqyA6KstzWlnAzuGNElSCvRyR3D6Q72GC77woQVA+9KXWqGt5BM0hDFynHycEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1EA1460BCB; Wed,  9 Jul 2025 15:58:05 +0200 (CEST)
Date: Wed, 9 Jul 2025 15:58:05 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 0/4] detach concat, list and set expression layouts
Message-ID: <aG51bWMM_vXBfns7@strlen.de>
References: <20250708232354.2189045-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250708232354.2189045-1-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> These three expressions use the same layout but they have a different
> purpose, it is better to split them in independent layouts.

Agreed.

> This is implicitly reducing the size of one of the largest structs
> in the union area of struct expr, still EXPR_SET_ELEM remains the
> largest so no gain is achieved in this iteration.

Still, I'm all for reducing the number of anon structs in the union
and remove the SET/LIST/CONCAT joint struct.

Please, feel free to push this out.
