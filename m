Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE82831E844
	for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 05:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779945579; cv=none; b=AwKg9Fo6jMTyKj5tai+h8g1O42ejZoPhEOWZpC3gZPoigp+NNbgb2L9blvVQlbUn+o/AQVrNEfFy/LxgRtlztvHmfWGuwBfFmF4HbUmi0GUBAhU02sGQCu7RjsDGmSfUeWCD8IbJMDFuzLL1eql/hpyyp61FF9JZfgHLCrldPKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779945579; c=relaxed/simple;
	bh=Ol+WVlsfMaX69gjxcoF0aTCwj+wUb/54a43aoy5Ekgc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ah5lpKKDCy+HBsmYdlcD9PWab6EBByCMOy1uAAZCPIKhBT/2wCL/0xbhH0lp/NEibe75csVzIUVe9b5Q6wmvcwukoURd2BTfQTHVYkTNKy5EF3sIcOfy+ateskwlkDnNIjyy81WD+nnPUfbjs6pDmwyJiXVjNKoC9DWD4X4x8Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AFD13604A0; Thu, 28 May 2026 07:19:29 +0200 (CEST)
Date: Thu, 28 May 2026 07:19:29 +0200
From: Florian Westphal <fw@strlen.de>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_ct: fix OOB in NFT_CT_SRC/DST eval
Message-ID: <ahfQGCNs8hl6FlHL@strlen.de>
References: <20260528042620.263828-1-jiayuan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528042620.263828-1-jiayuan.chen@linux.dev>

> which makes nf_ct_l3num(ct) be 0

How?
