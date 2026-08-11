Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D327642B72B;
	Tue, 11 Aug 2026 10:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786443638; cv=none; b=Xryl2QDavcj3UXsl6HunkNveDDf7G1W0/n9hCgGi8zc7I8ibS6T+RcU4IYMQ2WNAnexgsdoBDAKjdVI2BpFrxH2XfwvbgnX4bSffkuJYiuMcPWg5wjyRAeJBtqsWa96pedFcNZIAdPOBCuMkyekBPulmgKixnbTPZnxrcJMRBT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786443638; c=relaxed/simple;
	bh=R3pjetE2JWrIm/SELLOZY9kThXY7Wsy2eGrp79qeNFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j1t8K4Z8uBE0RREoKHvhWY75oG/hCyn9lA9zPKZkmeAK2pJjDdeP1aWl2ogUfC25B0/cRhZlXftG64/YfRR9049h1qmjhTvYG1JhvULgaiRT6V2sFOHd56gJyXaQh3ASGQ2WF7mZzp/vLGxuu6vlHhOpyX41hz9/WR3Brkn0SiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9920860232; Tue, 11 Aug 2026 12:20:17 +0200 (CEST)
Date: Tue, 11 Aug 2026 12:20:17 +0200
From: Florian Westphal <fw@strlen.de>
To: Wei Fang <void0red@gmail.com>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, k.chen@smail.nju.edu.cn
Subject: Re: [nf_tables] pipapo: inserting an interval that strictly contains
 an existing one is accepted; rbtree rejects the same insert
Message-ID: <anr3YZJrnS_2RbEp@strlen.de>
References: <CANE+tVp8_NhE+KL6ZNPGjaGMLPxrCWw_A5sY0jotrvThB6idXg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANE+tVp8_NhE+KL6ZNPGjaGMLPxrCWw_A5sY0jotrvThB6idXg@mail.gmail.com>

Wei Fang <void0red@gmail.com> wrote:
> -------------------
> expected: both backends reject the overlapping insert (-EEXIST)

Why?
