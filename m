Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308EA2FBDFD
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2026 23:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773356846; cv=none; b=P+WiJ77Wgekc36R/SKYT62S5SRbPD/LEWYGH3vNGsmaSQDK5jkQ0uQaWzfXZgvnC6UHiBapfWVFFhsKQqPIgR+ribLYEBvizRe9BHDpFT4r4ThK4auO+xX3YHSky4yA/Jxh72Ln5s71kyKVhpHbm6BjcuYKsDt3dIV9s9MZlZqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773356846; c=relaxed/simple;
	bh=vafehKGs/13JZFM1/JFwOlVW6zEpKJ7SNj6ZGqArONs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NY9C3mPWyjEImzVw+hacqqoyqum0ltZvh0/jxwlYgQCpQSQdXBdabMWQcodG+BzthGySmj0E/+8pYTdXSmO+THYptDFPvhD0RI45yqHb/ezwu8I+6neQSvusQpDuOQAtmhTgmTFGJYtW8bWuQu14JAbztjPd1jGsdyeqUcdq1V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 26C6160470; Fri, 13 Mar 2026 00:07:23 +0100 (CET)
Date: Fri, 13 Mar 2026 00:07:19 +0100
From: Florian Westphal <fw@strlen.de>
To: Guanni Qu <qguanni@gmail.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org,
	netfilter-devel@vger.kernel.org, klaudia@vidocsecurity.com,
	dawid@vidocsecurity.com
Subject: Re: [PATCH] netfilter: nf_conntrack_sip: fix OOB read in SIP URI
 port parsing
Message-ID: <abNHJ2kxObiQjdz3@strlen.de>
References: <20260312145506.2192682-1-qguanni@gmail.com>
 <abLdnHeh8lEKqqB-@strlen.de>
 <CAFzOa17VwKpnyLjejeBbAJ9XnbuykDVzb0-5HLsPDSdW9aG_JQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFzOa17VwKpnyLjejeBbAJ9XnbuykDVzb0-5HLsPDSdW9aG_JQ@mail.gmail.com>

Guanni Qu <qguanni@gmail.com> wrote:
> You're right, the minimal bounds check isn't enough. The simple_strtoul()
> call assumes a NUL-terminated string, and the SIP packet data in the skb
> is not guaranteed to be NUL-terminated. The current code relies on
> incidental zero bytes in skb_shinfo.
> 
> I like your sip_parse_port() approach. I'll take it, wire it into
> both call sites, and send a v2. While I'm in there I'll audit the
> rest of nf_conntrack_sip for similar limit violations and send
> anything I find as part of the same series.

Thats great, thanks a lot!
