From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 01/02]: nf_conntrack_tcp: fix connection reopening
Date: Thu, 11 Oct 2007 14:36:52 -0700 (PDT)
Message-ID: <20071011.143652.11608242.davem@davemloft.net>
References: <20071011164349.31373.23530.sendpatchset@localhost.localdomain>
	<20071011164351.31373.99334.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39349
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752123AbXJKVhF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Oct 2007 17:37:05 -0400
In-Reply-To: <20071011164351.31373.99334.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 11 Oct 2007 18:44:04 +0200 (MEST)

> [NETFILTER]: nf_conntrack_tcp: fix connection reopening
> 
> With your description I could reproduce the bug and actually you were
> completely right: the code above is incorrect. Somehow I was able to
> misread RFC1122 and mixed the roles :-(:
> 
>    When a connection is >>closed actively<<, it MUST linger in
>    TIME-WAIT state for a time 2xMSL (Maximum Segment Lifetime).
>    However, it MAY >>accept<< a new SYN from the remote TCP to
>    reopen the connection directly from TIME-WAIT state, if it:
>    [...]
> 
> The fix is as follows: if the receiver initiated an active close, then the
> sender may reopen the connection - otherwise try to figure out if we hold
> a dead connection.
> 
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> Tested-by: Krzysztof Piotr Oledzki <ole@ans.pl>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Patch applied.
