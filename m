Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7452459AD3
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2026 14:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787668122; cv=none; b=PrVyz4lNAwLdlbDVF00bt9FYnPIvZljqlzq1yACQrlCi2xbFrANTPFxzejJKXHHOBSslmcxEFXD1l/7C2fOmPzzAxlELo9jQPTO9QgWQDaqmz2uRym7JB5P05ccVVP/mtKq4EZ1bsQSLG6FaHGnHYsHtXR5scEo6stOw/EuyWwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787668122; c=relaxed/simple;
	bh=cbqZtm/Xuo7iMumBE4ESXL6z2NJe0WN1u+QHFI1UwuU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eWt3HIXbq0ArvUZP3hAurjSLVEXzX1EsvIHgD27Oug3lXokUSUI+uJKRkkL47+fIsXHHFvKudAEiQKoJZ1jeRz41IVcBCnIiM1+fljV6ZSWNcJaWcGzS4AJmCLPBbFKeORdQMqcdWwvAjBeBJI6iC5AQyWgfYeNtdAJ9uSaQ0t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 21F5860388; Tue, 25 Aug 2026 16:28:38 +0200 (CEST)
Date: Tue, 25 Aug 2026 16:28:32 +0200
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [PATCH v2 nf 0/5] netfilter: ipset: rhashtable conversion
Message-ID: <ao2mkGihOkjO3ETE@strlen.de>
References: <20260825132843.1692-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825132843.1692-1-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> Identical resend except for a one-line kfree_rcu change in patch 3.

FWIW, this almost identical iteration triggers new/different reports
from LLM, so I have to make a v3.

https://sashiko.dev/#/patchset/20260825132843.1692-1-fw%40strlen.de

Whats interesting is the double-down on the useless comments to patch 4.
