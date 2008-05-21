From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] masquerading/conntrack
Date: Wed, 21 May 2008 11:53:29 +0200
Message-ID: <4833F119.7080206@netfilter.org>
References: <dd45289d0805210133o49d44292qf238b15fec66a0d2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: NICOLAS BOULIANE <nicboul@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47462 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753729AbYEUJxj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 05:53:39 -0400
In-Reply-To: <dd45289d0805210133o49d44292qf238b15fec66a0d2@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

NICOLAS BOULIANE wrote:
> Since ppp0 always come up first, then these connections begin to flow
> via ppp0 and with the MASQ IP of ppp0...
> 
> Later, when the mangle-rules kick-in, these connections are being
> router via ppp4 (which is what I want)...
> So far no problem..
> 
> 
> The only problem is that these packets now exit via ppp4 but they
> continue to keep the source IP of ppp0
> 
> 
> Ok, I tried to use the userspace conntrack-tool to search and remove
> these entries, but this tool doesn't allow me to do something like this
> 
> $> conntrack -L conntrack -d IP

Check Git, next version (0.9.7) allows it.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
