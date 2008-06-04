From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 02/02]: nf_conntrack_ipv6: fix inconsistent lock
 state in nf_ct_frag6_gather()
Date: Wed, 04 Jun 2008 09:58:39 -0700 (PDT)
Message-ID: <20080604.095839.79277172.davem@davemloft.net>
References: <4846C035.8040607@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59923
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751129AbYFDQ6j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Jun 2008 12:58:39 -0400
In-Reply-To: <4846C035.8040607@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Wed, 04 Jun 2008 18:17:57 +0200

> [NETFILTER]: nf_conntrack_ipv6: fix inconsistent lock state in nf_ct_frag6_gather()

Also applied, thanks Patrick.
