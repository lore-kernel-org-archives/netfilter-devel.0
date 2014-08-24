From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-compat PATCH 4/5 v2] nft: adds a bitwise operation to
 a rule
Date: Sun, 24 Aug 2014 16:09:34 +0200
Message-ID: <20140824140934.GB25894@salvia>
References: <1408698993-17706-1-git-send-email-giuseppelng@gmail.com>
 <1408698993-17706-4-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34954 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbaHXOIt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Aug 2014 10:08:49 -0400
Content-Disposition: inline
In-Reply-To: <1408698993-17706-4-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 22, 2014 at 11:16:32AM +0200, Giuseppe Longo wrote:
> This patch adds a bitwise operation to a rule

Please, merge patches 2, 4 and 5 in one single patch. Those changes
are interdependent. I would also like to see a bit longer description.
This is fixing the network prefixes (eg. /24) in the compat utility
and at least one example, ie. A rule + the netlink code that is generated.
Something similar to what you made your patch 3.

Thanks.
