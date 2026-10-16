Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6EB4CCDE9
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2026 14:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792159995; cv=none; b=kUDcWjILUhj0+jT5ONvUSC+le1wiilE5uZvseRkUUhWr3iBqDLWzd/BKRt/GMiHZQrdjR8ctsfvOYMNvYcaKKII1QqwysB6dD7LlZlq1JGU9peJTfsstJfgkje0RihwKqYy8VhMrdsmPVwGz1u24BfhX9k1TB2wadIwkJnyrLGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792159995; c=relaxed/simple;
	bh=5nktcuf5NJO/2wBzh8lyrSIjRXQlL6XzHVn5wTrxhv4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JcZppEQjqcIstli4rZe47Uy7TSJSEGCU+j16hh/CJ2CkeMriwWqylBQcib68T309bxhnJsDaKcfbIYEe9W7yNkmEOURymXBk2OPD+LUG6kgbamq65YOkY//QSvTD9yrSQC5c5K93pR9EUBWfS6rwteYe4SDJvK47D6Yz6vQL+BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8F91960293; Fri, 16 Oct 2026 16:13:01 +0200 (CEST)
Date: Fri, 16 Oct 2026 16:13:00 +0200
From: Florian Westphal <fw@strlen.de>
To: Antonio Ojea <aojea@google.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v2 1/2] netfilter: nf_queue: limit the hook drop
 flush to the unregistered hook point
Message-ID: <atIw7CGcwLaPzAWh@strlen.de>
References: <20260928185803.335307-1-aojea@google.com>
 <20261016133304.1755951-1-aojea@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016133304.1755951-1-aojea@google.com>

Antonio Ojea <aojea@google.com> wrote:
> Gentle ping. v2 addresses Florian's feedback on v1: rebased on nf-next
> and the nf_queue_nf_hook_drop() call in nft_ct.c converted as well.
> 
> I rebased and retested the series today on nf-next main (a5e7d8e446af):
> it applies cleanly, builds, and nft_queue.sh passes, including the new
> test_hook_drop_scope.

I have no more feedback, LGTM.
