From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrack-tools: dying and unconfirmed list not accessible
Date: Mon, 11 Mar 2013 14:55:06 +0100
Message-ID: <20130311135506.GA4222@localhost>
References: <alpine.LNX.2.01.1303111344120.25847@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56396 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921Ab3CKNzN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:55:13 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1303111344120.25847@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 11, 2013 at 01:45:43PM +0100, Jan Engelhardt wrote:
> Hi,
> 
> 
> In kernel 3.7.10 and a recent conntrack-tools, there seems to be a 
> problem with dumping the dying and confirm list.
> 
> # conntrack -L dying
> conntrack v1.4.1 (conntrack-tools): Operation failed: invalid parameters
> # conntrack -L unconfirmed
> conntrack v1.4.1 (conntrack-tools): Operation failed: invalid parameters
> 
> Is it perhaps that this is 3.8.x material?

Yes, that is material available since 3.8.
