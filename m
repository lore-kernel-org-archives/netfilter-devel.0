From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: conntrack: don't acquire lock during
 seq_printf
Date: Thu, 14 Apr 2016 14:27:59 +0200
Message-ID: <20160414122759.GA11700@salvia>
References: <1460402069-22101-1-git-send-email-fw@strlen.de>
 <20160414094346.GA2056@salvia>
 <20160414100542.GA2644@salvia>
 <20160414111656.GC3192@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38304 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749AbcDNM2K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Apr 2016 08:28:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 383DBE6648
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 14:28:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2454BC21A2
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 14:28:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 901FB9D0E5
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 14:28:01 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160414111656.GC3192@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 14, 2016 at 01:16:56PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >  net/netfilter/nf_conntrack_proto_sctp.c | 8 +-------
> > >  net/netfilter/nf_conntrack_proto_tcp.c  | 8 +-------
> > >  2 files changed, 2 insertions(+), 14 deletions(-)
> > > 
> > > diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
> > > index 9578a7c..1d7ab96 100644
> > > --- a/net/netfilter/nf_conntrack_proto_sctp.c
> > > +++ b/net/netfilter/nf_conntrack_proto_sctp.c
> > > @@ -191,13 +191,7 @@ static void sctp_print_tuple(struct seq_file *s,
> > >  /* Print out the private part of the conntrack. */
> > >  static void sctp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
> > >  {
> > > -	enum sctp_conntrack state;
> > > -
> > > -	spin_lock_bh(&ct->lock);
> > > -	state = ct->proto.sctp.state;
> > 
> > Don't we need at least READ_ONCE() here?
> 
> Why?
> 
> seq_printf(s, "%s ", sctp_conntrack_names[ct->proto.sctp.state]);
> 
> I think thats fine, where do you see a problem?

ct->proto.sctp.state may be modified from another cpu while reading
this, is this read guaranteed to be atomic in any arch?
