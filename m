From: Kelvie Wong <kelvie@ieee.org>
Subject: Re: Having expectations live past the master connection's lifetime
Date: Tue, 12 Jun 2012 11:04:53 -0700
Message-ID: <CAK2bC5oaEECgm7SRv7aiL9Lj3V9LgFQN1xtg=Em+pLfwnk6ipw@mail.gmail.com>
References: <CAK2bC5qkHXMzSQg6v6DNb0ou7KWj+sTXibyLv=53zxe236M9pw@mail.gmail.com>
	<20120612175656.GA32542@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38095 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab2FLSEz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jun 2012 14:04:55 -0400
Received: by bkcji2 with SMTP id ji2so4758828bkc.19
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Jun 2012 11:04:54 -0700 (PDT)
In-Reply-To: <20120612175656.GA32542@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 12, 2012 at 10:56 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> We can skip removing these expectations by setting some flag in the
> expectation. Still, we'll have to insert those expectations in some
> list so we make sure that they are removed on module removal.

Ah, I see. I think it would be easier to just insert an iptables rule
for what I want.

> Another problem is that I cannot take that kernel patch if there's no
> publicitly available Netfilter code using it.

That needn't be a problem, as I could probably add something, but I
think I'll just use iptables for this purpose.

Thanks for the reply, though.
-- 
Kelvie Wong
