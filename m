From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH V2] netfilter: ctnetlink: force null nat binding on insert
Date: Mon, 17 Feb 2014 12:15:19 +0100
Message-ID: <20140217111519.GC31125@breakpoint.cc>
References: <1392549343-7145-1-git-send-email-fw@strlen.de>
 <20140217103750.GA22363@localhost>
 <20140217104511.GB31125@breakpoint.cc>
 <20140217105856.GA16361@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:47823 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750982AbaBQLPV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 06:15:21 -0500
Content-Disposition: inline
In-Reply-To: <20140217105856.GA16361@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > I think we should always do the module autoloading for nf-nat and
> > > nf-nat-ipvX modules depending on nf_ct_l3num(ct), then return EAGAIN
> > > to give another retry. Now, this needs to happen in any case, not only
> > > when calling ctnetlink_parse_nat_setup().
> >
> > Not sure what you mean.  If we enter nf_nat_setup_info without ctnetlink
> > involvement the nf-nat protocol should already be there (else, how can
> > we end up in nf_nat_setup_info? NAT/MASQUERADE depends on nf-nat).
> >
> > What use-case did you have in mind? (or, to put it differently, where
> > do you think the module probing logic should be)?
> 
> If __nf_nat_l3proto_find returns NULL before trying to attach the null
> binding, I think you should call the routine to autoload the modules
> before returning EAGAIN.
> 
>         proto = __nf_nat_l3proto_find(nf_ct_l3num(ct));
>         if (proto == NULL) {
>                 ... release locks
>                 request_module(...);
>                 ... acquire locks again
>                 return -EAGAIN;
>         }

The patch alters ctnetlink to call ctnetlink_parse_nat_setup even when
NAT attr == NULL.

nfnetlink_attach_null_binding() returns EAGAIN; this return value is
propagated back to ctnetlink_parse_nat_setup.

That will then request_module(), nfnetlink will replay the message.

running
conntrack -I -p tcp -s 1.1.1.1 -d 2.2.2.2 --timeout 100 --state \
	ESTABLISHED --sport 10 --dport 20
on newly booted machine works, lsmod pre/post
shows:
+nf_conntrack_ipv4      14808  1 
+nf_defrag_ipv4         12702  1 nf_conntrack_ipv4
+nf_nat_ipv4            13199  0 
+nf_nat                 20926  1 nf_nat_ipv4

Which is the desired behaviour afaiu.

[ If you think calling ctnetlink_parse_nat_setup with NULL attr
  is abuse, please let me know and I will try to come up with something
  different ]
