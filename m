Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822A85EE82
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Mar 2024 16:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710347584; cv=none; b=HtQCBoLkuQV+dUvBRy2W2p6VwfobYhE9WVC1DMkBXfjkUxfvx7Pa29iTwQO0xBDMFwZbzISANXSKKCzr2XGcFhjeEdHY4v4Pci6IZPxsTOPq5XfLc+HJBy/TRU0J9VDAxA3Ak4/M0c0C6IJmkoly5c3HbjIsHylpCg5U6TPUAGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710347584; c=relaxed/simple;
	bh=4eau/sW5N2Xu620iSAFmspq3VidtvB0rHKavrLtcOoI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MCrtHjTgwwJYpjxauzR7jIskQlkltkoil0A/tGvFON3+faS0EJyTDxH5l1Tqps7ueJyQzLUw+9s63sixKOaN9T6HXmiltGde2kZSFmqifPyX7+5Lno1mhoxQVkCprwyHPnSLdEcWdc6gip8zrslltVtfr+pzU9Yvp6QQllLOgMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rkRXI-0000YF-LJ; Wed, 13 Mar 2024 17:33:00 +0100
Date: Wed, 13 Mar 2024 17:33:00 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nft] tests: py: remove meter tests
Message-ID: <20240313163300.GA1038@breakpoint.cc>
References: <20240313162317.192314-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240313162317.192314-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Userspace performs an translation to dynamic set which does not fit well
> into tests/py, move them to tests/shell.

Acked-by: Florian Westphal <fw@strlen.de>
