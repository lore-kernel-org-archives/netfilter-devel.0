From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Correct libxt_statistic save output
Date: Mon, 19 Nov 2012 11:44:17 +0100
Message-ID: <20121119104417.GA1175@1984>
References: <50A80A47.6010700@shorewall.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Tom Eastep <teastep@shorewall.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36725 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab2KSKo0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Nov 2012 05:44:26 -0500
Content-Disposition: inline
In-Reply-To: <50A80A47.6010700@shorewall.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Nov 17, 2012 at 02:05:59PM -0800, Tom Eastep wrote:
> Suppressing '--packet 0' in save output resulted in restore failure.
> 
> This patch includes '--packet 0' in save output while continuing to
> suppress it in print output.

Applied, thanks Tom!
