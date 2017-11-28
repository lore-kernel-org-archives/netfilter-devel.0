From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next,RFC 2/3] netfilter: ctnetlink: use 64-bit
 conntrack ID
Date: Tue, 28 Nov 2017 16:45:09 +0100
Message-ID: <20171128154509.GB1444@salvia>
References: <20171128021309.11277-1-pablo@netfilter.org>
 <20171128021309.11277-2-pablo@netfilter.org>
 <20171128121206.GG23412@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, richard@nod.at
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32958 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753469AbdK1PpM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Nov 2017 10:45:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5716A1B2B73
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Nov 2017 16:45:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 469D9DA80B
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Nov 2017 16:45:11 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171128121206.GG23412@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 28, 2017 at 01:12:06PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >  static int ctnetlink_flush_conntrack(struct net *net,
> > @@ -1174,6 +1177,13 @@ static int ctnetlink_del_conntrack(struct net *net, struct sock *ctnl,
> >  			nf_ct_put(ct);
> >  			return -ENOENT;
> >  		}
> > +	} else if (cda[CTA_ID64]) {
> > +		u64 id = ntohl(nla_get_be64(cda[CTA_ID64]));
> 
> be64_to_cpu()?
> 
> But at this point we already uniquely identified the conntrack entry
> so the ID check appears to be unneeded?
> 
> I never understood existing test either, so this remark isn't specific
> to your patch.

When the ID was incremental, not a memory address, you could use it to
specifically refer to a conntrack through tuple + id.

If a conntrack with tuple X is gone, then created again, you refer to
the right object.
