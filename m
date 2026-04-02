Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A623121D3F3
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Apr 2026 12:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775134374; cv=none; b=lIRDCH6o6QS2ypxesr2h+nF6azEKV1C3vLq5ueopMRDYSZqyUYkWgq39kVE3Nf0fZbFwae0EF0SKwn+UmLop6MwO5v0J+f3/ZZURpBrzrTK4isqqH8+YZZcmIepOTvDu33UfTycQtYvKly96ak75XSsaO4EF91AnegiqpPqkUtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775134374; c=relaxed/simple;
	bh=m8fT22bK4jZgmMtklo5Uitcr2mST6ljKcQuDRf/wBJo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CNwXbCiALIRd8hMao9xTQZ8N3TP2a923x2EFRrx0cvfBYEVqVrTYX25pbNU9VqxVtDLFuuqtNzJrjglkcrYjsi2skUyNJKO+UkkpUNtG19nxC+5cmC5OotFIZdU2Hsy8psw3vNH9kpJ3cNPf3OjJ6wBTDn/+cbBPzNn+NWVXXCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 265DA6047A; Thu, 02 Apr 2026 14:52:46 +0200 (CEST)
Date: Thu, 2 Apr 2026 14:52:48 +0200
From: Florian Westphal <fw@strlen.de>
To: Jenny Guanni Qu <qguanni@gmail.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org,
	netfilter-devel@vger.kernel.org, klaudia@vidocsecurity.com,
	dawid@vidocsecurity.com
Subject: Re: [PATCH v2] netfilter: nf_conntrack_sip: add bounds-checked port
 parsing helper
Message-ID: <ac5moJzDjXNUSXKI@strlen.de>
References: <20260313195256.2783257-1-qguanni@gmail.com>
 <abSfgVpCQcFWwNEs@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abSfgVpCQcFWwNEs@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> Jenny Guanni Qu <qguanni@gmail.com> wrote:
> > +	/* reached limit while parsing port */
> > +	if (dptr >= limit)
> > +		return false;
> > +
> > +	if (port) {
> > +		if (p < 1024 || p > 65535)
> > +			return false;
> > +		*port = htons(p);
> > +	}
> 
> I like the port range check, but should we make this universal?
> 
> 	if (p < 1024 || p > 65535)
> 		return false;
> 	if (port)
> 		*port = htons(p);

Ping, will you send a v3 or do you expect us to take over from here?
