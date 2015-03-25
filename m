From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/5] netfilter: nf_tables: move struct net pointer to
 base chain
Date: Wed, 25 Mar 2015 12:13:23 +0100
Message-ID: <20150325111323.GA6457@salvia>
References: <1426951158-18168-1-git-send-email-kaber@trash.net>
 <1426951158-18168-3-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48039 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbbCYLJc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 07:09:32 -0400
Content-Disposition: inline
In-Reply-To: <1426951158-18168-3-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 21, 2015 at 03:19:15PM +0000, Patrick McHardy wrote:
> The network namespace is only needed for base chains to get at the
> gencursor. Also convert to possible_net_t.

Applied, thanks Patrick.
