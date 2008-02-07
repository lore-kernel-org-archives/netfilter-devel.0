From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [LIBNL 06/09]: nfnetlink_log: support NUFLA_GID attribute
Date: Thu, 7 Feb 2008 13:03:19 +0100
Message-ID: <20080207120319.GY11220@postel.suug.ch>
References: <20080118165514.13385.44695.sendpatchset@localhost.localdomain> <20080118165522.13385.72025.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, philipc@snapgear.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from postel.suug.ch ([194.88.212.233]:46480 "EHLO postel.suug.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944AbYBGMC6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:02:58 -0500
Content-Disposition: inline
In-Reply-To: <20080118165522.13385.72025.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* Patrick McHardy <kaber@trash.net> 2008-01-18 17:55
> commit 2c2e8051726fb34980d1e7b72c15d0a6eba4cfc0
> Author: Patrick McHardy <kaber@trash.net>
> Date:   Fri Jan 18 17:44:52 2008 +0100
> 
>     [LIBNL]: nfnetlink_log: support NUFLA_GID attribute
>     
>     The NUFLA_GID attribute (currently only in net-2.6.25) contains the
>     gid of the sending process for locally generated packets.
>     
>     Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied, thanks Patrick.
