From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH 3/4] add support for modifying secmark via ctnetlink
Date: Wed, 21 May 2008 21:42:19 +1000 (EST)
Message-ID: <Xine.LNX.4.64.0805212129150.19104@us.intercode.com.au>
References: <483350D3.50103@netfilter.org> <48340438.5020106@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>, Paul Moore <paul.moore@hp.com>,
	Stephen Smalley <sds@tycho.nsa.gov>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from namei.org ([69.55.235.186]:57276 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759761AbYEULmy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 07:42:54 -0400
In-Reply-To: <48340438.5020106@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 21 May 2008, Patrick McHardy wrote:

> Pablo Neira Ayuso wrote:
> > As for now we only support dumping. This patch adds support to change
> > the secmark from ctnetlink.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > Index: net-2.6.git/net/netfilter/nf_conntrack_netlink.c
> > ===================================================================
> > --- net-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2008-05-20
> > 22:10:31.000000000 +0200
> > +++ net-2.6.git/net/netfilter/nf_conntrack_netlink.c	2008-05-20
> > 22:10:56.000000000 +0200
> > @@ -1121,6 +1121,11 @@ ctnetlink_change_conntrack(struct nf_con
> >  		ct->mark = ntohl(nla_get_be32(cda[CTA_MARK]));
> >  #endif
> >  
> > +#if defined(CONFIG_NF_CONNTRACK_SECMARK)
> > +	if (cda[CTA_SECMARK])
> > +		ct->secmark = ntohl(nla_get_be32(cda[CTA_SECMARK]));
> > +#endif
> > +
> >  #ifdef CONFIG_NF_NAT_NEEDED
> >   if (cda[CTA_NAT_SEQ_ADJ_ORIG] || cda[CTA_NAT_SEQ_ADJ_REPLY]) {
> >    err = ctnetlink_change_nat_seq_adj(ct, cda);
> 
> I'm wondering whether this isn't subverting the intent of
> secmark since AFAIK SELinux doesn't have finegrained
> controls for netlink messages. OTOH, it also doesn't have
> finegrained control over iptables rulesets.
> 
> James, does this patch look OK to you?

There is some fine-grained netlink coverage, but it is incomplete (the 
various generic netlink layers likely need to be consolidated first).

Currently, the SECMARK and CONNSECMARK targets call out to 
selinux_secmark_relabel_packet_permission() when SELinux is active to 
obtain a permission check.  So, detection of the current security model 
would need to be similarly performed.

The bigger issue perhaps is whether there's really a need to set secmark 
via ctnetlink.


- James
-- 
James Morris
<jmorris@namei.org>
