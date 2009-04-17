From: David Miller <davem@davemloft.net>
Subject: Re: netfilter 00/02: netfilter fixes
Date: Fri, 17 Apr 2009 15:44:26 -0700 (PDT)
Message-ID: <20090417.154426.217109514.davem@davemloft.net>
References: <20090417160913.32484.93063.sendpatchset@x2.localnet>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52281
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752127AbZDQWoe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Apr 2009 18:44:34 -0400
In-Reply-To: <20090417160913.32484.93063.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Fri, 17 Apr 2009 18:09:13 +0200 (MEST)

> the following two patches fix two netfilter bugs:
> 
> - missing socket notification for ctnetlink skb allocation errors
> 
> - an incorrect return code in nfnetlink for netlink_kernel_create() failure
> 
> Please apply or pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-2.6.git

Pulled, thanks a lot!
