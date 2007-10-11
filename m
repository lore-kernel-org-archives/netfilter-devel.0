From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 02/02]: x_tables: add missing ip6t_modulename
 aliases
Date: Thu, 11 Oct 2007 14:36:59 -0700 (PDT)
Message-ID: <20071011.143659.88710985.davem@davemloft.net>
References: <20071011164349.31373.23530.sendpatchset@localhost.localdomain>
	<20071011164353.31373.21835.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39351
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752123AbXJKVhK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Oct 2007 17:37:10 -0400
In-Reply-To: <20071011164353.31373.21835.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 11 Oct 2007 18:44:06 +0200 (MEST)

> [NETFILTER]: x_tables: add missing ip6t_modulename aliases
> 
> The patch will add MODULE_ALIAS("ip6t_<modulename>") where missing,
> otherwise you will get
> 
> 	ip6tables: No chain/target/match by that name
> 
> when xt_<modulename> is not already loaded.
> 
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied, thanks!
