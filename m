From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 02/02]: xt_sctp: fix mistake to pass a pointer
 where array is required
Date: Thu, 18 Oct 2007 05:12:31 -0700 (PDT)
Message-ID: <20071018.051231.89038285.davem@davemloft.net>
References: <20071018101159.28424.36079.sendpatchset@localhost.localdomain>
	<20071018101202.28424.49568.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51563
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1762488AbXJRMMR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Oct 2007 08:12:17 -0400
In-Reply-To: <20071018101202.28424.49568.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 18 Oct 2007 12:12:25 +0200 (MEST)

> [NETFILTER]: xt_sctp: fix mistake to pass a pointer where array is required
> 
> Macros like SCTP_CHUNKMAP_XXX(chukmap) require chukmap to be an array,
> but match_packet() passes a pointer to these macros. Also remove the
> ELEMCOUNT macro and fix a bug in SCTP_CHUNKMAP_COPY.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied, thanks!
