From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: linux-next borked with CONFIG_NF_CONNTRACK=n
Date: Tue, 19 Jun 2012 01:11:36 +0200
Message-ID: <20120618231136.GA30223@1984>
References: <20120618153116.c38e879c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38090 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab2FRXLl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jun 2012 19:11:41 -0400
Content-Disposition: inline
In-Reply-To: <20120618153116.c38e879c.akpm@linux-foundation.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 18, 2012 at 03:31:16PM -0700, Andrew Morton wrote:
> 
> If you didn't already know this...
> 
> I hacked with it for a few minutes but gave up.  Sample config attached.
> 
> include/net/netfilter/nf_conntrack.h: In function 'nf_ct_get':
> include/net/netfilter/nf_conntrack.h:157: error: 'const struct sk_buff' has no member named 'nfct'
> 
> after "fixing" that,
> 
> include/net/netfilter/nf_conntrack.h: In function 'nf_ct_get':
> include/net/netfilter/nf_conntrack.h:157: error: 'const struct sk_buff' has no member named 'nfct'
> 
> give up.

I think this is similar to what Randy Dunlap reported:

http://www.spinics.net/lists/netfilter-devel/msg22211.html

I'm going to send patches to David to fix this asap.
