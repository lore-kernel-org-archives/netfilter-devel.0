From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 5/5] trace: add log for packets
Date: Thu, 25 Jun 2015 15:38:31 +0200
Message-ID: <20150625133831.GA6579@salvia>
References: <1434571657-20047-1-git-send-email-koetter@rrzn.uni-hannover.de>
 <1434571657-20047-6-git-send-email-koetter@rrzn.uni-hannover.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Markus Koetter <koetter@rrzn.uni-hannover.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60415 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286AbbFYNdJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jun 2015 09:33:09 -0400
Content-Disposition: inline
In-Reply-To: <1434571657-20047-6-git-send-email-koetter@rrzn.uni-hannover.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Sorry, it took me a while to look back to this because of the
Netfilter workshop.

On Wed, Jun 17, 2015 at 10:07:37PM +0200, Markus Koetter wrote:
> diff --git a/src/log.c b/src/log.c
> new file mode 100644
> index 0000000..410c21e
> --- /dev/null
> +++ b/src/log.c

This code has to go into libnetfilter_log, IIRC ulogd2 already has a
similar copy of this since it has a output plugin to display the logs
in the same way as the kernel does.

It would be great if both can use the same code. I'd basically like
not to see this code into nft.
