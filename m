From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/4] netfilter: nf_log: handle NFPROTO_INET
 properly in nf_logger_[find_get|put]
Date: Thu, 23 Jun 2016 13:23:54 +0200
Message-ID: <20160623112354.GB2695@salvia>
References: <1465389800-27842-1-git-send-email-zlpnobody@163.com>
 <1465389800-27842-2-git-send-email-zlpnobody@163.com>
 <20160623112205.GA2873@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60402 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbcFWLYH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 07:24:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 07D4217474F
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 13:24:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D3A49FAB4E
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 13:24:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 83FA0FAB46
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 13:24:03 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160623112205.GA2873@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 23, 2016 at 01:22:05PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Jun 08, 2016 at 08:43:17PM +0800, Liping Zhang wrote:
> > From: Liping Zhang <liping.zhang@spreadtrum.com>
> > 
> > When we request NFPROTO_INET, it means both NFPROTO_IPV4 and NFPROTO_IPV6.
> >
> > Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
> > ---
> >  net/netfilter/nf_log.c | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> > 
> > diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
> > index a5d41df..73b845d 100644
> > --- a/net/netfilter/nf_log.c
> > +++ b/net/netfilter/nf_log.c
> > @@ -159,6 +159,20 @@ int nf_logger_find_get(int pf, enum nf_log_type type)
> >  	struct nf_logger *logger;
> >  	int ret = -ENOENT;
> >  
> > +	if (pf == NFPROTO_INET) {
> > +		ret = nf_logger_find_get(NFPROTO_IPV4, type);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		ret = nf_logger_find_get(NFPROTO_IPV6, type);
> > +		if (ret < 0) {
> > +			nf_logger_put(NFPROTO_IPV4, type);
> > +			return ret;
> > +		}
> > +
> > +		return 0;
> 
> This is already done from nft_log_init().
> 
> Are you observing any problem there?

Oh, I see, you get rid of that code in your follow up patch.

I'm going to merge 1/4 and 2/4, this change should be introduced in
one go as they are part of the same logical change.

No need to resend. Thanks.
