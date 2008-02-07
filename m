From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [LIBNL 01/09]: Add if_vlan.h
Date: Thu, 7 Feb 2008 12:50:20 +0100
Message-ID: <20080207115020.GT11220@postel.suug.ch>
References: <20080118165514.13385.44695.sendpatchset@localhost.localdomain> <20080118165515.13385.3747.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, philipc@snapgear.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from postel.suug.ch ([194.88.212.233]:46748 "EHLO postel.suug.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757530AbYBGMOr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:14:47 -0500
Content-Disposition: inline
In-Reply-To: <20080118165515.13385.3747.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* Patrick McHardy <kaber@trash.net> 2008-01-18 17:55
> commit 057316c354252ef6273f6deb4fe4232c02e4d141
> Author: Patrick McHardy <kaber@trash.net>
> Date:   Fri Jan 18 16:15:53 2008 +0100
> 
>     [LIBNL]: Add if_vlan.h
>     
>     vlan support needs VLAN_FLAG_REORDER_HDR, which is not available in
>     older if_vlan.h versions. Add the current version from the kernel.

Applied, thanks.
