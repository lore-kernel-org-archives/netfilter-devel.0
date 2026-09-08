Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFFB47C0F6;
	Tue,  8 Sep 2026 20:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788899096; cv=none; b=qz1dfbitfP4bMiTK5qVBVliq3uaVRsh7lQszqDjH5YRjRGxMZboip9k7vDQkpYcMEaaZt6lX8mZgvmKJhHdgXeKJxLV0+JiAhy3wluW881RL/nv1OG0TnW3Bmz85vB5YwF5Mqtz5Lh+1DmYx0z41aDWNxEk9ZgZwqZwQhSlDe60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788899096; c=relaxed/simple;
	bh=JAnf0/QKxIy/4pYio9ChJmvFrA6akr8eqhLh/IIXslQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sfbGnYZmdibU1wdsbje5kdK8CiPmk5PaCkDQwh2zmNMbISeOvLUBkofmXd0sd6HOIq4sxunoXBEUdBYHmiHvHdT93HB1pB/farEj8MNlMIrrh9jg+3GeIhOK88XemNQ9JcdMN7KRsmYi0R9oWF5IA9tNrD4stXFoG3mUaCdpmuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ZUZAh5rZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ZUZAh5rZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788899092;
	bh=9w/hp6IqASEh10N66WRbnqR28Hnd4b4Oi5v1ZPZ6Az4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZUZAh5rZz2JXri6ho3CHcY/lH2P0W59ae1jAqE7Cks/5nyoC5uId+3kMwrOL8+c+x
	 jxXwT3akAWltv80Q09+2rmjCGc+HCJD+BrI8WhafB7HgQXT2L9ui9ZguWfXcsfsVXT
	 ivpcqpkDuyD4jjevwfFR0tp3QLLruUPBJ28/T7bzfrM44/B6diG7gC8B4hnRRnhoR/
	 vUV4e9X6Fx/kcen1sT4uMs5BLf5sU0Zg+zCzvBNige5HurCLL0DkAXGKYVT4aYNoAI
	 glyFgXN8PEhO1dwrFsjJXqdBoaFZj8S3JH9MQrcWUhzrL3zys+BHQHZ1wNIEd0yDC9
	 2yzWylsbnwO7A==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 6A9B66008A;
	Tue,  8 Sep 2026 22:24:52 +0200 (CEST)
Date: Tue, 8 Sep 2026 22:24:50 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sashiko@kernel.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 4/9] netfilter: cttimeout: prevent UAF during module
 unload
Message-ID: <aqBvEkkkm11rIqwT@chamomile>
References: <20260907171732.1407739-5-pablo@netfilter.org>
 <178889064168.219967.15151233151602486944@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <178889064168.219967.15151233151602486944@kernel.org>

On Tue, Sep 08, 2026 at 06:04:01PM +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider:
> 
> Critical: 0 · High: 1 · Medium: 0 · Low: 0
> 
> - [High] cttimeout_exit() only drains RCU readers that reach the per-net
>   timeout storage through nf_ct_timeout_hook.
> 
> --
> 
> netfilter: cttimeout: prevent UAF during module unload
> 
> This reorders cttimeout_exit() so that nf_ct_timeout_hook is cleared and
> synchronize_net() is called before unregister_pernet_subsys() frees the
> per-net timeout storage.  That closes the window where nf_ct_set_timeout()
> could still reach the freed nfct_timeout_pernet blob through the hook.
> 
> > diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
> > index 66c2016f6049d..132c02ac7c4ea 100644
> > --- a/net/netfilter/nfnetlink_cttimeout.c
> > +++ b/net/netfilter/nfnetlink_cttimeout.c
> > @@ -652,9 +652,9 @@ static void __exit cttimeout_exit(void)
> >  {
> >  	nfnetlink_subsys_unregister(&cttimeout_subsys);
> >  
> > -	unregister_pernet_subsys(&cttimeout_ops);
> >  	RCU_INIT_POINTER(nf_ct_timeout_hook, NULL);
> >  	synchronize_net();
> > +	unregister_pernet_subsys(&cttimeout_ops);
> >  }
> 
> [Severity: High]
> Does this leave the same per-net object reachable from the netlink dump
> path during unload?
> 
> cttimeout_get_timeout() starts the dump without a module reference:
> 
> net/netfilter/nfnetlink_cttimeout.c:cttimeout_get_timeout() {
> 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
> 		struct netlink_dump_control c = {
> 			.dump = ctnl_timeout_dump,
> 		};
> 		return netlink_dump_start(info->sk, skb, info->nlh, &c);
> 	}
> 
> With no .module set, __netlink_dump_start()'s try_module_get(control->module)
> is try_module_get(NULL), which succeeds without taking anything, and
> cb->module stays NULL.  nf_tables_api.c and nfnetlink_hook.c pass
> .module = THIS_MODULE in their netlink_dump_control for comparison.

This is a pre-existing issue. I can follow up on this.
