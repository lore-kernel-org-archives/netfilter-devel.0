From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 3/3] netfilter: nft_log: fix snaplen does not
 truncate packets
Date: Wed, 20 Jul 2016 11:07:34 +0200
Message-ID: <20160720090734.GA5619@salvia>
References: <1468845857-30291-1-git-send-email-zlpnobody@163.com>
 <1468845857-30291-4-git-send-email-zlpnobody@163.com>
 <20160719181600.GD6116@salvia>
 <60a932e7.d60.15605635cca.Coremail.zlpnobody@163.com>
 <20160720082521.GA1336@salvia>
 <CAML_gOd8bYutiMoqAD74vpUh5vGYLWPNN-7Hoz3aAFL7-K6rXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@163.com>, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36061 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902AbcGTJHk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jul 2016 05:07:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D8C1C1B6944
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2016 11:07:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A7AC0FAB5B
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2016 11:07:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8D6FAFF148
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2016 11:07:35 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAML_gOd8bYutiMoqAD74vpUh5vGYLWPNN-7Hoz3aAFL7-K6rXw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 20, 2016 at 05:00:45PM +0800, Liping Zhang wrote:
> Hi Pablo,
> 
> 2016-07-20 16:25 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> > On Wed, Jul 20, 2016 at 07:00:13AM +0800, Liping Zhang wrote:
> >> I find that nftables already support this feature, the following command mean to truncate packets
> >> to 100 bytes before logging to the userspace:
> >>   #nft add rule filter input log group 0 snaplen 100
> >>
> >> Before my patch, it does not work.
> >> And after apply my patch, it works as expected.
> >
> > If I git grep NF_LOG_F_COPY_LEN from the nftables.git tree, I don't
> > see any reference to this flag being set.
> >
> 
> I use this NF_LOG_F_COPY_LEN flag as internal, and when the user specify
> the NFTA_LOG_SNAPLEN attrribute, it will be enabled automatically.
> See my codes:
> 
>                if (tb[NFTA_LOG_SNAPLEN] != NULL) {
> +                       li->u.ulog.flags |= NF_LOG_F_COPY_LEN;
> 
> -               if (li->u.ulog.copy_len) {
> +               if (li->u.ulog.flags & NF_LOG_F_COPY_LEN) {
>                          if (nla_put_be32(skb, NFTA_LOG_SNAPLEN,
>                                          htonl(li->u.ulog.copy_len)))
> 
> So this flag will not be setted from userspace explicitly and will not
> be dumped to the userspace.

That's fine the way it is then. Thanks for clarifying this.

> > Then, nft_log kernel has been actually working fine since the
> > beginning. It would be good anyway if we set this flag on from
> > userspace to leave things in consistent state.
> 
> Do you mean this is something similar to "nflog-size" and
> "nflog-range" in xt_NFLOG?
> "nft log snaplen 100" cannot work since the beginning, so we should
> keep it unchanged? And
> maybe we should introduce a new option like "nft log snapsize 100"?

In the particular case of nftables, given we're still below the 1.0
stage, we can just classify this as a bugfix, I wouldn't bother much
on this.

The only thing to care is to provide the right translation of
nflog-size to snaplen and you actually contributed this patch already,
so everything is fine :).
