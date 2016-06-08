From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 libnftnl] Check all strdup
Date: Wed, 8 Jun 2016 13:46:09 +0200
Message-ID: <20160608114609.GB2436@salvia>
References: <1464689312-8136-1-git-send-email-carlosfg@riseup.net>
 <20160607150810.GA17951@salvia>
 <20160608110701.GA919@salvia>
 <20160608113741.GA13163@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47491 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbcFHLqo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2016 07:46:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 57E411BFAB0
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jun 2016 13:46:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8ADA9358E
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jun 2016 13:46:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B86776448D
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jun 2016 13:46:36 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160608113741.GA13163@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 08, 2016 at 01:37:41PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > +	if (attr > NFTNL_CHAIN_MAX) {
> > +		errno = -EOPNOTSUPP;
> 
> The negation should be dropped.

Right, this should be:

                errno = EOPNOTSUPP;
