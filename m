From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/4] netfilter: netfilter fixes
Date: Wed, 02 Feb 2011 15:52:11 -0800 (PST)
Message-ID: <20110202.155211.70207791.davem@davemloft.net>
References: <1296690330-9887-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39123
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754475Ab1BBXvg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Feb 2011 18:51:36 -0500
In-Reply-To: <1296690330-9887-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: kaber@trash.net
Date: Thu,  3 Feb 2011 00:45:26 +0100

> following are a couple of netfilter fixes for 2.6.38, containing:
> 
> - a missing conntrack reference count increment during ctnetlink table
>   dumping, leading to a crash, from Pablo
> 
> - a fix for mismatches in the IPv6 iprange match, from Thomas Jacob
> 
> - a fix to make arp_tables mangling work again after some cleanups,
>   from Pablo
> 
> - a fix for missing information in ctnetlink when events are filtered
>   using the CT target, from Pablo
> 
> Please pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-2.6.git master

Pulled, thanks Patrick.
