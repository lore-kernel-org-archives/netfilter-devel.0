From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH v3] xtables: Add locking to prevent concurrent instances
Date: Wed, 29 May 2013 14:23:33 -0400
Message-ID: <20130529182333.GA5056@gmail.com>
References: <20130527162311.GA1366@gmail.com>
 <20130529125903.GA6390@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qa0-f51.google.com ([209.85.216.51]:60650 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965582Ab3E2SYC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 May 2013 14:24:02 -0400
Received: by mail-qa0-f51.google.com with SMTP id i13so530555qae.10
        for <netfilter-devel@vger.kernel.org>; Wed, 29 May 2013 11:24:01 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130529125903.GA6390@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 29, 2013 at 02:59:03PM +0200, Pablo Neira Ayuso wrote:
> I think we can:
> 
> * Add a new option to explicitly request this behaviour, just as a way
>   to assert that you really want iptables to retry. Harald was rising
>   some concerns on the expected results in case of clash that sound
>   reasonable to me.

I agree that the retry behaviour could be made optional, however
I'm not sure that the locking behaviour should be optional.  It leads
to various races, some of which are subtle and can occur during if-up
and other "behind the scenes" scenarios.  In my personal experience,
I had to implement locking inside my scripts because I was hitting
races fairly regularly with dynamic rule additions/deletions (and I
suspect other admins have done the same).  Perhaps we can change the
error to say:

"Another app is currently holding the ip[6]tables lock (use -r option to enable retries)"

or something similar?  At least that is more informative than the typical
race error of "iptables: Resource temporarily unavailable".

> * Limit this to ip[6]tables. All bug reports refer to it.

Seems reasonable.  If future races are discovered in -save or -restore,
it could be easily changed.

Phil
