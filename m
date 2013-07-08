From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] ip6tables: don't print out /128
Date: Mon, 8 Jul 2013 18:55:30 +0200
Message-ID: <20130708165530.GA21213@localhost>
References: <20130620201138.GA11634@gmail.com>
 <20130708022641.GA14090@localhost>
 <20130708041908.GA5532@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42664 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227Ab3GHQzh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:55:37 -0400
Content-Disposition: inline
In-Reply-To: <20130708041908.GA5532@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jul 07, 2013 at 09:19:08PM -0700, Phil Oester wrote:
> On Mon, Jul 08, 2013 at 04:26:41AM +0200, Pablo Neira Ayuso wrote:
> > I just look at the source of old iptables releases (1.4.11) and it
> > displays the /32 with iptables -L. I prefer if we restore that
> > behaviour, ie. we get it back to display /32, for historial reasons.
> 
> That does not appear to be correct.  
> 
> # ./iptables-multi main -V
> iptables v1.4.10
> 
> # ./iptables-multi main -L foo  
> Chain foo (0 references)
> target     prot opt source               destination         
>            all  --  1.2.3.4              anywhere
> 
> 
> From what I can tell, the comment 
> 
> 	/* we don't want to see "/32" */
> 
> has existed in the tree since at least 3/2000.

You're right, I was looking at the wrong place in the code. I have
applied this patch. Thanks.
