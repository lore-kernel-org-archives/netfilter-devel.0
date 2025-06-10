Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7996320FAA9
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Jun 2025 06:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749535368; cv=none; b=upptROOgUJLwLMjM4hbsadyCvb5b84iKuM6cm5bT7qZMuQA6/Rvk4eUy2ZBJ3T2IMF1fB7R9rmiXAKITBmsh16ab9SR6RO9+8joy+g0ywJvU+JFVtYxzpx8FpdlxODq1sDFLpAMl6A+3t3x62ldAi1wbq0QkZC4V06tVIsp0Kwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749535368; c=relaxed/simple;
	bh=S9HZgCPlwkNXMMhAihtFTEwPSk9T7wpcdCGFGsiy4V0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r8S0etmfB/OwICxl/+JW7GQddelnjRdnAa+RAUxrSkSj/w6xwF6VC+9jHUqsbNN5PCNwXPryih6RlP5ruhyj5mz5kg6hpGq3khrbRoflWNQTKgQSm44nahfMLsP7chjJNwIZw8F8zE7lrTW9wEyHJ2WP1SHLEvrP9wZFThV9aF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 84FF761151; Tue, 10 Jun 2025 08:02:44 +0200 (CEST)
Date: Tue, 10 Jun 2025 08:02:44 +0200
From: Florian Westphal <fw@strlen.de>
To: Yi Chen <yiche@redhat.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2] tests: shell: Add a test case for FTP helper combined
 with NAT.
Message-ID: <aEfKhFSANXOK31Sp@strlen.de>
References: <20250605103339.719169-1-yiche@redhat.com>
 <20250609081428.9219-1-yiche@redhat.com>
 <aEdTln3VvlQNgPXT@strlen.de>
 <CAJsUoE2oBU-0BvbaKdaHtjUO4+cXaczNMz13iTsPAgJy6wC4CQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJsUoE2oBU-0BvbaKdaHtjUO4+cXaczNMz13iTsPAgJy6wC4CQ@mail.gmail.com>

Yi Chen <yiche@redhat.com> wrote:
> Indeed, both passive and active mode need to preload the nf_nat_ftp module.
> The patched script passed on my side too.

Thanks for double-checking, I've pushed the updated script out.
