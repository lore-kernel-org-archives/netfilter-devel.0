From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] extensions: hashlimit: fix incorrect burst in
 translations
Date: Thu, 4 Jan 2018 10:53:28 +0100
Message-ID: <20180104095328.tnu77pzhx5a6avvq@salvia>
References: <20180103144109.8280-1-pablo@netfilter.org>
 <20180103222640.GB3302@dimstar.local.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50594 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752401AbeADJxe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Jan 2018 04:53:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8C47FB6C73
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Jan 2018 10:53:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 79255A595
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Jan 2018 10:53:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1AC612091A
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Jan 2018 10:53:29 +0100 (CET)
Received: from us.es (129.166.216.87.static.jazztel.es [87.216.166.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D61DB425CB91
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Jan 2018 10:53:28 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180103222640.GB3302@dimstar.local.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 04, 2018 at 09:26:40AM +1100, Duncan Roe wrote:
> On Wed, Jan 03, 2018 at 03:41:08PM +0100, Pablo Neira Ayuso wrote:
> > iptables-translate -A INPUT -m tcp -p tcp --dport 80 -m hashlimit --hashlimit-above 200kb/s --hashlimit-burst 1mb --hashlimit-mode srcip,dstport --hashlimit-name http2 --hashlimit-htable-expire 3000 -j DROP
> >
> > shows:
> >
> > nft add rule ip filter INPUT tcp dport 80 flow table http2 { tcp dport . ip saddr timeout 3s limit rate over 200 kbytes/second burst 1 mbytes burst 6 packets} counter drop
> >
> > which prints burst twice, this is not correct.
> >
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  extensions/libxt_hashlimit.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
> > index 472d8e7f6cc2..3fa5719127db 100644
> > --- a/extensions/libxt_hashlimit.c
> > +++ b/extensions/libxt_hashlimit.c
> > @@ -1350,10 +1350,12 @@ static int hashlimit_mt_xlate(struct xt_xlate *xl, const char *name,
> >
> >  	if (cfg->mode & XT_HASHLIMIT_BYTES)
> >  		print_bytes_rate_xlate(xl, cfg);
> > -	else
> > +	else {
> >  		print_packets_rate_xlate(xl, cfg->avg, revision);
> > -	if (cfg->burst != 5)
> > -		xt_xlate_add(xl, " burst %lu packets", cfg->burst);
> > +		if (cfg->burst != XT_HASHLIMIT_BURST)
> > +			xt_xlate_add(xl, " burst %lu packets", cfg->burst);
> > +
> > +	}
> >  	xt_xlate_add(xl, "}");
> >
> >  	return ret;
> > --
> > 2.11.0
> >
> This still discards a timeout of 1s (1000ms):
> 
> > $ iptables-translate -A INPUT -m tcp -p tcp --dport 80 -m hashlimit --hashlimit-above 200kb/s --hashlimit-burst 1mb --hashlimit-mode srcip,dstport --hashlimit-name http2 --hashlimit-htable-expire 1000 -j DROP
> > nft add rule ip filter INPUT tcp dport 80 flow table http2 { tcp dport . ip saddr limit rate over 200 kbytes/second burst 1 mbytes} counter drop
> 
> This is especially incorrect, since the code deliberately inserts a default
> timeout of 1m if no timeout was specified with a burst:
> 
> > $ iptables-translate -A INPUT -m tcp -p tcp --dport 80 -m hashlimit --hashlimit-above 200kb/s --hashlimit-burst 1mb --hashlimit-mode srcip,dstport --hashlimit-name http2 -j DROP
> > nft add rule ip filter INPUT tcp dport 80 flow table http2 { tcp dport . ip saddr timeout 60s limit rate over 200 kbytes/second burst 1 mbytes} counter drop
> 
> The patch I suggested doesn't have that problem, because of forcing defaults to
> zero. Can doing that have any adverse side-effects?

Yes. Problem is that we cannot assume that hashlimit_mt_check() is
called. If you compile nftables with --with-xtables, listing of rules
that are added via iptables-compat will be translated to nftables.
