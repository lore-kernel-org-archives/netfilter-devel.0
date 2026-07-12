Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8B31F09A5
	for <netfilter-devel@vger.kernel.org>; Sun, 12 Jul 2026 23:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783898508; cv=none; b=lMu3t0jWz1TTpYTIkaAG5CvqjJXyZYSR6/Hd3AZAXDlsMeCkJ/yipi6MBPwpPttuOKYvBCOs5LCkNzrwQw+J8GJx4PD0yrO6rfBn9wN6RG77e67Prcntmp5W3dlozcex0q7vWYxNAzwwFukp7tzxnktMuXBKgUFFUk5KYQPVWMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783898508; c=relaxed/simple;
	bh=/t0rPP4ru2cwY7957MECbk3+cER8JhjQQMY03bOFnl0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BcoOE6yLf1C/czhIkk9RW2W3kstF/9DVXmgvcjziae8BxiM0Jj3y97mLiWCep4/s14Pg+IhIKBhpWrdiBiGPbEH6pQNgHOq9ImtSBQpL2mVLfIS8L02MLtpuG5JBsrwSp4NYQKlZYmWN1n+V04BzcepuZfFK/yyxPQdAw+74XZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Ht9G2O1u; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Ht9G2O1u"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 0847E60577;
	Mon, 13 Jul 2026 01:21:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783898505;
	bh=/t0rPP4ru2cwY7957MECbk3+cER8JhjQQMY03bOFnl0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ht9G2O1uI4TnfHuWtrIuZL0DoUxBV0IPwRt8LY4T0RB0KLgt2/H4s9kXbQa9mF7du
	 RgwpjVu6fZalJjqgcSevi4i8HCI4nXLQGvAQqJCy3px13F5rjaauhQkTv+Ht4omb9k
	 /hn9yWWmnc2IrDVllO0YmmIlIwJCqhGfpe0zywDqe+Qknml8Do2/DxrdhboUKgLxf2
	 JFkQmSWz6NCYSVo0VeuMQahaIJt+Xt8rHepHovEVER3Uib4Ynt74xFOwNA7WjUrK2a
	 j8rtZsyAvoDBQykyUvVyB/KBByOJq9gwQjbiVDt80XjWQF3VyHfhmh5unJ09s5pnfY
	 5dibMPMMYiVgA==
Date: Mon, 13 Jul 2026 01:21:41 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: ericwouds@gmail.com, fw@strlen.de
Subject: Re: [PATCH nf,v3] netfilter: flowtable: initial bridge support
Message-ID: <alQhhbb4HVI0Sliq@chamomile>
References: <20260712231935.1573912-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260712231935.1573912-1-pablo@netfilter.org>

Apologies, I reposted this for the nf-next tree, which is the right
target for this content.
