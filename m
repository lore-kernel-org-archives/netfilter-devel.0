From: Chris Wright <chrisw@sous-sol.org>
Subject: Re: [stable] [NETFILTER -stable 00/03]: Netfilter 2.6.24 -stable
	fixes
Date: Tue, 18 Mar 2008 15:25:10 -0700
Message-ID: <20080318222510.GN4416@sequoia.sous-sol.org>
References: <20080317143311.20525.87504.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@kernel.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:49835 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933839AbYCSUdd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:33:33 -0400
Content-Disposition: inline
In-Reply-To: <20080317143311.20525.87504.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* Patrick McHardy (kaber@trash.net) wrote:
> These patches fix a problem in the time match, causing it to never
> match on Sunday, and undersized skb allocation in nfnetlink_log
> and nfnetlink_queue, causing lost messages.
> 
> Please apply, thanks.

Applied, I updated the From: for each patch, please correct me if it's
wrong.

thanks,
-chris
