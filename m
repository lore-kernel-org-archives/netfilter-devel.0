From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables PATCH 0/5] Centralizes rule parsing
Date: Tue, 20 Aug 2013 20:58:13 +0200
Message-ID: <20130820185813.GA11790@localhost>
References: <1376913846-15996-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55073 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270Ab3HTS6X (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Aug 2013 14:58:23 -0400
Content-Disposition: inline
In-Reply-To: <1376913846-15996-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 19, 2013 at 03:04:01PM +0300, Tomasz Bursztyka wrote:
> Hi,
> 
> Here are the patches that refactors how rules are parsed. So now it's done in one unique place for all operations.
> 
> And it adds a function to reset the counters with -Z since it's trivial to do so with such parsing strategy.
> 
> Tomasz Bursztyka (5):
>   nft: Parse fully and properly at once a rule into a cs
>   nft: Refactor firewall printing so it reuses already parsed cs struct
>   nft: Refactor rule deletion so it compares both cs structure
>   xtables: nft: Complete refactoring on how rules are saved

I have collapsed these four patches in one single, we need that the
repository remains consistent between patches, that includes that new
functions need to have a client in the same patch.

The patch that I applied includes several things that I manually
fixed.

* IPv6 address printing was not working.
* Remove -4/-6 from the xtables-save output, we need exactly the same
  output like iptables-save. It is only shown in xtables-events.
* Fix match/target aliasing, this one was not so obvious, as it's a
  relatively new thing.
* Some coding style issue, this is prefered:

        function(a, b, c, d,
                 e, f, g);

rather than:

        function(a, b, c, d,
                        e, f, g);

I like that we saved 300 LOC with this. I have also applied one patch
to fix the wrong interpretation of the flags with IPv6.

>   nft: Add a function to reset the counters of an existing rule

Also applied this one.

Thanks.
