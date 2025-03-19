Received: from Chamillionaire.breakpoint.cc (unknown [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738BE2135DE;
	Wed, 19 Mar 2025 21:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742419349; cv=none; b=dgviAlluWfUMX52xq1wnlngt3F3l1px1WdGzHoXGqTlH3jM0SXOsiJh9n4pLiDDiJ33KTimPnrVwExuq1mN9M/zPYSZ43XA9hplvJWUCEvXupw02LSYtzfCnseCXU7a3flkUP25qFwFvCFNcRa6srRrP2JoBT770ye0OFaKTs3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742419349; c=relaxed/simple;
	bh=mk6K1vRRWM2J2POoK0XsPQO8DsR1T0vh3kZyOR5gqf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b0Lh2tKul06ig9ak59bmOwMas5+5iOizrJVEuZ57FhMNoFhROg/83N3k/se7tUMDAJ7DvLYy+w5rDTGuIZtkn6CFJvyKx4WdSnA5w6YDpDVS6jHQQn0jxNIuwG3Xo2Hcy7VT859aPwFI0/BFr/CSZZO4y+avoxp/c2nRco4IKWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tv0rT-0004Ob-P7; Wed, 19 Mar 2025 22:22:03 +0100
Date: Wed, 19 Mar 2025 22:22:03 +0100
From: Florian Westphal <fw@strlen.de>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: x_tables: Remove unnecessary
 strscpy() size arguments
Message-ID: <20250319212203.GA16833@breakpoint.cc>
References: <20250319194934.3801-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250319194934.3801-1-thorsten.blum@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)

Thorsten Blum <thorsten.blum@linux.dev> wrote:
> If the destination buffer has a fixed length, both strscpy_pad() and
> strscpy() automatically determine its size using sizeof() when the
> argument is omitted. This makes the explicit sizeof() calls unnecessary.
> Remove them.

Sorry, not going to ack this, IMO this is just useless noise.
