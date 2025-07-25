Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345B52D3734;
	Fri, 25 Jul 2025 09:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753437351; cv=none; b=rPl9G8niT/+A1jHaYX4tcjgZiLgXiR0sG7vNqaR+sUw6KxZC9t0KRex/6tUHBp8lfPiC6ZgMyi3GVG14Igvv9M34XupSlPbP4RQVzze53i7WLMuOAG3aE+RdE2pFOc07hb9oLGVnjW8Eb5Whhvi+XAKeuktRTHPWtNQUGGPJo2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753437351; c=relaxed/simple;
	bh=obxzbRARWp61SAgr4OuGSyuQbiBqYc6yJPDRw1+VWFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=asX8DGEkU6R6qrIaeC/pwnMWCDGcmXmRNsDog1l7WTX/ZZ+vko1mdH54QcVG1s+ryURDZTWH5U1i2zRDDSLZ8AIRn5nMpIkyMY/6qV3dP/70Rptg+q1ZZImXxRaDKzXvd5YUjh7mAVUuj9NZEw02JUhZ9K99KoLO0HP6ZlsNK/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RW9yXgut; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JnidZ9xa; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RW9yXgut";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JnidZ9xa"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 1C41460272; Fri, 25 Jul 2025 11:55:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753437341;
	bh=UynE9Asxg2hIcZ+zLWqbX0Hja+9AhIsgeadpl92uNQ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RW9yXgutzmmpvsQ2npdmWr33e7Oi5h/NwPgf782L6PTblPuuaRoL86pNIuL4gF5o5
	 Yxay7k+3cbFOVvcC8gsG84GpEl3/ItwVPZXEETdSQIPjUI+vhcg54XsIXs+wWGFWoZ
	 lh3muGxpndKamr9+StUXd9She/o3bp2gKPjXmiQDEr3h2TnuzEtwQBEHrk5n1myy7y
	 s2HZk1+j4f1xJloeE6YaHd4YEY5n+EHdd37LqR9cPNQqsrbHj2Ou/P4MTDtmAPIInF
	 MUixzLD/U3KtPHR8yxrSKpgvcd81gBD5FW2uRt2oy2RmgjCvXp3u5p5040v0ZluBg0
	 4Izs8QqWkIbHg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C028660251;
	Fri, 25 Jul 2025 11:55:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753437338;
	bh=UynE9Asxg2hIcZ+zLWqbX0Hja+9AhIsgeadpl92uNQ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JnidZ9xaZ29WUBKCefYXULw6SHvmz/xszjzq11DjCpkyzU5WXlQasxad7LSe96eKR
	 jiECGQUVZDIVJEPUm30qQAf3+73yH8xDdXzl/m3IH0M4bdyyBlZDe+z8vnD3B3XZeJ
	 E9kKlUF70d0RPiJBUylFFoL+KO3ZKnsJE1NjS9ycxwjPEwtqdgcp95ZLmZV7ZCByJg
	 iYR+t2vLkSfhiBfMZZODOdm10ykakiKwyZ/lJzqjyPIH9Fj04hbtMLv67OqtykDOPH
	 9RfwCJ7C0lpItbkkDrH43CsEw5190KXIeRA3bGBPhFgwq/2aqyLVvZLSibSfOI+Hl+
	 ajAHw+hvAxvWw==
Date: Fri, 25 Jul 2025 11:55:34 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: lvxiafei <xiafei_xupt@163.com>, coreteam@netfilter.org,
	davem@davemloft.net, edumazet@google.com, horms@kernel.org,
	kadlec@netfilter.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
	lvxiafei@sensetime.com, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH V2] netfilter: nf_conntrack: table full detailed log
Message-ID: <aINUlqscselprHTd@calendula>
References: <20250508081313.57914-1-xiafei_xupt@163.com>
 <20250522091954.47067-1-xiafei_xupt@163.com>
 <aIA0kYa1oi6YPQX8@calendula>
 <aIJQqacIH7jAzoEa@strlen.de>
 <aILC8COcZTQsj6sG@calendula>
 <aILH9Z_C3V7BH6of@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aILH9Z_C3V7BH6of@strlen.de>

On Fri, Jul 25, 2025 at 01:55:33AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > I was thinking, does the packet logging exposes already the
> > net->ns.inum? IIUC the goal is to find what netns is dropping what
> > packet and the reason for the packet drop, not only in this case but
> > in every case, to ease finding the needle in the stack. If so, then it
> > probably makes sense to consolidate this around nf_log()
> > infrastructure.
> 
> No, it doesn't.  It also depends on the backend:
> for syslog, nothing will be logged unless nf_log_all_netns sysctl is
> enabled.
> 
> For nflog, it is logged, to the relevant namespaces ulogd, or not in
> case that netns doesn't have ulogd running.
> 
> For syslog one could extend nf_log_dump_packet_common() but I'm not sure
> how forgiving existing log parsers are when this gets additional
> field.
> 
> Also, would (in case we use this for the "table full" condition), should
> this log unconditionally or does it need a new sysctl?
> 
> Does it need auto-ratelimit (probably yes, its called during packet
> flood so we dont want to flood syslog/ulog)?

Yes, such extension would need to answer these questions.

> > Anyway, maybe I'm overdoing, I'll be fine with this approach if you
> > consider it good enough to improve the situation.
> 
> I think its better than current state of affairs since it at least
> allows to figure out which netns is experiencing this.

Thanks for explaining, let's take this patch as is then.
