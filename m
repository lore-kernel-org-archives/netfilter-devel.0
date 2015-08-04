From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nfacct is not namespace aware
Date: Tue, 4 Aug 2015 19:17:33 +0200
Message-ID: <20150804171733.GA3770@salvia>
References: <1612781863.2309722.1438703792113.JavaMail.zimbra@tpip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Andreas Schultz <aschultz@tpip.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56613 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbbHDRLj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2015 13:11:39 -0400
Content-Disposition: inline
In-Reply-To: <1612781863.2309722.1438703792113.JavaMail.zimbra@tpip.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 04, 2015 at 05:56:32PM +0200, Andreas Schultz wrote:
> Hi,
> 
> Can someone confirm that the nfacct subsystem is not network namespace
> aware/safe?
> 
> From checking the code, it would appear that all nfacct targets are kept
> in a global list. This would mean that unrelated namespaces can interfere
> with each other.

There is no netns support for nfacct yet, but it should be easy to
add.

Patches are welcome :)
