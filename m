From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2] net: reallocate new socket option number for
 IPV6_AUTOFLOWLABEL
Date: Wed, 06 Aug 2014 15:25:36 -0700 (PDT)
Message-ID: <20140806.152536.832906295015490098.davem@davemloft.net>
References: <1407363429-3870-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: therbert@google.com, netfilter-devel@vger.kernel.org,
	davej@redhat.com, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:44328 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510AbaHFWZi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Aug 2014 18:25:38 -0400
In-Reply-To: <1407363429-3870-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu,  7 Aug 2014 00:17:09 +0200

> cb1ce2e ("ipv6: Implement automatic flow label generation on transmit")
> accidentally uses socket option 64, which is already used by ip6tables:
> 
>  IP6T_SO_SET_REPLACE / IP6T_SO_GET_INFO               64
>  IP6T_SO_SET_ADD_COUNTERS / IP6T_SO_GET_ENTRIES       65
> 
> There is comment include/uapi/linux/in6.h warning about that.
> 
> Allocate 70 for this, which seems to be unused instead.
> 
> Cc: Tom Herbert <therbert@google.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Applied, thanks Pablo.

The way we maintain this number space seems very error prone, FWIW.
