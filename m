From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] mxml: test if the root node name is initialized
 before to compare it.
Date: Thu, 5 Mar 2015 21:52:46 +0100
Message-ID: <20150305205246.GA4689@salvia>
References: <1425326318-22936-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34856 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbbCEUtQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Mar 2015 15:49:16 -0500
Content-Disposition: inline
In-Reply-To: <1425326318-22936-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 02, 2015 at 08:58:38PM +0100, Alvaro Neira Ayuso wrote:
> If the root node name is not correctly initialized, we have a crash.

Applied, thanks.
