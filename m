From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] Add ip6t_ aliases
Date: Wed, 10 Oct 2007 16:33:46 -0700 (PDT)
Message-ID: <20071010.163346.54951705.davem@davemloft.net>
References: <Pine.LNX.4.64.0710101342430.22916@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: jengelh@computergmbh.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58825
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756848AbXJJXdn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Oct 2007 19:33:43 -0400
In-Reply-To: <Pine.LNX.4.64.0710101342430.22916@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Jan Engelhardt <jengelh@computergmbh.de>
Date: Wed, 10 Oct 2007 13:44:49 +0200 (CEST)

> Hi,
> 
> 
> I think this latecomer patch should go into 2.6.24.
> 
> ===
> 
> Add missing ip6t_modulename aliases.
> 
> The patch will add MODULE_ALIAS("ip6t_<modulename>") where missing,
> otherwise you will get
> 
> 	ip6tables: No chain/target/match by that name
> 
> when xt_<modulename> is not already loaded.
> 
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

Patrick?
