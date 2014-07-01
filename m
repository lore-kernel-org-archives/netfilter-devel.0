From: Quentin Headen <qheaden@phaseshiftsoftware.com>
Subject: Re: Starting point in netfilter development
Date: Mon, 30 Jun 2014 21:45:30 -0400
Message-ID: <CAFgy_YJ8wdPm6P2M_bPVXqbHzJ6oQxWT-3DmfQpikqPma=SDAA@mail.gmail.com>
References: <CAFgy_YLvGwc3y3R3vv0hdTPsQ+yX7eUW8YUppef9xJQsdH9frw@mail.gmail.com>
	<20140630152245.GC9515@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:55727 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaGABpc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2014 21:45:32 -0400
Received: by mail-la0-f49.google.com with SMTP id gf5so5286935lab.8
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Jun 2014 18:45:31 -0700 (PDT)
In-Reply-To: <20140630152245.GC9515@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Florian Westphal <fw@strlen.de> wrote:
> nftables is currently under active development; f.e. you could
> add one of the missing iptables extensions such as hashlimit
> or nfacct.

Working on hashlimit for nftables sounds interesting.

> nf.git and nf-next.git from kernel.org. git.netfilter.org
> mostly hosts the userspace tools like iptables/nftables
> and the associated libraries.

So to work on hashlimit functionality for nftables, I'm guessing I
would need to work with the code found on git.netfilter.org? Would it
be mostly a userspace coding experience?
