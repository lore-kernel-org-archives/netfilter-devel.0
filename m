From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 00/17] netfilter: xtables: stricter ruleset validation
Date: Thu, 14 Apr 2016 00:33:34 +0200
Message-ID: <20160413223334.GA3178@salvia>
References: <1459513057-30652-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39306 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbcDMWdu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2016 18:33:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 19AFA4B10A
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 00:33:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 093D0C21A2
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 00:33:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5EF1AC21A8
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 00:33:45 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1459513057-30652-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 01, 2016 at 02:17:20PM +0200, Florian Westphal wrote:
> This series adds more checks on xtables (arp, ip, ip6tables) rulesets.
> 
> - check all offsets (target, next) of all rules during initial pass
>   after copy from userspace.
> - check targets of jumps (-j bla): offset should be start of a rule
> - assert that alleged target size is at least as big as minimum target
>   structure
> - change CONFIG_COMPAT code path to push ruleset via normal setsockopt
>   path after initial 32->64 bit conversion to avoid duplicating checks
> - use a common helper to copy counters from userspace instead of
>   the ip/ip6/arp implementation.
> 
> Tested:
> - iptables.git iptables-test.py passes
> - made a few performance tests w. really silly rulesets to verify
> that things don't slow down too much, see individual patches for details.

Series applied to nf-next, thanks for your patience.
