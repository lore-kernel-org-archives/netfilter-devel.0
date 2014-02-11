From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables (nft-compat) PATCH 5/8] nft: Fix error message to
 output proper origin
Date: Tue, 11 Feb 2014 12:05:12 +0100
Message-ID: <20140211110512.GC4299@localhost>
References: <1392115608-6733-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1392115608-6733-6-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58784 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbaBKLFV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Feb 2014 06:05:21 -0500
Content-Disposition: inline
In-Reply-To: <1392115608-6733-6-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 11, 2014 at 12:46:45PM +0200, Tomasz Bursztyka wrote:
> So it prints "mnl_talk:__nft_chain_set" instead of
> "mnl_talk:__nft_chain_policy".

I think this is a good chance to silence / remove all these debugging
messages that were added in the very early initial stage.
