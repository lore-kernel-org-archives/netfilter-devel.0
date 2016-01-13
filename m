From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3 nft] tests/py: don't test log statement from protocol
 match
Date: Wed, 13 Jan 2016 12:07:53 +0100
Message-ID: <20160113110753.GD1195@salvia>
References: <1452638438-19193-1-git-send-email-pablo@netfilter.org>
 <20160113101336.GA27674@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56317 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbcAMLH7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2016 06:07:59 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0A7D93780A3
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2016 12:07:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E685DDA87C
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2016 12:07:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 331F7DA865
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2016 12:07:54 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160113101336.GA27674@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 13, 2016 at 11:13:36AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [ zap log rules from family matches ]
> 
> I assume thats because you deem tests/py/any/log.t
> sufficient?

I think this unit tests should be self-contained at some level. The
shell/ directory should be used to catch regressions at ruleset level,
ie. these kind of combinations.

Another motivation is that I want that netdev/ingress gets tested, and
we don't support log there yet, so I would need to skip this test for
that case.

> When you push it can you add one-liner summary in this direction?

I'm going to include this information above. Let me know if you have
any other concern, thanks Florian.
