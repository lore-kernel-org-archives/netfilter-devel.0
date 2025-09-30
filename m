Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D3A2C028F
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Sep 2025 10:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759227711; cv=none; b=su5YeZ0sqFDfvHPAogxIvhhe41qcbsuNc5mwdyBu+SgUXo1tsbt6heo7BePDzStXAuszS2DYLx8yTu0qjHuG9/+2gWlj8yAZAKAylc5mopeJFeaZhGTWE3TMvBy0saZW+EIgaYiNiqa3jHViiYge2nKj3CcfSHc0NkvugcD76WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759227711; c=relaxed/simple;
	bh=HEdSGB0gBbAMSNJ0Orb3Y+IUImF3Q1FcgLcK7xeM63Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fMl5EjREIplzOj+rTJcrimuiN08DMG49nEFJYOyl8vVG6A7FjxbNVn1qILyHm6wI9KrCTUkIO/Y6hU6Rg6pbwX04CF++s5rSP1ogSRnBYhlLqdr/ZdrMuQ+8VXSg6OPtHSIHT9aOiQW6SGCg3CdTF/xfH23pUT/OyzKg1leCjhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 89F33602F8; Tue, 30 Sep 2025 12:21:38 +0200 (CEST)
Date: Tue, 30 Sep 2025 12:21:38 +0200
From: Florian Westphal <fw@strlen.de>
To: Johannes Truschnigg <johannes@truschnigg.info>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: ebtables-save: Do string processing in perl instead of shell
Message-ID: <aNuvKZN9WM8bVRkn@strlen.de>
References: <20250927131421.24756-2-johannes@truschnigg.info>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250927131421.24756-2-johannes@truschnigg.info>

Johannes Truschnigg <johannes@truschnigg.info> wrote:
> want to consider merging this small improvement.

Would you mind resending this with a Signed-off-by tag?
(git commit --amend -s)

Thanks.
