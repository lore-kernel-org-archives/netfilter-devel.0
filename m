Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFB83195E8
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 12:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761310515; cv=none; b=nc3IyIN8hzRKVlh/7O5ZmOyX9gQwc79v7MfksjUcbwHgfIQGNPpqDwAJ3EdXCebJMaXW2ecTrsDKQA/op2qqLWxJ8IHK7uk3d9FbWhzu3Tm4auQ/TSZIcHv7HQeQVUJS4xmzhYxt867M0a0IIzdmt6bVtPmgbicbKYvoYeRQQk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761310515; c=relaxed/simple;
	bh=VWmDnjVaoIE0K+LMieGP/Rfx6QA51bUdYJBkZUjFvco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ugSL8D04zxX3uC8ZRvO2x30KdBmgGPSN+JbMygYPClNRJR7qu7XtssJnNLL08Oz9yCz7U+Ae7ov/kuiPHCMPYi+s/WU1IVsGQJo4NJX+R1gdqv12N51HNIsHaEFXUKuN/d2hIj61BmMGINwyBnHh5XdyvUU2vge7/1IdQ4UvasI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 13BBA60308; Fri, 24 Oct 2025 14:55:12 +0200 (CEST)
Date: Fri, 24 Oct 2025 14:55:11 +0200
From: Florian Westphal <fw@strlen.de>
To: Antonio Ojea <aojea@google.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_ct: enable labels for get case too
Message-ID: <aPt3L9LboWOsalSv@strlen.de>
References: <20251023120922.2847-1-fw@strlen.de>
 <CAAdXToT6ZfaP3oxuYdVK9PWwWwuyHeaRuJdOX9sXoVenhtnAmg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAdXToT6ZfaP3oxuYdVK9PWwWwuyHeaRuJdOX9sXoVenhtnAmg@mail.gmail.com>

Antonio Ojea <aojea@google.com> wrote:
> Hi Florian, I'm trying to add a kselftest

Thanks!

> but it seems the conntrack
> tool fails to add the label if the /etc/xtables/connlabel.conf file
> does not exist. This is the behavior I'm observing:
> - conntrack -U:
>   - fails if the file does not exist
>   - works if the file exists, but if the entry does not exist in the
> file the tool throws an error but the label is added
> - conntrack -L -o label
>   - does not output the label if the file does not exist or is empty.
>   - if the file exists and the ct entry label exists in the file, then
> it's correctly displayed in conntrack -L
>   - if the file exists but  the label is not present in the file, the
> output has a labels statement but is empty

Hmm, this isn't ideal, it should resort to a hexdump in that case
(on -L), needs a fix.

> Can you give me advice on how to proceed?

Best advice I can give is to check if conntrack tool supports
--labelmap option (not in any released version, added in June this
year).

And then add a custom temporary config file via 'mktemp' + feed that
file to conntrack.
