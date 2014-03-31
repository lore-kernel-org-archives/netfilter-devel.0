From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/2] netfilter: nf_tables: set selection
Date: Mon, 31 Mar 2014 13:53:33 +0200
Message-ID: <20140331115333.GA3623@localhost>
References: <1396001988-32338-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56184 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbaCaLxi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Mar 2014 07:53:38 -0400
Content-Disposition: inline
In-Reply-To: <1396001988-32338-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 28, 2014 at 10:19:46AM +0000, Patrick McHardy wrote:
> These patches implement the basic set selection mechanism based on data
> characteristics provided by userspace. So far we only need to know the
> maximum number of elements.
> 
> Instead of trying to anticipate the information future set types will
> need, the plan is to add more as we require it under the assumption
> that we will converge to a state where a new set type already has
> all information required available. The expectation is that most set
> types will require the same information for estimation since they
> most likely will be some type of tree or trie.

I'm going to include this in the next batch for net-next before merge
window closes, which should happen soon. Thanks a lot Patrick.
