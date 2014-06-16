From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH 1/2] reject: Check the protocol context for
 indicating the reject type
Date: Mon, 16 Jun 2014 12:00:41 +0200
Message-ID: <20140616100040.GA9296@localhost>
References: <1402505362-8355-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43252 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816AbaFPKAq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jun 2014 06:00:46 -0400
Content-Disposition: inline
In-Reply-To: <1402505362-8355-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 11, 2014 at 06:49:22PM +0200, Alvaro Neira Ayuso wrote:
> This patch check the protocol context and initialize the reject type
> considering if the transport protocol is tcp, udp, etc. Before, we
> didn't initialize it

Applied, thanks Alvaro.
