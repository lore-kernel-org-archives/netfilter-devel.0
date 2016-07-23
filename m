From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/2] netfilter: nft_compat: put back match/target
 module if init fail
Date: Sat, 23 Jul 2016 12:31:01 +0200
Message-ID: <20160723103101.GA3282@salvia>
References: <1469260832-58903-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60911 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbcGWKbI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Jul 2016 06:31:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 5908CE7DA2
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 12:31:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 47F8E9D6B7
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 12:31:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 98AFD9D5BE
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 12:31:03 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1469260832-58903-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 23, 2016 at 04:00:31PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> If the user specify the invalid NFTA_MATCH_INFO/NFTA_TARGET_INFO attr
> or memory alloc fail, we should call module_put to the related match
> or target. Otherwise, we cannot remove the module even nobody use it.

Applied, thanks.
