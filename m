From: =?UTF-8?B?QWxpbiBOxINzdGFj?= <alin.nastac@gmail.com>
Subject: Re: [helper PATCH] Preserve conntrack helper bound through CT rule
Date: Wed, 26 Mar 2014 21:59:39 +0100
Message-ID: <CAF1oqRAg6K56H13djDEWugPV5i0Vu2K8wAM7V=nWPuGxkOL+dw@mail.gmail.com>
References: <CAF1oqRC4LDjjq2X1EjRSJr0g0oQk45UMZBviLz0mziTwM8WbRQ@mail.gmail.com>
	<20140326130445.GD21741@breakpoint.cc>
	<CAF1oqRAg8Xi+JwL_ErzuwF1TFWHCMcV6pGasUfFQ5_RaDNMBOQ@mail.gmail.com>
	<20140326165747.GE21741@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:58647 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbaCZU7k (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2014 16:59:40 -0400
Received: by mail-lb0-f179.google.com with SMTP id p9so1963786lbv.10
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2014 13:59:39 -0700 (PDT)
In-Reply-To: <20140326165747.GE21741@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 26, 2014 at 5:57 PM, Florian Westphal <fw@strlen.de> wrote:
> I guess this was fixed by
> commit 6714cf5465d2803a21c6a46c1ea747795a8889fa
> 'netfilter: nf_conntrack: fix explicit helper attachment and NAT').
> in 3.5 kernel.

You're right, this issue was already fixed.
Sorry for the hassle.
