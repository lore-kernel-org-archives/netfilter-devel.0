From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xt_TCPMSS: Avoid violating RFC 879 in absence
 of MSS option
Date: Wed, 5 Jun 2013 14:09:03 +0200
Message-ID: <20130605120903.GA10198@localhost>
References: <20130604150927.GA9108@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51777 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267Ab3FEMJI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Jun 2013 08:09:08 -0400
Content-Disposition: inline
In-Reply-To: <20130604150927.GA9108@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 04, 2013 at 11:09:27AM -0400, Phil Oester wrote:
> As reported in bug #662, the clamp-mss-to-pmtu option of the xt_TCPMSS target
> can cause issues connecting to websites if there was no MSS option present in
> the original SYN packet from the client.  In these cases, it adds an MSS higher
> than the default specified in RFC 879.  Fix this by never setting a value > 536
> IFF none was specified by the client.  
> 
> This closes bug #662.

Applied to the nf tree, thanks Phil.

BTW, this target does not seem to make safe fragmentation handling. We
need a patch similar to:

commit bc6bcb59dd7c184d229f9e86d08aa56059938a4c
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Tue May 7 03:22:18 2013 +0200

    netfilter: xt_TCPOPTSTRIP: fix possible mangling beyond packet boundary
