From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 6/5] netfilter: nft_dynset: make sure expr extension
 exists before using it
Date: Mon, 13 Apr 2015 20:54:44 +0200
Message-ID: <20150413185444.GA3276@salvia>
References: <1428745602-31799-1-git-send-email-kaber@trash.net>
 <20150412202651.GG4568@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35482 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbbDMSua (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Apr 2015 14:50:30 -0400
Content-Disposition: inline
In-Reply-To: <20150412202651.GG4568@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Apr 12, 2015 at 09:26:55PM +0100, Patrick McHardy wrote:
> This patch fixes a bug in patch 5/5 (netfilter: nft_dynset: dynamic
> stateful expression instantiation), we need to make sure the expr
> extension exists without using it to avoid a crash with normal
> set updates.
> 
> If possible, please simply fold it into 5/5.

I have fold this into into 5/5. Thanks.
