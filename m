From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: conntrack: don't acquire lock during
 seq_printf
Date: Thu, 14 Apr 2016 12:05:42 +0200
Message-ID: <20160414100542.GA2644@salvia>
References: <1460402069-22101-1-git-send-email-fw@strlen.de>
 <20160414094346.GA2056@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36261 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbcDNKFr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Apr 2016 06:05:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E9BC21373AC
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 12:05:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D90119D0F3
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 12:05:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 291DD9D0F7
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 12:05:43 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160414094346.GA2056@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 11, 2016 at 09:14:29PM +0200, Florian Westphal wrote:
> read access doesn't need any lock here.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nf_conntrack_proto_sctp.c | 8 +-------
>  net/netfilter/nf_conntrack_proto_tcp.c  | 8 +-------
>  2 files changed, 2 insertions(+), 14 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
> index 9578a7c..1d7ab96 100644
> --- a/net/netfilter/nf_conntrack_proto_sctp.c
> +++ b/net/netfilter/nf_conntrack_proto_sctp.c
> @@ -191,13 +191,7 @@ static void sctp_print_tuple(struct seq_file *s,
>  /* Print out the private part of the conntrack. */
>  static void sctp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
>  {
> -	enum sctp_conntrack state;
> -
> -	spin_lock_bh(&ct->lock);
> -	state = ct->proto.sctp.state;

Don't we need at least READ_ONCE() here?

> -	spin_unlock_bh(&ct->lock);
> -
> -	seq_printf(s, "%s ", sctp_conntrack_names[state]);
> +	seq_printf(s, "%s ", sctp_conntrack_names[ct->proto.sctp.state]);
>  }
>  
>  #define for_each_sctp_chunk(skb, sch, _sch, offset, dataoff, count)	\
