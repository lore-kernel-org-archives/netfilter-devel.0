From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 04/04]: netfilter: nf_conntrack_irc: make sure string
 is terminated before calling simple_strtoul
Date: Sun, 07 Sep 2008 18:21:37 -0700 (PDT)
Message-ID: <20080907.182137.40392380.davem@davemloft.net>
References: <20080904141553.6414.87829.sendpatchset@x2.localnet>
	<20080904141558.6414.18261.sendpatchset@x2.localnet>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53252
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751482AbYIHBVo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Sep 2008 21:21:44 -0400
In-Reply-To: <20080904141558.6414.18261.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Thu,  4 Sep 2008 16:15:58 +0200 (MEST)

>     netfilter: nf_conntrack_irc: make sure string is terminated before calling simple_strtoul
>     
>     Alexey Dobriyan points out:
>     
>     1. simple_strtoul() silently accepts all characters for given base even
>        if result won't fit into unsigned long. This is amazing stupidity in
>        itself, but
>     
>     2. nf_conntrack_irc helper use simple_strtoul() for DCC request parsing.
>        Data first copied into 64KB buffer, so theoretically nothing prevents
>        reading past the end of it, since data comes from network given 1).
>     
>     This is not actually a problem currently since we're guaranteed to have
>     a 0 byte in skb_shared_info or in the buffer the data is copied to, but
>     to make this more robust, make sure the string is actually terminated.
>     
>     Signed-off-by: Patrick McHardy <kaber@trash.net>

Also applied, thanks Patrick.
