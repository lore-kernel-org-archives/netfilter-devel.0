From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: support per element userdata
Date: Wed, 8 Apr 2015 19:00:32 +0200
Message-ID: <20150408170032.GA6853@salvia>
References: <1428237818-31963-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47735 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbbDHQ4W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Apr 2015 12:56:22 -0400
Content-Disposition: inline
In-Reply-To: <1428237818-31963-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Apr 05, 2015 at 02:43:37PM +0200, Patrick McHardy wrote:
> This patch adds support for attaching arbitrary userdata to set elements,
> such as comments, DNS information etc. The type of information is determined
> by userspace.
> 
> This is the last patch related to sets for the time being, the next
> series will add support for concatenations, before finally adding
> stateful expression support to sets.

Applied, thanks.
