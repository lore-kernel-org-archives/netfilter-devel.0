From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 03/22] netfilter: Replace strnicmp with strncasecmp
Date: Wed, 17 Sep 2014 15:02:09 +0200
Message-ID: <20140917130209.GA4662@salvia>
References: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
 <1410900696-6481-4-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33583 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831AbaIQNBJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Sep 2014 09:01:09 -0400
Content-Disposition: inline
In-Reply-To: <1410900696-6481-4-git-send-email-linux@rasmusvillemoes.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 16, 2014 at 10:51:17PM +0200, Rasmus Villemoes wrote:
> The kernel used to contain two functions for length-delimited,
> case-insensitive string comparison, strnicmp with correct semantics
> and a slightly buggy strncasecmp. The latter is the POSIX name, so
> strnicmp was renamed to strncasecmp, and strnicmp made into a wrapper
> for the new strncasecmp to avoid breaking existing users.
> 
> To allow the compat wrapper strnicmp to be removed at some point in
> the future, and to avoid the extra indirection cost, do
> s/strnicmp/strncasecmp/g.

I don't manage to find the strnicmp wrapper patch:

http://thread.gmane.org/gmane.linux.kernel/1775150/focus=1775152

perhaps I'm looking at the wrong tree? Please clarify. Thanks.

