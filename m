Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B219C374F2
	for <netfilter-devel@vger.kernel.org>; Sun,  7 Apr 2024 17:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712510325; cv=none; b=d45YKYRZCSDSjkvqrFem0tDgeK8mjf8jBoBzTkUMdmEEO3LLNbmKSIBCXTtTRuYFDDp5ppOyyunE2yJOAdcUWYfP67qV578VHCx7/WX5rx+l+NLRWTC3pQ4Ilhij6cH+IgPMHuvJr6MACICKEA6Rj4ANhTzJTmfpzvzZWNVMhHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712510325; c=relaxed/simple;
	bh=QohjpN8DHeO5uEj9xLsitexTpSe4FierTUT8k4XI1nw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CPQk4ZpyTHqaSverEY/sa8YTiDoJ4aYmJYw9MHlrAsDejkbwKm6wWwoSYNp7m0ltFFFFsyEP3xvKRE1RnMl7YcfTJ4NJYM0Gwq82Q2RAD5bUYsCYfto1++95xrojl606+EiLjccYgGIM7eiwfCiZWkcbbfMwD/OTxLiMFZbNXfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rtWAC-0007rK-NM; Sun, 07 Apr 2024 19:18:40 +0200
Date: Sun, 7 Apr 2024 19:18:40 +0200
From: Florian Westphal <fw@strlen.de>
To: Son Dinh <dinhtrason@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [nft PATCH] expr: make map lookup expression as an argument in
 vmap statement
Message-ID: <20240407171840.GB28575@breakpoint.cc>
References: <20240407015846.1202-1-dinhtrason@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240407015846.1202-1-dinhtrason@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Son Dinh <dinhtrason@gmail.com> wrote:
> Support nested map lookups combined with vmap lookup as shown
> in the example below. This syntax enables flexibility to use the
> values of a map as keys for looking up vmap when users have two
> distinct maps for different purposes and do not want to alter any
> packet-related objects (e.g., packet mark, ct mark, ip fields)
> to store the value returned from the first map lookup for the
> final vmap lookup.

This needs at least one test case.
