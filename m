From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCHv3 0/1 lnf-ct] qa: build unshared nfct environment
Date: Tue, 7 Oct 2014 13:38:12 +0900
Message-ID: <20141007043812.GA2507@gmail.com>
References: <20140930090222.GA8470@gmail.com>
 <20140930101656.GE11709@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:49978 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaJGEiT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Oct 2014 00:38:19 -0400
Received: by mail-pd0-f178.google.com with SMTP id y10so4405274pdj.37
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Oct 2014 21:38:19 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140930101656.GE11709@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 30, 2014 at 12:16:56PM +0200, Florian Westphal wrote:
> Seems like this depends on inetd to provide tcp/udp echo services.
> Thats fine, I don't have any objections.

You said so but I added tools existance check.

> Could you please either remove the unused functions or provide some

I removed the unused function and the macro.

And move functions which may be common from ct_echo_event.c to nssocket.c
and from ct_echo_event.sh to nssocket_env.sh for patches I will post later.
Would you review again?

Thanks,
