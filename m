From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 02/03]: Consolidate nf_sockopt and compat_nf_sockopt
Date: Tue, 13 Nov 2007 02:58:22 -0800 (PST)
Message-ID: <20071113.025822.135024101.davem@davemloft.net>
References: <20071113105500.25336.39074.sendpatchset@localhost.localdomain>
	<20071113105503.25336.65069.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32963
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752935AbXKMK6X (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2007 05:58:23 -0500
In-Reply-To: <20071113105503.25336.65069.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Tue, 13 Nov 2007 11:55:42 +0100 (MET)

> [NETFILTER]: Consolidate nf_sockopt and compat_nf_sockopt
> 
> Both lookup the nf_sockopt_ops object to call the get/set callbacks
> from, but they perform it in a completely similar way.
> 
> Introduce the helper for finding the ops.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
