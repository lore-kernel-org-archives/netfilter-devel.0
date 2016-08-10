From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/4, V3, libnftnl] rule: Implement internal expression
 iterator
Date: Wed, 10 Aug 2016 14:08:10 +0200
Message-ID: <20160810120810.GA10248@salvia>
References: <20160808144834.GB6264@salvia>
 <20160810094857.14227-1-carlosfg@riseup.net>
 <20160810114140.GA9639@salvia>
 <d506f397-8795-4966-6408-c7d3caa4b082@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47772 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbcHJSFM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 14:05:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E56291878AE
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 14:08:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D3623FC61C
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 14:08:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C5A97FF6F8
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 14:08:11 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <d506f397-8795-4966-6408-c7d3caa4b082@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 10, 2016 at 01:56:32PM +0200, Carlos Falgueras García wrote:
> On 08/10/2016 01:41 PM, Pablo Neira Ayuso wrote:
> >>@@ -1025,10 +1033,16 @@ int nftnl_expr_foreach(struct nftnl_rule *r,
> >> }
> >> EXPORT_SYMBOL_ALIAS(nftnl_expr_foreach, nft_rule_expr_foreach);
> >>
> >>-struct nftnl_expr_iter {
> >>-	const struct nftnl_rule	*r;
> >>-	struct nftnl_expr	*cur;
> >>-};
> >
> >I have kept this structure definition here, we don't have to scroll up
> >and down to get the context when looking at the iterators code.
> >
> >After my change, the patch looks even smaller.
> 
> But we will need it at the next patch, so I will include these changes in
> the patch : 2/4 - "Implement rule comparison". It is ok?

You can place nftnl_rule_cmp() after the iterators, so you don't need
this forward declaration.
