Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CABD287510
	for <netfilter-devel@vger.kernel.org>; Thu,  7 May 2026 18:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778177811; cv=none; b=deNdBJ3Fa2czLrSdurVYLGI828wIaTbzYWLenobu4klKWVdwxvLUspVQ+rH8MAfklGUx3VzIhmoMmpVc82GcjprRaBTsca01chA0KWhi4wd/a0DaeqjLD2/DHDcTyxsT5G5fio/cYhLOHwQ4UJ2OXaaDejfmKEIcRRw+mVaH5OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778177811; c=relaxed/simple;
	bh=qkpkbOiwdijebO1HF11k5pC3+A3GSR7yt1fJQnj5WsA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GL/N9B0E9Aqn5v9SUDUvnR2jMoFp/xkcER2r+DF+S8/VdZRjJr2nPsNSnHXd/QrOYP6Hz88PqgNL+B48X/0NpsO9CLEgkOJEIgmESPt/cw6fvk2MuJDjNVP6zS79EWbaPFAlV0E8tHqUGvhwfAfwpjh0vRnkjzT1bwH/uoc1td4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2A03060D43; Thu, 07 May 2026 20:16:46 +0200 (CEST)
Date: Thu, 7 May 2026 20:16:44 +0200
From: Florian Westphal <fw@strlen.de>
To: Li Xiasong <lixiasong1@huawei.com>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	coreteam@netfilter.org, yuehaibing@huawei.com,
	zhangchangzhong@huawei.com, weiyongjun1@huawei.com
Subject: Re: [PATCH nft v2 0/2] netfilter: fix expectation reference leaks
Message-ID: <afzXDEIOvOSfHC34@strlen.de>
References: <20260507140423.3734545-1-lixiasong1@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260507140423.3734545-1-lixiasong1@huawei.com>

Li Xiasong <lixiasong1@huawei.com> wrote:
> this series fixes two expectation reference leaks in netfilter.

No need to resend, but [PATCH nft] means: 'this is nftables.git' (i.e.
userspace).  This should be [PATCH v2 nf].

> The first patch simplifies SIP REGISTER handling by validating helper
> availability before expectation allocation, removing an early-return
> leak path.
> 
> The second patch adds a missing nf_ct_expect_put() in nft_ct expectation
> object evaluation to balance the allocation reference.

Thanks for v2.  Reviewed-by: Florian Westphal <fw@strlen.de>
