From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC ulogd patch 0/1] Implement conntrack event filter in NFCT
 input
Date: Thu, 2 Aug 2012 13:23:44 +0200
Message-ID: <20120802112344.GB25007@1984>
References: <1343856809-11585-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55752 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360Ab2HBLXv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Aug 2012 07:23:51 -0400
Content-Disposition: inline
In-Reply-To: <1343856809-11585-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 01, 2012 at 11:33:28PM +0200, Eric Leblond wrote:
> 
> Hello,
> 
> This patch implements filtering for NFCT input plugin. It adds
> two configuration variables src_filter and dst_filter which
> can be used to select the IPv4 or IPv6 network to filter on
> for the source or destination address.
> 
> For IPv4 this is working fine but despite the latest update
> from Pablo on libnetfilter_conntrack, I still don't manage
> to get IPv6 working. Any help appreciated on this.

Note that ulogd2 initially dumps the entire table. The filtering will
not apply to dumping, only to events.

You need to filter filter dumps.

conntrackd already has a framework for user-space filtering, that is
used for filter. You can grab it. We can probably later move it to
libnetfilter_conntrack to avoid code redundancy.
