From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: libip(6)t_REJECT.man default icmp types
Date: Thu, 22 Aug 2013 13:03:26 +0200
Message-ID: <20130822110326.GC5347@localhost>
References: <1376869300-9146-1-git-send-email-ljlane@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Laurence J. Lane" <ljlane@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43163 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab3HVLDa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Aug 2013 07:03:30 -0400
Content-Disposition: inline
In-Reply-To: <1376869300-9146-1-git-send-email-ljlane@debian.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 18, 2013 at 07:41:40PM -0400, Laurence J. Lane wrote:
> From: "Laurence J. Lane" <ljlane@debian.org>
> 
> The extension man page shows "port-unreach" and "port-unreachable" as
> default icmpi6 and icomp reject-with types. Either and variations work
> fine for writing rules, but they are displayed as "icmp6-port-unreachable"
> and "icmp-port-unreachable". Let's make that consistent.
> 
> http://bugs.debian.org/644819

Applied, thanks.
