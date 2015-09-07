From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Mixed IPv4+IPv6 sets
Date: Mon, 7 Sep 2015 20:50:25 +0200
Message-ID: <20150907185025.GB17921@salvia>
References: <55EC8B7F.4040303@gaast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Wilmer van der Gaast <wilmer@gaast.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59953 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbbIGSnz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Sep 2015 14:43:55 -0400
Content-Disposition: inline
In-Reply-To: <55EC8B7F.4040303@gaast.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 06, 2015 at 07:52:47PM +0100, Wilmer van der Gaast wrote:
> Hello,
> 
> The "inet" family is a great idea for unifying IPv4 and IPv6
> firewalling, but I just ran into one thing I'm missing.
> 
> nft lets me define sets with both IPv4 and IPv6 addresses, but once
> I try using them things go wrong - I assume this means that the
> addresses aren't actually parsed until that point?
> 
> I can invoke the set from an ip match, and it will complain about
> IPv6 addresses in the list being invalid. And vice versa, invoke the
> set from an "ip6" match and the IPv4 addresses will cause parse
> errors.
> 
> Would it be possible to either have an "inet" match rule, or tell
> nft to skip unknown address families so I could just invoke the set
> twice, once using "ip" and once using "ip6" match rule, without
> running into syntax errors?
> 
> I could of course just define two separate sets to get something
> similar to my alternative idea, and maybe I'll try that, but it gets
> kludgier that way. :-(

Could you illustrate with examples what you would like to have and the
limitations you currently hitting?

Thanks.
