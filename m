From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] parser: compact list of rhs keyword expressions
Date: Mon, 1 Aug 2016 14:57:29 +0200
Message-ID: <20160801125729.GA15004@salvia>
References: <1469636296-4452-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57397 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700AbcHAM5j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Aug 2016 08:57:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D2ECB16839B
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2016 14:57:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BF7E6ADF3
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2016 14:57:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9AE15FAB4F
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2016 14:57:34 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1469636296-4452-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 27, 2016 at 06:18:16PM +0200, Florian Westphal wrote:
> Condenses the copy/pastry via a define, will make it less of a hassle
> to extend this list later if needed.

So the main goal of this is to find a solution for meta skuid, ct
label and such that allow any arbitrary string as value.

I continued a patch on top of this to place in the keyword_expr rule
the remaining keywords and return a symbol expression here.

I didn't finish this, but still MAP and SET tokens cannot be used from
there as they are valid to show after the selectors (bison detects
this by complaining on shift/reduce conflicts), so still the user
cannot create a gid whose name is 'map'.

Another possibility to display this values using quotes, so the
scanner always handles them as arbitrary values.  So the syntax looks
like:

        meta skuid "daemon"

or
        ct label "http"

>From a user side, it would be also visible that these are an arbitrary
user-defined string.
