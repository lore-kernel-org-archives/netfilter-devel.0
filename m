Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9E93328E0
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2025 22:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761000421; cv=none; b=CU9bPqSRMWv2TUklWJ3Zq1JIQSHRjPQQiPjjG4Kg9q2bE5+J1JA5rGNdp5jHWFMa5rBvBAd7o0a68I8oBnmhVVqp9pvVA/fZ8exBlYM8WvyQQM0wFB0qjJuJcXZ7y4byXMHK1xhUiwppLNSJR7Jh5MjrhpJKshivmV9YbxB4ryM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761000421; c=relaxed/simple;
	bh=AAy1j2yIGQMH8l4gLhrRBBNU4Ye2iE7OLmE9oHE5Tqs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LOSAPrdw8eiWttrBFgwyDkvQfC3/VJhvYmaPWQk+APLW2p6iZQAUnLwo2PkvEt4cExN+dwdrayWW15qvk0XxCNjFUfpmYeKImrbrd5wotDi+kg2VExKY3VnBc+qffz457s/EMNLK6T4sDh42nqTqL5ZbsFP8T9ppeYEGMCaE8zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BCBA96109E; Tue, 21 Oct 2025 00:46:56 +0200 (CEST)
Date: Tue, 21 Oct 2025 00:46:56 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2] support for afl++ (american fuzzy lop++) fuzzer
Message-ID: <aPa74MFxL_Gm8vBd@strlen.de>
References: <ddf0bfea-0239-42bd-ba1b-5e6f340f1af4@suse.de>
 <aPTzD7qoSIQ5AXB-@strlen.de>
 <a2686aa3-adc4-4684-9442-ab4ad9654c69@suse.de>
 <aPZGOudKuDa5HMmS@strlen.de>
 <a641ebd1-c2de-478d-bbba-68eaed580fd9@suse.de>
 <aPaA8itLIaGqDoyM@calendula>
 <aPaIepWRL2u1HsLb@calendula>
 <aPauJ9saxZ-Mn3bZ@calendula>
 <aPa1wsoHHKjZ89hG@strlen.de>
 <aPa2hTdpyAb1y57R@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPa2hTdpyAb1y57R@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I think this is also broken from commit path, when two tables are
> validated, first succeeds then the second table fails. Leaving the
> first table with incorrect jump count.

OK, I marked it as changes-requested in patchwork.
