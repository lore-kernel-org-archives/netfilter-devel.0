From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] ip6tables: don't print out /128
Date: Sun, 7 Jul 2013 21:19:08 -0700
Message-ID: <20130708041908.GA5532@linuxace.com>
References: <20130620201138.GA11634@gmail.com>
 <20130708022641.GA14090@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:60394 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab3GHETI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Jul 2013 00:19:08 -0400
Received: by mail-pa0-f51.google.com with SMTP id lf11so3950113pab.10
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Jul 2013 21:19:08 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130708022641.GA14090@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 08, 2013 at 04:26:41AM +0200, Pablo Neira Ayuso wrote:
> I just look at the source of old iptables releases (1.4.11) and it
> displays the /32 with iptables -L. I prefer if we restore that
> behaviour, ie. we get it back to display /32, for historial reasons.

That does not appear to be correct.  

# ./iptables-multi main -V
iptables v1.4.10

# ./iptables-multi main -L foo  
Chain foo (0 references)
target     prot opt source               destination         
           all  --  1.2.3.4              anywhere


>From what I can tell, the comment 

	/* we don't want to see "/32" */

has existed in the tree since at least 3/2000.  

Phil
