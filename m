Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087CD41B379;
	Wed, 29 Apr 2026 18:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777486978; cv=none; b=s+pu1UbQgYwxLU2ZpO6TSat+ckAN5TAKUs5mLnvwyh60u5hvc+Yqmf/NDqiGyoKGllT8LNYJohiTf6fiDlxG0z6945FKsmgnoAFyqYSRuufNokpVJ90iDc5G94t500kULjFfFAtPArGxXqsqP9aDBN1ytwQ17luwKohbj5IRD9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777486978; c=relaxed/simple;
	bh=pxBQFD3yB0Gs60ovsaXwB0grb9kcRUuCWUi5TwOVx3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VyUVqRr9oMfVZyF3h6I5QW9AhgVxUIw2Lhj0BTuHgSavpcwgZggTmijqVtIp44G6/tGGBIfhQp49o5ca2aJbarZOVpTOj4/A5afRA/Bf6O7VZ4smlcTltBBOVZSapxvsmNTrS1TMdkRuZ/PccofuSzwwmCF6ov5C3NsB5mUUUD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=E/YwELSc; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="E/YwELSc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JIjFb8gPaZ6kuiayMq8XWinpuxhx075Z9YsnxLBDwpI=; b=E/YwELScW7aKXm7Cyz4kst3P9H
	xqHlru3VzyZHf9l2aU8BCloTR+HE57Kv6SjDO+Lk0UQ8kv1mTjIzI73GWd4c5zk9Pf4pJjDYinkAZ
	2YNHEIcOuFzDYSFdwzM+2etRKeINi6wbQYQeVdvsQwz0sKipxzGCsx88zy7MdvVcUbFKHY1aIYgjW
	xgOVRAOf936qnr273MxWYb21O8wRcAh0gPtB6sYrNusuIr55OIHsH0R8IvaFbuWtIhtD0XWAwWsbD
	1ZlLwNxOroAgdErVmLytu5mQGON+4Y7MdkW87LzfHqZfzRKEKTBM2N2vu+PC6FMqCUPcHYjtGgwJ7
	QzlDMWkg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wI9TE-000000002Zv-2Qq1;
	Wed, 29 Apr 2026 20:17:12 +0200
Date: Wed, 29 Apr 2026 20:17:12 +0200
From: Phil Sutter <phil@nwl.cc>
To: Tristan Madani <tristmd@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: Re: [PATCH 0/2] netfilter: fix NULL ops race in iptable lazy init
Message-ID: <afJLKOpoHEGZ0zT_@orbyte.nwl.cc>
References: <20260429175613.1459342-1-tristmd@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429175613.1459342-1-tristmd@gmail.com>

Hi,

On Wed, Apr 29, 2026 at 05:56:10PM +0000, Tristan Madani wrote:
> From: Tristan Madani <tristan@talencesecurity.com>
> 
> ipt_register_table() and ip6t_register_table() call xt_register_table()
> which adds the new table to the per-netns list, making it visible to
> other code paths.  Only afterwards do they allocate the per-net copy of
> hook ops via kmemdup_array().  This leaves a window where the table is
> findable via xt_find_table() but has ops=NULL.
> 
> If cleanup_net runs during this window (racing namespace teardown against
> lazy table init), ipt_unregister_table_pre_exit() /
> ip6t_unregister_table_pre_exit() finds the table and passes the NULL ops
> pointer to nf_unregister_net_hooks(), causing a general protection fault.
> 
> Fix both ip_tables.c and ip6_tables.c by moving the ops allocation
> before xt_register_table(), so the table is never in the list with a
> NULL ops pointer.

Is this true? Your patch moves the ops allocation, but new_table->ops is
still assigned after xt_register_table() has returned. AIUI, the race
window is just reduced, not eliminated.

First I thought you could assign to table->ops since xt_register_table()
calls kmemdup(), but 'table' is const.

I guess checking table->ops value in *_pre_exit() is nonsense as well
since *_register_table() still runs in parallel. Do we need
serialization between the two routines?

Cheers, Phil
