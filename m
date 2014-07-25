From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/7] patches for an autotooled version of 'nftables'.
 (vers. 2)
Date: Fri, 25 Jul 2014 19:16:46 +0200
Message-ID: <20140725171646.GA5718@salvia>
References: <1404742796-8039-1-git-send-email-giorgio.nicole@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giorgio Dal Molin <giorgio.nicole@arcor.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44055 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245AbaGYRQh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:16:37 -0400
Content-Disposition: inline
In-Reply-To: <1404742796-8039-1-git-send-email-giorgio.nicole@arcor.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 07, 2014 at 04:19:24PM +0200, Giorgio Dal Molin wrote:
> Hi,
> 
> I'm sending a couple of patches to add autotools support to the 'nftables' project.

This patchset doesn't remove the the old makefiles and it's missing
several new ones (most likely forgot to 'git add') in the include/
irectory. I think this needs another spin.

Thanks.
