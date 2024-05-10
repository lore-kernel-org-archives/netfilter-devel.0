Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5E782C6C
	for <netfilter-devel@vger.kernel.org>; Fri, 10 May 2024 11:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715339152; cv=none; b=QHNezIFa/afhNeZc/ZjstEcTIDj98Ry4syAcLP2437aG+oo9ye8wgXu4mttVvwxgxFMWJp3/sjGv+Zuc0SEo6mt8NJ5pFAHQuZSQgsyS/hqAFvkPJ/Y4+JoNyoTaWaKh/q4wKFOwQo4AVW1HdEsXrjfcMa8cKhMPxAjhM9KKs/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715339152; c=relaxed/simple;
	bh=4lYPXY5k5PGSSwl1pydBuv6K20Dyjs3P2nJMedjDtvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T1kqEYGRm9oQn+FhijQe1i9lN+MzrPDMVBig9BdErD6c6Bnqt/l1toTKmawQml12rigvfQ37NRSzG1Uvnht+vTm8l6FgWRNW/ujZJXJgCI4XbTFzpZw6aotzvZNcaDD70yvvWZ3tkZ9jEQR3JScKnNvX8weHm0FUdWfWrKeCFps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1s5O4R-0006bP-9u; Fri, 10 May 2024 13:05:47 +0200
Date: Fri, 10 May 2024 13:05:47 +0200
From: Florian Westphal <fw@strlen.de>
To: Sven Auhagen <sven.auhagen@voleatech.de>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: Could not process rule: Cannot allocate memory
Message-ID: <20240510110547.GA6094@breakpoint.cc>
References: <qfqcb3jgkeovcelauadxyxyg65ps32nndcdutwcjg55wpzywkr@vzgi3sh2izrw>
 <20240508140820.GB28190@breakpoint.cc>
 <20240510090629.GD16079@breakpoint.cc>
 <qhjlvlrbtoxmlmowgkku3gqqgczzdyvvm4urz3322qbzxwqbc3@ns35urbmwknj>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <qhjlvlrbtoxmlmowgkku3gqqgczzdyvvm4urz3322qbzxwqbc3@ns35urbmwknj>
User-Agent: Mutt/1.10.1 (2018-07-13)

Sven Auhagen <sven.auhagen@voleatech.de> wrote:
> destroy table inet filter
> 
> table inet filter {
> 
>     set SET1_FW_V4 {
>         type ipv4_addr;
>         flags interval;
>         counter;
>         elements = { }
>     }

Thanks, so this happens even with simple set like rbtree.
