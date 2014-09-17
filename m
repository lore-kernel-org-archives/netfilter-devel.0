From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH 03/22] netfilter: Replace strnicmp with strncasecmp
Date: Wed, 17 Sep 2014 15:16:24 +0200
Message-ID: <874mw6idzr.fsf@rasmusvillemoes.dk>
References: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
	<1410900696-6481-4-git-send-email-linux@rasmusvillemoes.dk>
	<20140917130209.GA4662@salvia>
Mime-Version: 1.0
Content-Type: text/plain
Cc: netfilter-devel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:51917 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbaIQNQ1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Sep 2014 09:16:27 -0400
Received: by mail-la0-f44.google.com with SMTP id q1so641451lam.17
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Sep 2014 06:16:25 -0700 (PDT)
In-Reply-To: <20140917130209.GA4662@salvia> (Pablo Neira Ayuso's message of
	"Wed, 17 Sep 2014 15:02:09 +0200")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 17 2014, Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Tue, Sep 16, 2014 at 10:51:17PM +0200, Rasmus Villemoes wrote:
>> The kernel used to contain two functions for length-delimited,
>> case-insensitive string comparison, strnicmp with correct semantics
>> and a slightly buggy strncasecmp. The latter is the POSIX name, so
>> strnicmp was renamed to strncasecmp, and strnicmp made into a wrapper
>> for the new strncasecmp to avoid breaking existing users.
>> 
>> To allow the compat wrapper strnicmp to be removed at some point in
>> the future, and to avoid the extra indirection cost, do
>> s/strnicmp/strncasecmp/g.
>
> I don't manage to find the strnicmp wrapper patch:
>
> http://thread.gmane.org/gmane.linux.kernel/1775150/focus=1775152
>
> perhaps I'm looking at the wrong tree? Please clarify. Thanks.

It's in mmots,
<http://git.cmpxchg.org/cgit.cgi/linux-mmots.git/commit/?id=7acc5207bcc2fbf0929bd3ee14c414b9defa3382>.
I thought it had made it to linux-next, but failed to check that. Andrew
said he'd take that patch as well as the treewide follow-up patches, to
ensure they'd be applied in the right order.

Sorry for the confusion,
Rasmus
