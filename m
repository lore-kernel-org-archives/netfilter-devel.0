From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH nf-next 1/1] netfilter: nft_payload: add packet
 mangling support
Date: Mon, 23 Nov 2015 13:31:15 +0100
Message-ID: <20151123123115.GA13479@salvia>
References: <1447078234-21628-1-git-send-email-kaber@trash.net>
 <1447078234-21628-2-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46577 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbbKWMb2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Nov 2015 07:31:28 -0500
Received: from antivirus1-rhel7.int (antivirus1.int [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C1F0BFC60A
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Nov 2015 13:31:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A37BEDA87B
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Nov 2015 13:31:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E3B9ADA86C
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Nov 2015 13:31:18 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1447078234-21628-2-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 09, 2015 at 02:10:34PM +0000, Patrick McHardy wrote:
> Add support for mangling packet payload. Checksum for the specified
> base header is updated automatically, however no double updates (for
> pseudo headers) are supported, meaning no stateless NAT is supported.

Patrick, if you have no concerns, I'll pass this to David in the next
batch.

Thanks.
