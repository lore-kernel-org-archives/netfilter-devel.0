Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DF513F452
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Apr 2024 10:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830589; cv=none; b=tWfSqKa9ylvxZjjTEZYe+JufqkybP4Wx/OT2l42u0gofxP8+jFw997VsyRtkut8YM3joHbCRXKY9pfpcRYhKNRWtoG/1Bpgdg95DdsTwqhUUmUEkcIDEm15niRMkIrAQDR1ro1D6e8de0dKtpdccF+MMMzQoIMi6/8mu2VSTOmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830589; c=relaxed/simple;
	bh=Vbay5RL17lmYp58FdElYmNLpaSKAowuxF4O3MCRt/po=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sYoOJWJjmpgqS8r7Xmgc76d7uXVFwgv+2I9J9gr7+9kYdsInV8hehwVAVoa1vZMi5CGA/fdcWYsZOxxTUSzkGGwcuHeLamVGodgL0JPE3+UEZltJCvl9KPj0gTABHJRunGScTK6bpHTyeHa+ruF6StLywMs/K4HWZzB+Dl92pQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=cLpL9LGE; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="cLpL9LGE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zbER5wJW3/k0dm52AV7uAdRVEPcEwi6uFWQtxnA/Ge0=; b=cLpL9LGE6AVGLk4+FyiCJmuodN
	mjUNfRdURCsBi8ynRU9JX7eeYiPtQ4Xkucrwrc/Xe0Jf1QTQ6gPlYc0KO1SSDziVq7dDkP66FfbZh
	Lwg/XGPZ/0G+hZEdONU4HLr/U5/ii7ud5pxeIPKMp8ZZZNl74LMCZBMcd9RKdD4oAPViNfirnpujl
	boPEWz22v2nRJ7mVTMN7cO7QPn4d5hElZzL3EO/URSB+7RDtlaouJg2NC+1AKkSiG0p8MwFU4FHWu
	58kaFzd62Tnz8mM01D+Xujkk6chPF8pWncqsypaOi0ZNtCp2Gc5lgFN+j7WPFVBIrGI71cqPuDUSa
	tEGq1zBQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rurTk-000000001IP-2jnY;
	Thu, 11 Apr 2024 12:16:24 +0200
Date: Thu, 11 Apr 2024 12:16:24 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: gorbanev.es@gmail.com
Subject: Re: [iptables PATCH] xshared: Fix parsing of empty string arg in
 '-c' option
Message-ID: <Zhe4eDU1LQbDqFBK@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, gorbanev.es@gmail.com
References: <20240409113101.672-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240409113101.672-1-phil@nwl.cc>

On Tue, Apr 09, 2024 at 01:31:01PM +0200, Phil Sutter wrote:
> Calling iptables with '-c ""' resulted in a call to strchr() with an
> invalid pointer as 'optarg + 1' points to past the buffer. The most
> simple fix is to drop the offset: The global optstring part specifies a
> single colon after 'c', so getopt() enforces a valid pointer in optarg.
> If it contains a comma at first position, packet counter value parsing
> will fail so all cases are covered.
> 
> Reported-by: gorbanev.es@gmail.com
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1741
> Fixes: 60a6073690a45 ("Make --set-counters (-c) accept comma separated counters")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
