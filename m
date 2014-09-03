From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf_tables PATCH 2/6 v5] netfilter: nf_tables: add helper to
 unregister chain hooks
Date: Wed, 3 Sep 2014 11:46:24 +0200
Message-ID: <20140903094623.GB14063@salvia>
References: <1409668946-8168-1-git-send-email-arturo.borrero.glez@gmail.com>
 <1409668946-8168-3-git-send-email-arturo.borrero.glez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34291 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755930AbaICJpg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:45:36 -0400
Content-Disposition: inline
In-Reply-To: <1409668946-8168-3-git-send-email-arturo.borrero.glez@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 02, 2014 at 04:42:23PM +0200, Arturo Borrero Gonzalez wrote:
> This patch adds a helper function to unregister chain hooks in the chain
> deletion path. Basically, a code factorization.
> 
> The new function is useful in follow-up patches.

Applied, thanks.
