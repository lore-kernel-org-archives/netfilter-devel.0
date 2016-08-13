From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: remove ip_conntrack* sysctl compat code
Date: Sat, 13 Aug 2016 12:10:18 +0200
Message-ID: <20160813101018.GC1376@salvia>
References: <1471002426-3803-1-git-send-email-pablo@netfilter.org>
 <CAML_gOe84HZUgCr+ECxAxgO-21BbwQtvfWV_V7DNQWQUuzhGiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56714 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbcHMKLM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Aug 2016 06:11:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 7E85BA417C
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Aug 2016 12:10:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 71F619663C
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Aug 2016 12:10:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 551F39D5BE
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Aug 2016 12:10:26 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAML_gOe84HZUgCr+ECxAxgO-21BbwQtvfWV_V7DNQWQUuzhGiA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Aug 13, 2016 at 03:09:14PM +0800, Liping Zhang wrote:
> Hi Pablo,
> 2016-08-12 19:47 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> > diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> > index dd2c43a..22558b7 100644
> > --- a/net/netfilter/nf_conntrack_core.c
> > +++ b/net/netfilter/nf_conntrack_core.c
> > @@ -161,10 +161,7 @@ static void nf_conntrack_all_unlock(void)
> >  }
> >
> >  unsigned int nf_conntrack_htable_size __read_mostly;
> > -EXPORT_SYMBOL_GPL(nf_conntrack_htable_size);
> 
> We still need to export nf_conntrack_htable_size, otherwise:
> 
> ERROR: "nf_conntrack_htable_size"
> [net/netfilter/nfnetlink_cttimeout.ko] undefined!
> ERROR: "nf_conntrack_htable_size"
> [net/netfilter/nf_conntrack_netlink.ko] undefined!
> ERROR: "nf_conntrack_htable_size"
> [net/ipv4/netfilter/nf_conntrack_ipv4.ko] undefined!

I see, will send a v2. Thanks!
