Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BD72F83AC;
	Mon,  5 Jan 2026 14:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767623860; cv=none; b=iheDk+vyJ8DYRW45J1HkJqO67NXD7TPjR6Vn4szheXcUWGb8qgSsBK5UBjk26XfmjFYtUHnu8qG9P5iVRgwGDSdMgrX/hUpsP8Fcycwyx8wwTK9T1R0nQl54msXMohAXFp0XM0iUMpleBZz/c3klcatm5GGBrsqzAz/zNHXb71s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767623860; c=relaxed/simple;
	bh=r8InnM7CWzRXcHzjg2Qv5gtmy2MttSw4zvRMyXDY3cQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U1QOE2NvIw2INXraxsa1P3BmOKSnlARJnxEUlV2J4OvntXnPCjES02QCw8VJvvIBwqd3nFdsUX79k+rwuiFopdxEgodn0dljf0Tfd4nqiJVHNTujdYjx4EK1Pbfn4ofv6uQ9JIEGHCzUPkDeP7V97x0KFQxpXByoqqT9w6eaa5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=zbfkZdRE; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="zbfkZdRE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
	In-Reply-To:References; bh=qrztH/Bu5dLCW+mHwisY0aYQyMQV85bZ08nlEFScStM=; b=zb
	fkZdREj3+PDmoGxO8n0D6uPG/4mLD8k6Y9Co36LXqhp2kd+bYgg46Oid5+fzE+saHkPA/cQtWgcU8
	Q8BbmVa9h+Uv7ouJBvrafEVvXq8Vh0xy2GqEdTcxOcB8ICiQVSPoNmKqL77IVEk1u+5ttKef9EXFM
	mfvNC1Wd0kqzYqw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1vclhq-001Uoc-PK; Mon, 05 Jan 2026 15:37:14 +0100
Date: Mon, 5 Jan 2026 15:37:14 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [PATCH RFC net-next 1/3] uapi: add INT_MAX and INT_MIN constants
Message-ID: <ae78ddb2-7b5f-4d3b-adef-97b0ab363a30@lunn.ch>
References: <20260105-uapi-limits-v1-0-023bc7a13037@linutronix.de>
 <20260105-uapi-limits-v1-1-023bc7a13037@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260105-uapi-limits-v1-1-023bc7a13037@linutronix.de>

On Mon, Jan 05, 2026 at 09:26:47AM +0100, Thomas Weißschuh wrote:
> Some UAPI headers use INT_MAX and INT_MIN. Currently they include
> <limits.h> for their definitions, which introduces a problematic
> dependency on libc.
> 
> Add custom, namespaced definitions of INT_MAX and INT_MIN using the
> same values as the regular kernel code.

Maybe a dumb question.

> +#define __KERNEL_INT_MAX ((int)(~0U >> 1))
> +#define __KERNEL_INT_MIN (-__KERNEL_INT_MAX - 1)

How does this work for a 32 bit userspace on top of a 64 bit kernel?

And do we need to be careful with KERNEL in the name, in that for a 32
bit userspace, this is going to be 32bit max int, when in fact the
kernel is using 64 bit max int?

       Andrew
