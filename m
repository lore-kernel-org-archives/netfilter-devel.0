From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/1] netfilter: netfilter fix
Date: Fri, 02 Jul 2010 22:05:01 -0700 (PDT)
Message-ID: <20100702.220501.183053149.davem@davemloft.net>
References: <1278070805-26278-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56734
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751239Ab0GCFEs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Jul 2010 01:04:48 -0400
In-Reply-To: <1278070805-26278-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: kaber@trash.net
Date: Fri,  2 Jul 2010 13:40:04 +0200

> the following patch for 2.6.35 fixes a dst leak in ip6t_REJECT when
> dst->error is set, from Eric Dumazet.
> 
> Please apply or pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-2.6.git master

Also pulled, thanks Patrick.
