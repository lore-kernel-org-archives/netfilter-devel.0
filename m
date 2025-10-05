Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A14B28725F
	for <netfilter-devel@vger.kernel.org>; Sun,  5 Oct 2025 11:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759664634; cv=none; b=dBfdaUnimCFbk6BTYOebaVNsRztblLOj7sHNU/0rXvX1Aor0gPXOWj1m+A1Y9Hc1RjV21V7aUbpVFnoCB8D8iNWPUcEeGQ7EgOJXuGjoZUngy0PVM8PRNcW1pOs9ma0pWOzTomgF8JA0CefSwkTMX/QC1BoYnCH5Vle6HmGo4LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759664634; c=relaxed/simple;
	bh=2ZOg0ls6d6HtSbqEDxcWSZngBBRmVBZrTny8BH0aQ3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NVUR+14WN48R69iMZhKka5TvYLeMJupdLHyk0RhY+DgNrvCezGpoCmMvFG6G99BWGxxixISkwWZhlpnippKVTrvRIQVNOsI3lN2JlbylMd83zlbXH1TQM3lAFD8Jq04XVotFWp6U6/gCgvje7PkSqPMzrRenpa6ZqGgL7Pp8JRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id EE4EE604FB; Sun,  5 Oct 2025 13:43:49 +0200 (CEST)
Date: Sun, 5 Oct 2025 13:43:49 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	pablo@netfilter.org,
	Georg Pfuetzenreuter <georg.pfuetzenreuter@suse.com>
Subject: Re: [PATCH nf] netfilter: nf_tables: validate objref and objrefmap
 expressions
Message-ID: <aOJZ9dlb5cYGR13c@strlen.de>
References: <20251004230424.3611-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251004230424.3611-1-fmancera@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> Referencing a synproxy stateful object can cause a kernel crash due to
> its usage on the OUTPUT hook. See the following trace:

I edited this slightly to mention the recursion and applied
this patch to nf:testing.

Let me know if I messed anything up.

I did not alter the actual code changes; patch LGTM.
