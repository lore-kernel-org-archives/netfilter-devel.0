Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D87357D1D
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Jun 2026 13:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780407993; cv=none; b=STxxXexITX9W/6rCwpw95Hzc8Vrl/mhR1KAj+GN7bdzesOkRupziyQMpQjyTnHXgE0aBG6H0mOZ6sX5D8Ox+5ViBLPmVB7Nn25cr8cDpGHftgYB+eCciq+olfGUvFbe9NUi9qujyGoMJxbfgOc1eCtKSV+IUNRyh7+16YjuJmZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780407993; c=relaxed/simple;
	bh=IuQLF+HjEZih8YrTmE0+c/u2Wzjrft2bAvm2DVffl/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tnLZksV59r4zmmx5umyMrg96FY3XihQpNMPTvM5ZkwKuiVgQ4IOtuwYOo5vTzojSJ+Y47aX5QJed5lWaffQvTVXrKMd9tgadwrt96L4wFRsPzJy41peMpk245RuCd9Z/lFVr+790KPZk/xEDa74SSjZltfEqjkicjHhvgPExdAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0203760337; Tue, 02 Jun 2026 15:46:28 +0200 (CEST)
Date: Tue, 2 Jun 2026 15:46:28 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: shell: packetpath/ct_count: Add missing socat
 feature test
Message-ID: <ah7etAsr7mvjXKk1@strlen.de>
References: <20260602130715.727246-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602130715.727246-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Skip the test on systems which don't have socat installed.

Ah, thanks. Please apply.
