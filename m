Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5599A374E60;
	Sun,  7 Jun 2026 09:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780823176; cv=none; b=k5OUBvJQzr6WS3HRqF/wxn2ulnbNA5qKbUwTgHOXHZRKmu+10DIIXmG2vpRhiO53DofeAf/fhooqhYAOP29ABGxwqhxs1i3+VtGp4nocnqWDhw09XKBz5Uw6K2ZOxZe8zlVBzaQGosaLBfGwZS4d/UgtnzXpfRzGc7jOwDC+Glk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780823176; c=relaxed/simple;
	bh=jH5IacHCfa1exoQoEiifl2qV9mZY7B8MX7QP2VF6Gus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mYlCax8EYPz6Q+J+nysMXYKR97R8scV3VxLh4nZrZqYnA7WpBOhPvZRHHe1n6ytvAqPFOAswV0RGLn6sQOnt4EW+ejohk31XppPn0ADQ6lqhj5dXZOJ9Xx267qg8QqxHJZH72hlZ3SebSgdkTV47CQFFGuMQ9t5siaDmck683Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=M9TBxBqW; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="M9TBxBqW"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 17F036017D;
	Sun,  7 Jun 2026 11:06:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780823164;
	bh=2HBpyxOGYXTX59z3igPQadtZGsHjN3rD8ejQRTQyb/w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M9TBxBqWx8RaIzJmbSEZBKfkEFHq62XKHBqsUwrRKnkcIaf+QLlyQPBRE+gYLKeEN
	 OAf0xlmKAcI2szVI1h4I2T8cAXrJDRlvF5c7CK0WvJ1ZlECfr5Hoi+kxgnsGIPGk2t
	 98cDDIWGILmiHgFPhQo1tHo49mLLMZIXVWRXRL08I/47/Z4IUIQhP1GgwAsOMhJvLU
	 ofhRvgNj2LQIxSq1t5JpJ6/kwjX1OE1G3ncTJ2N1jB3z/8xZ8zcDALhFehQif2rLz8
	 PJX2y2OlX9APX3KBSLIk4uUA6Y1IszaKFPlbQnUBqPweHTit9Rys9HfkaCgKUQFrGJ
	 psVrEe4iOQ8Rw==
Date: Sun, 7 Jun 2026 11:06:00 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Rosen Penev <rosenp@gmail.com>, netfilter-devel@vger.kernel.org,
	linusw@kernel.org, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	"open list:NETFILTER" <coreteam@netfilter.org>,
	"open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] netfilter: nf_conntrack: use get_unaligned_be32() in
 tcp_sack()
Message-ID: <aiU0eKvHtfL1eD1j@chamomile>
References: <20260525215840.93217-1-rosenp@gmail.com>
 <a8cfeb06-6ffb-49f2-a14d-c5a50bc4e5be@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a8cfeb06-6ffb-49f2-a14d-c5a50bc4e5be@suse.de>

Hi Fernando,

On Tue, May 26, 2026 at 12:35:22AM +0200, Fernando Fernandez Mancera wrote:
> On 5/25/26 11:58 PM, Rosen Penev wrote:
> > The timestamp-only fast path dereferences the option stream as
> > *(__be32 *)ptr, which assumes 4-byte alignment that the TCP option
> > stream does not guarantee. Use get_unaligned_be32() instead, which
> > reads the value safely and already returns host byte order, so the
> > htonl() on the comparison constant can be dropped.
> > 
> > This matches the existing get_unaligned_be32() use later in the same
> > function.
> > 
> > Assisted-by: Claude:Opus-4.7
> > Signed-off-by: Rosen Penev <rosenp@gmail.com>
> I already spotted this corner case when working on a SYNPROXY patch [1] but
> didn't send a patch yet. I think this is for correctness too.
> 
> Anyway, it is likely that there are more places where this tweak is needed..

I agree a more general audit to spot unaligned access, targetting
nf-next would be good.

Thanks.

> I will look around.. meanwhile:
> 
> Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
> 
> [1] lore.kernel.org/netfilter-devel/20260525124450.6043-4-fmancera@suse.de/
