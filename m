From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libnetfilter_conntrack: Add nfct_destroy() to all examples
 in utils
Date: Sat, 14 May 2011 10:52:03 +0200
Message-ID: <4DCE42B3.1080508@netfilter.org>
References: <1302984506-14506-1-git-send-email-andy@andybev.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Andrew Beverley <andy@andybev.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42387 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912Ab1ENIwO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 May 2011 04:52:14 -0400
In-Reply-To: <1302984506-14506-1-git-send-email-andy@andybev.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16/04/11 22:08, Andrew Beverley wrote:
> For libnetfilter_conntrack:
> This patch adds nfct_destroy() to all the examples in the utils folder.
> Although this may be obvious to some, when I wrote my first code using
> libnetfilter_conntract, I used the examples but subsequently missed out
> all the calls to nfct_destroy().
> 
> Signed-off-by: Andrew Beverley <andy@andybev.com>

Applied, thank you Andrew!
