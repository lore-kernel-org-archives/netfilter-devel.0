Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2727280A21;
	Sat, 20 Dec 2025 19:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766258223; cv=none; b=OE3nETH9zv7cZ1fuCT35z2vyI/kKpreGqCfu/EXX3+PKi8zBFV5yY15jXpCBxRFgM+KuRRM73U5DPIgoP3rQsTeMp1g6MO52Xs54QJwG4CstZCgd3PE27fLANqFAW0P8g/TmkYz8yOscb4QNBhlcpMTbuRpCvVqtB48+GI9WX7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766258223; c=relaxed/simple;
	bh=wNcAmYBMJRoxLEEkuFIyrUQOB9kkOUqZdUxsj7Aizkg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YnAV8OF7GqvvjKq5cpJJKFCGVmjZEzddPmjAagZb7cz0wT7noebOD3kLQs1aFYqv6ywVllak3tpBXZuO92v2VKPWdtwbtPqvR2ISKXonXBiijbClCJ26MXKNSu+w5CvWlrazbkrHHHeYdNagIVHL5bVn4lbSIyjCC7Nuf8flGdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C89D560351; Sat, 20 Dec 2025 20:16:51 +0100 (CET)
Date: Sat, 20 Dec 2025 20:16:45 +0100
From: Florian Westphal <fw@strlen.de>
To: Daniel Gomez <da.gomez@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Lucas De Marchi <demarchi@kernel.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org,
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
	Daniel Gomez <da.gomez@samsung.com>
Subject: Re: [PATCH] netfilter: replace -EEXIST with -EBUSY
Message-ID: <aUb2HS6kTR-z7gp2@strlen.de>
References: <20251219-dev-module-init-eexists-netfilter-v1-1-efd3f62412dc@samsung.com>
 <aUUDRGqMQ_Ss3bDJ@strlen.de>
 <fdb9f97d-7813-48a0-9fdf-ddc039d853eb@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fdb9f97d-7813-48a0-9fdf-ddc039d853eb@kernel.org>

Daniel Gomez <da.gomez@kernel.org> wrote:
> something like:
> 
> Replace -EEXIST with -EBUSY to ensure correct error reporting in the module
> initialization path.

Makes sense, I will mangle it locally when I apply this.  Thanks!
