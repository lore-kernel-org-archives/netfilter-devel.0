Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3747228F5;
	Mon,  6 Jan 2025 13:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736171363; cv=none; b=EqI7bX/E6C6g5D7H/K7fN3MGIWSh9ZeyqsW0cAz2EpjfGiBnU3scs+TLJZ90pOxOOb8zGGshqsl9y6axqm5ZUICm+yNThLf4sB7NlCrXEOqUAPD2z/P4/xXfEClmE/Az5FoXePnaiREAaoLYcMx0AGjcJnCvGxoCjsfu+PSjpCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736171363; c=relaxed/simple;
	bh=mlKhnXGlZu8yacyFBE1S0qsCUjWibDYCjyTqs4XdfKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NZ4tj9oKtAuVFq+wrFqfs8GG8Pqm6JzP97S7io+BhXBgveJlptGsxDijcqyaExt6s90LS2MmTzS8Osk1TISq1YQwUC2qvsqT1CNMUAHQhxtWbSOhZtxArUw/Vmvn70pnyioEdnw06bQpC2fQoiXKUI2LggFdVfDI+KDR5l7RMiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=Bxqge1Rb; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="Bxqge1Rb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
	In-Reply-To:References; bh=caYywZfl2FSaCYKsuZipzKvZLYYQi8xpEL2ba4/CJbI=; b=Bx
	qge1RbRfx2mJMzlrxaAudETFTZ99SELE1+gqxaRhYZXctLzcYA5SdIsaHWFJi/GTsQjTssol0VydV
	81bfP4dsjU/jGaA5KsfsjlD1ONfU2iY8A+bUGrb5lJLuELFSLbgrWCpu0bFELXksiLDi/nvW2AaY8
	rkzQBY2jkQKRBz0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1tUnTS-001tF3-VI; Mon, 06 Jan 2025 14:48:54 +0100
Date: Mon, 6 Jan 2025 14:48:54 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: =?utf-8?B?U3rFkWtl?= Benjamin <egyszeregy@freemail.hu>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>, lorenzo@kernel.org,
	daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com,
	kadlec@netfilter.org, David Miller <davem@davemloft.net>,
	dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v5 1/3] netfilter: x_tables: Merge xt_*.h and ipt_*.h
 files which has same name.
Message-ID: <4b90ca20-6671-4878-8cfe-251613c64194@lunn.ch>
References: <20250105203452.101067-1-egyszeregy@freemail.hu>
 <43f658e7-b33e-4ac9-8152-42b230a416b7@lunn.ch>
 <defa70d2-0f0c-471e-88c0-d63f3f1cd146@freemail.hu>
 <ee78ed44-7eed-0a80-6525-61b5925df431@blackhole.kfki.hu>
 <cb4b77e3-65c3-4fd4-94bb-a2b35a6dcfb5@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cb4b77e3-65c3-4fd4-94bb-a2b35a6dcfb5@freemail.hu>

> > No, it was your fault in the v5 series of your patches: you managed to
> > send all the patches in a single email instead of separated ones.

Yes, i found that after i replied. I doubt git send-email was used.

> - 1. [PATCH v7 0/3] which is the cover letter, is appering really slowly in
> the list after [PATCH v7 1/3], [PATCH v7 2/3], [PATCH v7 3/3] were arrived.
> This is why I made v7 after v6, because after 10 minutes i still could not
> see that it is successfully arrived in the mailing list, I fustrated about
> it again went wrong.

You obviously did not read the links i gave you. One of them says:

   don’t repost your patches within one 24h period

and there is a later section in the document which explains why.
 
	Andrew
