From: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: xtables2 a8, netlink interface
Date: Thu, 19 Jan 2012 16:56:29 -0800
Message-ID: <20120119165629.2f7c8112@nehalam.linuxnetplumber.net>
References: <1326990381-14534-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:54850 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab2ATA4c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jan 2012 19:56:32 -0500
In-Reply-To: <1326990381-14534-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 19 Jan 2012 17:26:14 +0100
Jan Engelhardt <jengelh@medozas.de> wrote:

> 
> So here is the first set of patches implementing part of the xt2 core
> and nfnl interface. Please review, I am sure you will have something
> to say :)
> 
> The userspace part is at git://dev.medozas.de/libnetfilter_xtables,
> the xtnl-test program compiled as part of the default make target
> gives access to the kernel functions implemented by the patches.
> 

Does it allow for watching for iptables changes (notifications),
similar to what is done for link, address, and qdisc changes?
