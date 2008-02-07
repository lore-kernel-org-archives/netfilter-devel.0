From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [LIBNL 02/09]: Fix minor memleaks on exit
Date: Thu, 7 Feb 2008 12:52:21 +0100
Message-ID: <20080207115221.GU11220@postel.suug.ch>
References: <20080118165514.13385.44695.sendpatchset@localhost.localdomain> <20080118165516.13385.89513.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, philipc@snapgear.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from postel.suug.ch ([194.88.212.233]:46794 "EHLO postel.suug.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757978AbYBGMOs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:14:48 -0500
Content-Disposition: inline
In-Reply-To: <20080118165516.13385.89513.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* Patrick McHardy <kaber@trash.net> 2008-01-18 17:55
> commit f3982f36f684c2ef1174bf3d951c15d3e5a91f9a
> Author: Patrick McHardy <kaber@trash.net>
> Date:   Fri Jan 18 16:16:07 2008 +0100
> 
>     [LIBNL]: Fix minor memleaks on exit
>     
>     Make valgrind happy ...

Applied, thanks Patrick.
