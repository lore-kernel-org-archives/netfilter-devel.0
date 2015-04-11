From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 00/14] netfilter: nf_tables: concatenation support
Date: Sat, 11 Apr 2015 15:47:25 +0200
Message-ID: <20150411134725.GA9651@salvia>
References: <1428715659-31358-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51937 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196AbbDKNnM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Apr 2015 09:43:12 -0400
Content-Disposition: inline
In-Reply-To: <1428715659-31358-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Apr 11, 2015 at 02:27:25AM +0100, Patrick McHardy wrote:
> The following patches add support for concatenations, which allow multi
> dimensional exact matches in O(1).

Thanks Patrick. I think it would be good to get userspace in sync with
what we already have in mainstream. This is going to get way to far
from what we have in master.
