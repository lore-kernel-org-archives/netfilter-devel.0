From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RESEND PATCH V2] Add element count to hash headers
Date: Fri, 12 Jun 2015 14:34:56 +0200
Message-ID: <20150612123456.GA13973@salvia>
References: <1432913785-22187-1-git-send-email-emunson@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, Josh Hunt <johunt@akamai.com>,
	netfilter-devel@vger.kernel.org
To: Eric B Munson <emunson@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57971 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839AbbFLM3o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Jun 2015 08:29:44 -0400
Content-Disposition: inline
In-Reply-To: <1432913785-22187-1-git-send-email-emunson@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 29, 2015 at 11:36:25AM -0400, Eric B Munson wrote:
> It would be useful for userspace to query the size of an ipset hash,
> however, this data is not exposed to userspace outside of counting the
> number of member entries.  This patch uses the attribute
> IPSET_ATTR_ELEMENTS to indicate the size in the the header that is
> exported to userspace.  This field is then printed by the userspace
> tool for hashes.
> 
> Because it is only meaningful for hashes to report their size, the
> output is conditional on the set type.  To do this checking the
> MATCH_TYPENAME macro was moved to utils.h.
> 
> The bulk of this patch changes the expected test suite to account for
> the change in output.

AFAIK, Jozsef wants to integrate this into ipset once the RCU patchset
for ipset is merged mainstream.
