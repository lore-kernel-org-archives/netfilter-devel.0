From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] conntrack: favor multiple -l options over -l foo,bar
Date: Tue, 3 Sep 2013 23:11:18 +0200
Message-ID: <20130903211118.GA4254@localhost>
References: <1378222122-29415-1-git-send-email-fw@strlen.de>
 <1378222122-29415-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52436 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761139Ab3ICVLX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Sep 2013 17:11:23 -0400
Content-Disposition: inline
In-Reply-To: <1378222122-29415-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 03, 2013 at 05:28:41PM +0200, Florian Westphal wrote:
> Its more straightforward to use -l foo -l bar when only wanting
> to see conntracks that have both labels set.
> 
> It also simplifies things a lot.

We need to keep the old syntax, 1.4.2 already supports -l foo,bar so
we cannot delete it.
