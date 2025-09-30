Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEFB285077
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Sep 2025 19:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759259632; cv=none; b=Z/aKG6gXLx6hh9RKHYMPZmCfSmVL+D2++d9jZWXDF5IzQtjWwIhrV0Mb/l69oi62zVnZ+P6uyQSi4o2RCB3rWe7p1ySZZGlDGfIyZfsGgAjN5EiFUfY76wtRT+2zhbdZtn4+bZYI6UV4M5nmQ22nt02KwJd9BSgoZRZ79qRMwjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759259632; c=relaxed/simple;
	bh=qBJaV6bzIfsI7ai4V8G3TP63MeHUNCPczOapLTlz4+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G3QMF9l6zPChsiIBPOxX7tKk09+kbLhiRdYR3Y+846tgOixpvGjrF18KNaKmRJElWUrQSDOHtIqdCxy9MS88oIV3FE5SnpiO8pDNpmYxLlTwABbp6TcGdeAFd2Qo/ne4SMN5fMcabkLrpMroHZaHOkhOOpFQaBxv/5fbFShUKb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 21C3260326; Tue, 30 Sep 2025 21:13:48 +0200 (CEST)
Date: Tue, 30 Sep 2025 21:13:47 +0200
From: Florian Westphal <fw@strlen.de>
To: Johannes Truschnigg <johannes@truschnigg.info>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2] Don't shell out for getting current date and table
 names
Message-ID: <aNwr6_ROH8e5IeSv@strlen.de>
References: <aNuvKZN9WM8bVRkn@strlen.de>
 <20250930180809.2095030-1-johannes@truschnigg.info>
 <20250930180809.2095030-2-johannes@truschnigg.info>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250930180809.2095030-2-johannes@truschnigg.info>

Johannes Truschnigg <johannes@truschnigg.info> wrote:
> Also use a sane timestamp format (ISO 8601) in the output.

Applied, thanks.
