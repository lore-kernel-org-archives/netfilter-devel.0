Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0BE500972
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Jan 2026 23:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768865717; cv=none; b=DPZqgBadHH3DCKyXubz7huAF3Xg9of/S3NBMzKPFB2I7bWvV7jMO62n+WJwJPTe76++Eis1IMtCEf5BDVJxBSppMN08INXiM+Edi/J9Pf5XFrU6lJVpfZ2dcj7/n7oN0vNWHE7TIGHwy12A5/SSuP1qEdYq92OSZTGgzTm3uzzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768865717; c=relaxed/simple;
	bh=5IQx7ts4P0qMtWWX17R38VFEmqKMHdl9y41toNJ1his=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ayLgQ99L5J8ig3pEI5/EABQLmmFCfvq+9CcWmg8LNSthcQYMJP4/a7eAFrQTG6Gy3S6Db2gSezr4CkaSfO5eY/5pXHV5cXEbRaT2EnNvI4XzSRA/FI1hBpU3IbEbA9SoF0T14/OrymhvlnmWB4ixMfH/VqPeZll41v6WqPmp1X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0CA2E603A1; Tue, 20 Jan 2026 00:35:13 +0100 (CET)
Date: Tue, 20 Jan 2026 00:35:09 +0100
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	pablo@netfilter.org, phil@nwl.cc,
	Michal Slabihoudek <michal.slabihoudek@gooddata.com>
Subject: Re: [PATCH nf-next v2] netfilter: nf_conncount: fix tracking of
 connections from localhost
Message-ID: <aW6_rWdJHz305jma@strlen.de>
References: <20260119203546.11207-1-fmancera@suse.de>
 <aW6X1kBQ8clOAL76@strlen.de>
 <18fa7f7c-22ee-42d9-b698-03df94f24d4c@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18fa7f7c-22ee-42d9-b698-03df94f24d4c@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> > LGTM, thanks Fernando.  But shouldn't this go via nf tree?
> > 
> 
> Yes but it will conflict with 76c79f31706a ("netfilter: nf_conncount:
> increase the connection clean up limit to 64") when merging both trees. Also
> it is rc7 cycle now.. so not sure.

In your opinion, is this bug more severe than what 76c79f31706a fixes?

If yes, please resend vs. nf; I can hold 76c79f31706a back until
after release and then handle it via nf too.

If no, let me know and I will add handle it via -next.
