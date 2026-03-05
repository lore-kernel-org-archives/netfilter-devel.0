Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD5B366835
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Mar 2026 16:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772729712; cv=none; b=G7+iE2wFZ5kiPWpfARIJ40BC6+4KaFGaNTcwKHqa5zOH8KoP2O6YtjwZrb31miZnIEmcv0UOE9xofgp2xHZ1KWeC3YSAhm7zuW/ISfB8ukwzaaowVyy5zV7k5bLMphil6tLW7lQec4hZMrd7nCoM3ZM6A1dLbdirCgrG3/OicSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772729712; c=relaxed/simple;
	bh=AFLaw3wpfNRhyjorFbWdJf3lWwhsj/NLNQjU2ftX4NA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hc6485pGhK9H0/aQJ897gr5MrjHhVQoQxrPKEiD9c0ri8ohT2BiJDHv7dsbN6ptuPk1Fx8smQSxjlsRdyl3UCbPAXhm1Sa/WUzrdhsiD0LacQHqJQzZmUO8k25NmmyBU0YfO/DiO3cU9C4ZHG9sEj9bbVVp5Gf0uyuACNc1zk1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=eoyEzQbi; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="eoyEzQbi"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 6AE01602D4;
	Thu,  5 Mar 2026 17:55:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1772729708;
	bh=MrkkrfLS9p1+HxPgEYCgu3wk8xfL1QO84VTB3fJKldU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eoyEzQbiU6LBMFBFTOJiU/ngZvySWLgSYZ9qY/LEaiI5l6qc2tV2p9y0xUP/JS3nc
	 UoBzUF/+XFoKgfrCcOShbyQP+/7xcuJfjB4zM/3hKcmqvr4RUeLTKhnDP6lnho7+SI
	 cEfV8GpBQwGKF5NRRN2yr0rZtWvHb8zKbWIcnD4Zg8rXiYLANwkrUicr+TfMzVzBso
	 gAfNvgGCMnNreTbPucQjkztihMInyjSRTkGKbusWhz4ilw3KlV64vjVwNkETJTkahl
	 qBb70xMpOSUShMfJCWwcZoGVZSxQ5Sm5HfZY++VwIYo1fs16hoI1qRzcvs+3GgkBkT
	 jUyXJoFpo89Rg==
Date: Thu, 5 Mar 2026 17:55:05 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Anton Moryakov <ant.v.moryakov@gmail.com>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] rule: fix NULL pointer dereference in do_list_flowtable
Message-ID: <aam1aXkmlFaHIusE@chamomile>
References: <20260302160539.248755-1-ant.v.moryakov@gmail.com>
 <aamNhIWHDeGQOXaf@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aamNhIWHDeGQOXaf@strlen.de>

On Thu, Mar 05, 2026 at 03:04:52PM +0100, Florian Westphal wrote:
> Anton Moryakov <ant.v.moryakov@gmail.com> wrote:
> > Static analysis found a potential NULL pointer dereference in
> > do_command_list() when handling CMD_OBJ_FLOWTABLE.
> > 
> > If cmd->handle.table.name is not specified, the table pointer remains
> > NULL after the cache lookup block. However, do_list_flowtable() expects
> > a valid table pointer and dereferences it via ft_cache_find().
> 
> Not following, table is never NULL in the function:

Yes, static analysis keeps coming here with this.

Maybe add assert(table) to give them a hint so this is not reported
again.

> static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
> {
> 	struct table *table = NULL; [..]
> 
> 	if (cmd->handle.table.name != NULL) {
> 		table = table_cache_find(&ctx->nft->cache.table_cache,
> 					 cmd->handle.table.name,
> 					 cmd->handle.family);
> 		if (!table) {
> 			errno = ENOENT;
> 			return -1;
> 		}
> 	}
> 
> 	switch (cmd->obj) {
> [..]
> 	case CMD_OBJ_FLOWTABLE:
> 		return do_list_flowtable(ctx, cmd, table);
> 
> This has been the case for almost a year:
> 
> commit 853d3a2d3cbdc7aab16d3d33999d00b32a6db7ce
> Date:   Thu Mar 20 14:31:42 2025 +0100
> rule: return error if table does not exist
> 
