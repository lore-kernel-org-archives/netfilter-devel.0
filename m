From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/5] netfilter: nf_tables: Add meta expression key for
 bridge interface name
Date: Thu, 24 Apr 2014 10:38:43 +0200
Message-ID: <20140424083843.GA4228@localhost>
References: <1397479290-6967-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1397479290-6967-4-git-send-email-tomasz.bursztyka@linux.intel.com>
 <20140423120325.GA7799@localhost>
 <5358AA7A.7030104@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35492 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbaDXIj2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:39:28 -0400
Content-Disposition: inline
In-Reply-To: <5358AA7A.7030104@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 24, 2014 at 09:08:58AM +0300, Tomasz Bursztyka wrote:
> Hi Pablo,
> 
> >I'm going to rename
> >NFT_META_BRI_IIFNAME to NFT_META_IBRIPORT,
> 
> As you want. I took the name proposed by Patrick here, and since it's an API
> there is less concerns about having a really short human-writable name as
> for the nftables tool.

Right, I just found that email. I just wanted to make sure everybody
is happy with the current naming approach, so let's leave it as is.

Series applies, thanks Tomasz.
