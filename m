From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libmnl] callback: mark cb_ctl_array 'const' in
 mnl_cb_run2()
Date: Mon, 8 Aug 2016 13:15:15 +0200
Message-ID: <20160808111515.GA15187@salvia>
References: <20160803105234.bmmyt2ikq4cuqknr@alphalink.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Guillaume Nault <g.nault@alphalink.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47300 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbcHHLPY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Aug 2016 07:15:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BE321186ACF
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2016 13:15:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AE83DDA7F5
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2016 13:15:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id ADAAE100798
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2016 13:15:20 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160803105234.bmmyt2ikq4cuqknr@alphalink.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 03, 2016 at 12:52:34PM +0200, Guillaume Nault wrote:
> Users of mnl_cb_run2() would typically pass a 'static const' array as
> cb_ctl_array parameter. Unfortunately this triggers a compiler warning
> because the prototype doesn't declare cb_ctl_array with the 'const'
> qualifier.
> 
> Since mnl_cb_run2() and __mnl_cb_run() don't modify cb_ctl_array (and
> don't have any reason to do so in the future), we can mark this
> parameter as 'const'.
> 
> There should be no impact on existing users beyond removing the
> compiler warning when using a constant array.

Applied, thanks.
