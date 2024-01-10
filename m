Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E174F892
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2024 22:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="S7IgxBih"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SOYUc49zD5Agmz0GDII1IgIeEnjcMvfun3XTTr5Y5Pg=; b=S7IgxBihJgFT63i7sNN2/5YJic
	mhq/J3pgUbP6KSu1Tx06c5/p2Me+TpxiGlRuXys4SARHx6q1nzgu5GtU/rc0T2WBsLdG1iSSnfB0/
	ar98vGWbjYCTje5E3U9CHsRrLBTE3U3Enl9F+s9ouVTDbZJF84428L53R0psddxGSXnQCdufjsrVm
	OJW9TnSLq2o3RHt5MvuEhqRyGc9sKiiLLHgey3wh+GyYl3AaN0BBv/GNANWtGjoTGC525MyIyknLG
	KXh+QgJbCSxCl/yH2HoCTteZ1eB4dlzsdIK8gEdM/Qp+PWkm7gSeLYCD0ma/Y//3bydWKmSPfuvx5
	2Vkprhjg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rNh9X-000000005Ml-38Wr;
	Wed, 10 Jan 2024 23:34:27 +0100
Date: Wed, 10 Jan 2024 23:34:27 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [iptables PATCH v2] ebtables: Default to extrapositioned
 negations
Message-ID: <ZZ8bc2RQ5N1EBvvQ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>
References: <20231221133940.959-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231221133940.959-1-phil@nwl.cc>

On Thu, Dec 21, 2023 at 02:38:52PM +0100, Phil Sutter wrote:
> ebtables-nft has always supported both intra- and extrapositioned
> negations but defaulted to intrapositioned when printing/saving rules.
> 
> With commit 58d364c7120b5 ("ebtables: Use do_parse() from xshared")
> though, it started to warn about intrapositioned negations. So change
> the default to avoid mandatory warnings when e.g. loading previously
> dumped rulesets.
> 
> Also adjust test cases, help texts and ebtables-nft.8 accordingly.
> 
> Cc: Jan Engelhardt <jengelh@inai.de>
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
