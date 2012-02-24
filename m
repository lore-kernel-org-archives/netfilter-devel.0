From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] net/netfilter: refactor nf_ct_deliver_cached_events
Date: Fri, 24 Feb 2012 03:36:23 +0100
Message-ID: <20120224023623.GC7423@1984>
References: <1329893281-508699-1-git-send-email-antonz@parallels.com>
 <1329893281-508699-4-git-send-email-antonz@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tony Zelenoff <antonz@parallels.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42848 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489Ab2BXCg0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Feb 2012 21:36:26 -0500
Content-Disposition: inline
In-Reply-To: <1329893281-508699-4-git-send-email-antonz@parallels.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 22, 2012 at 10:48:01AM +0400, Tony Zelenoff wrote:
> * identation lowered
> * some CPU cycles saved at delayed item variable initialization
> 
> Signed-off-by: Tony Zelenoff <antonz@parallels.com>

Applied, thanks Tony.
