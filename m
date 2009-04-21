From: David Miller <davem@davemloft.net>
Subject: Re: warnings in current tree
Date: Tue, 21 Apr 2009 01:44:27 -0700 (PDT)
Message-ID: <20090421.014427.86938853.davem@davemloft.net>
References: <20090421.014357.219275555.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54753
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750884AbZDUIof (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Apr 2009 04:44:35 -0400
In-Reply-To: <20090421.014357.219275555.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: David Miller <davem@davemloft.net>
Date: Tue, 21 Apr 2009 01:43:57 -0700 (PDT)


Sorry, duh, meant netfilter-devel :-)

> Can someone fix these up?  Thanks!
> 
> net/netfilter/nf_conntrack_netlink.c:1234: warning: 'helpname' may be used uninitialized in this function
> net/netfilter/nf_conntrack_netlink.c:991: warning: 'helpname' may be used uninitialized in this function
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
