Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F4814B950
	for <netfilter-devel@vger.kernel.org>; Sun, 24 May 2026 17:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779642976; cv=none; b=hfcj+yGmpBU1mAg8i/HFQYfUVfAaA47MJQMKPHTALjnjfjouEC3SqVFr8NhRtcgC4f+wdCIlhBNVk6jSxDIC8pkXnMfjWdDRNKt3YyfbqMWee7rHqkzUMPm9Lgc9PW7cFP4mlX/8JcbCwMxt2fAXAVwk5j7sEeRmA3N0EXiAdiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779642976; c=relaxed/simple;
	bh=yZtPLFbdYZL7AYTzQWSTczVP2EYlG7BLjfJfaiWIyfI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZvogiIYpZrPdhW9Ta7xxDa9uJUH/Vx2bxF9T5QZ3lHIV0tqqRxe+GhOJKNuEU/uMiS3od1fowuBFrG9P2X9C77Q0PXxgCOqWbFTGAMALU4CIufaxf4PV9wyW5obJ8pWwPVL/1KrOhQ4JNh0Rkv5gzW0QHoYr1VaPldbYxF2rUPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 36BA160551; Sun, 24 May 2026 19:16:05 +0200 (CEST)
Date: Sun, 24 May 2026 19:16:04 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	pablo@netfilter.org, phil@nwl.cc
Subject: Re: [PATCH 0/3 nf-next] netfilter: synproxy: timestamp adjustment
 fixes
Message-ID: <ahMyVJYynOoa32U5@strlen.de>
References: <20260523194743.5888-2-fmancera@suse.de>
 <7dcb73cb-11ab-4c9d-89bd-7418bdc86fdb@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7dcb73cb-11ab-4c9d-89bd-7418bdc86fdb@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> What do you all think? nf or nf-next for the 4 commits? I tried to reproduce
> an UAF but couldn't trigger it. Although, I was able to write to the stale
> pointer using tc mirred..

nf.  But I'm not sold on this series: dropping patckets outside
of rulesets should be a last resort.
