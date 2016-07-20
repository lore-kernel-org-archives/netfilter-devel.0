From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] extensions: libxt_NFLOG: add unit test to cover
 nflog-size with zero
Date: Wed, 20 Jul 2016 19:31:22 +0200
Message-ID: <20160720173122.GA27845@salvia>
References: <1469019190-20263-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57279 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923AbcGTRbf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jul 2016 13:31:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id CD63F392E0B
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2016 19:31:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BDBA96DC5D
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2016 19:31:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 99CA3FAB56
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2016 19:31:31 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1469019190-20263-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 20, 2016 at 08:53:10PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> "--nflog-size 0" is valid and we must display it appropriately.

Applied, thanks.
