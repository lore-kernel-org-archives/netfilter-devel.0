From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 9/9] netfilter: nft_log: complete logging support
Date: Fri, 27 Jun 2014 13:39:14 +0200
Message-ID: <20140627113914.GA25253@localhost>
References: <1403699563-3604-1-git-send-email-pablo@netfilter.org>
 <1403699563-3604-10-git-send-email-pablo@netfilter.org>
 <20140626113730.GA5939@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33022 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288AbaF0LjT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:39:19 -0400
Content-Disposition: inline
In-Reply-To: <20140626113730.GA5939@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 26, 2014 at 01:37:30PM +0200, Patrick McHardy wrote:
> On Wed, Jun 25, 2014 at 02:32:43PM +0200, Pablo Neira Ayuso wrote:
> > +	switch (li->type) {
> > +	case NF_LOG_TYPE_LOG:
> > +		if (tb[NFTA_LOG_SYSLOG] != NULL) {
> > +			li->u.log.level =
> > +				ntohl(nla_get_be32(tb[NFTA_LOG_SYSLOG]));;
> > +		} else {
> > +			li->u.log.level = 4;
> > +		}
> 
> I'd suggest to call it what it is, NFTA_LOG_LEVEL. Besides this minor issue,
> the patches look good to me.

I'm going to locally edit this and push this. Thanks Patrick.
