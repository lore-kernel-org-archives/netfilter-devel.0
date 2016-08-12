From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: Only need first 4 bytes to get l4proto
 ports
Date: Fri, 12 Aug 2016 12:16:55 +0200
Message-ID: <20160812101655.GA2929@salvia>
References: <1469272907-27761-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57196 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbcHLKRD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 06:17:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A3F87D1633
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 12:17:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9690FDA7F7
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 12:17:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A52F4A827A
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 12:16:56 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1469272907-27761-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 23, 2016 at 07:21:47PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> We only need first 4 bytes instead of 8 bytes to get the ports of
> tcp/udp/dccp/sctp/udplite in their pkt_to_tuple function.

Applied, thanks.
