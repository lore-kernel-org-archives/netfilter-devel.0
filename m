From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_dup4: remove redundant checksum
 recalculation
Date: Fri, 12 Aug 2016 12:18:14 +0200
Message-ID: <20160812101814.GA2990@salvia>
References: <1469879052-15378-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57492 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbcHLKSa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 06:18:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B76E8D1632
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 12:18:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AA1ADFF12D
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 12:18:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2010DFF12D
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 12:18:23 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1469879052-15378-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 30, 2016 at 07:44:12PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> IP header checksum will be recalculated at ip_local_out, so
> there's no need to calculated it here, remove it. Also update
> code comments to illustrate it, and delete the misleading
> comments about checksum recalculation.

Applied, thanks.
