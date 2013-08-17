From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nftables: allow protocols by number in
 inet_protocol_type_parse
Date: Sat, 17 Aug 2013 12:30:59 +0200
Message-ID: <20130817103059.GB7026@localhost>
References: <20130815230906.GA22230@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42902 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab3HQKbD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Aug 2013 06:31:03 -0400
Content-Disposition: inline
In-Reply-To: <20130815230906.GA22230@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 15, 2013 at 04:09:07PM -0700, Phil Oester wrote:
> nftables does not currently allow specifying protocols by number.  Below
> patch adds this capability.

Also applied, thanks.

[...]
> Note the errno include is duplicated in this patch and my earlier
> "nftables: validate port number in inet_service_type_parse" patch.

No problem, I have removed that chunk.
