From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: use printf() instead of pr_debug() whenever
 possible
Date: Thu, 8 Jan 2015 13:31:30 +0100
Message-ID: <20150108123130.GA29909@salvia>
References: <1420719226-5475-1-git-send-email-pablo@netfilter.org>
 <20150108122146.GK13765@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49799 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039AbbAHM2m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Jan 2015 07:28:42 -0500
Content-Disposition: inline
In-Reply-To: <20150108122146.GK13765@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 08, 2015 at 12:21:47PM +0000, Patrick McHardy wrote:
> I'd rather change pr_debug to a normal printf and adapt segtree to
> use a pr_gmp_debug or something like that.

Good idea, patch will follow up soon. Thanks Patrick.
