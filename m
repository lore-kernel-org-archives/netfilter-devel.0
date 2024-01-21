Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D28374FC
	for <netfilter-devel@vger.kernel.org>; Sun, 21 Jan 2024 15:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705850995; cv=none; b=AsRiLh56X7mksCk0fsD/mJ3O6llrTN5FAtwjRIclPWZGDkrIEQg9b0JFyQwotAAuTIY7kTR4+imUT4Xc0GOMysuAbs4CRdGoV6gpKQ3sbUzvejn5vv0QbIEJ6dP8OGLAhomgnl4K+Byp5xGm11VN+UJD0DZmMt3T+5iCfM03gyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705850995; c=relaxed/simple;
	bh=HV6ZRga2fjng4vJBzy6XFJtTtCp8X8U7qg4L6v3P10A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gJ4qziV9R9qBi9Giuztprpb68ydQ0UBGr/9vSpLEX+4CvnRdxSneIw6XNRsyVEfh83WwUi+UyvVBbM2+pFm5l02p9S23mi00CriSJf/LYdTDw3GU44Lz9VTL9m1wYiuEDtgM3hEiZd8gp7NQUtC5UhxjMQerNjulmVqW9bgG/YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rRZld-0001pw-9e; Sun, 21 Jan 2024 16:29:49 +0100
Date: Sun, 21 Jan 2024 16:29:49 +0100
From: Florian Westphal <fw@strlen.de>
To: "Schaefer, Ryan" <ryanschf@amazon.com>
Cc: "fw@strlen.de" <fw@strlen.de>,
	"pablo@netfilter.org" <pablo@netfilter.org>,
	"kadlec@netfilter.org" <kadlec@netfilter.org>,
	"Woodhouse, David" <dwmw@amazon.co.uk>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"Thompson, Schuyler" <schuyler@amazon.com>,
	"coreteam@netfilter.org" <coreteam@netfilter.org>
Subject: Re: PROBLEM: nf_conntrack tcp SYN reuse results in incorrect window
 scaling
Message-ID: <20240121152949.GB4357@breakpoint.cc>
References: <f01c0673e95f190074d0747b4ecfbc3f817e463e.camel@amazon.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f01c0673e95f190074d0747b4ecfbc3f817e463e.camel@amazon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Schaefer, Ryan <ryanschf@amazon.com> wrote:
> PROBLEM: nf_conntrack tcp SYN reuse results in incorrect window scaling

Please re-send the correct patch to apply to nf.git tree so that
patchwork will pick it up, thanks.
