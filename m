From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [LIBNL 05/09]: nfnetlink_log: only set hwproto if not zero
Date: Thu, 7 Feb 2008 13:01:47 +0100
Message-ID: <20080207120147.GX11220@postel.suug.ch>
References: <20080118165514.13385.44695.sendpatchset@localhost.localdomain> <20080118165521.13385.17641.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, philipc@snapgear.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from postel.suug.ch ([194.88.212.233]:46466 "EHLO postel.suug.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913AbYBGMB0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:01:26 -0500
Content-Disposition: inline
In-Reply-To: <20080118165521.13385.17641.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* Patrick McHardy <kaber@trash.net> 2008-01-18 17:55
> commit 26b35449524246778d4a14c3805430797c29c039
> Author: Patrick McHardy <kaber@trash.net>
> Date:   Fri Jan 18 17:44:52 2008 +0100
> 
>     [LIBNL]: nfnetlink_log: only set hwproto if not zero
>     
>     The hwproto doesn't have its own attribute and is also present when
>     not set. Don't set the attribute if its value is zero.
>     
>     Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
