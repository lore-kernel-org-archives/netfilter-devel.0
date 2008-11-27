From: David Miller <davem@davemloft.net>
Subject: Re: netfilter 23/29: ip{,6}t_policy.h should include xp_policy.h
Date: Thu, 27 Nov 2008 15:06:29 -0800 (PST)
Message-ID: <20081127.150629.209721532.davem@davemloft.net>
References: <20081127161503.13891.62766.sendpatchset@x2.localnet>
	<20081127161534.13891.33306.sendpatchset@x2.localnet>
	<alpine.LNX.1.10.0811271932560.21626@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org, apw@canonical.com
To: jengelh@medozas.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40046
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752340AbYK0XG3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Nov 2008 18:06:29 -0500
In-Reply-To: <alpine.LNX.1.10.0811271932560.21626@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Can you _PLEASE_ stop dropping netdev from the CC: list?!?!?

Doing that SCREWS UP EVERYTHING with how we log patches and their
followup discussion at:

	http://patchwork.ozlabs.org/project/netdev/list/
