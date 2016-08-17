From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nfnetlink_log: add "nf-logger-3-1"
 module alias name
Date: Wed, 17 Aug 2016 17:45:28 +0200
Message-ID: <20160817154528.GA16062@salvia>
References: <1471099564-3743-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42874 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbcHQPph (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 11:45:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id CD8D2D164B
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 17:45:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B4CB4DA3B0
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 17:45:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9588FFB469
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 17:45:33 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1471099564-3743-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Aug 13, 2016 at 10:46:04PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Otherwise, if nfnetlink_log.ko is not loaded, we cannot add rules
> to log packets to the userspace when we specify it with arp family,
> such as:
> 
>   # nft add rule arp filter input log group 0
>   <cmdline>:1:1-37: Error: Could not process rule: No such file or
>   directory
>   add rule arp filter input log group 0
>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This qualifies as bugfix, so I'm applying this to nf. Thanks!
