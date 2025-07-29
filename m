Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06F2634EC
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Jul 2025 00:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753748729; cv=none; b=Jq6Eq46QI5o9c720eIOm0Y9nhbYYsvoss98FHqv0KJAnS5NmZjzq+mo9ZJgNPNZPmD0pkmWAyh+o0OvpD0axDW+BFapVTkjQpuVuqV2esxgCesWbwCt64E/NTPh0s6IBQtzpjQxfbr6JuwQxdEWnxw8hQXMBNsqJjoW0+aj2H64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753748729; c=relaxed/simple;
	bh=RoctGCbY7olr40ROIMv6PP2Jn/JKaFe2TkztjQ8i/1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TKYvDE9g33QxVjBc0x2ZCu2SuZkvXUdlJ99MNJoi3UeUxGXAHmrOPaRkOmRyULVBVQ6EAa70G3ikK4Zjjchhj0s22JX5wKzGP6iM1zdksjbW09ojJ+Yw6KhJZX2FfKfL3Y6Um6uvT+lji8+UI/gJgY9+v/eWA6Eo+TDeavUUE+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5DD05604FB; Tue, 29 Jul 2025 02:25:23 +0200 (CEST)
Date: Tue, 29 Jul 2025 02:25:23 +0200
From: Florian Westphal <fw@strlen.de>
To: Dan Moulding <dan@danm.net>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	regressions@lists.linux.dev
Subject: Re: [REGRESSION] v6.16 system hangs (bisected to nf_conntrack fix)
Message-ID: <aIgU6kbVyz-bKR3W@strlen.de>
References: <20250728232506.7170-1-dan@danm.net>
 <aIgMKCuhag2snagZ@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIgMKCuhag2snagZ@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> and keep nf_ct_resolve_clash_harder().
           ~~~~~~~~~~
Meant nf_ct_should_gc() (i.e. the change in nf_conntrack.h).
