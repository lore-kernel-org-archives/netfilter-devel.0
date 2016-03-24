From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ipv4: fix NULL dereference
Date: Thu, 24 Mar 2016 21:16:44 +0100
Message-ID: <20160324201644.GB1561@salvia>
References: <1458743250-4003-1-git-send-email-zlpwmdx@163.com>
 <56F39E82.4090902@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpwmdx@163.com>, netfilter-devel@vger.kernel.org,
	kaber@trash.net, davem@davemloft.net,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Nikolay Borisov <kernel@kyup.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57347 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbcCXUQx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Mar 2016 16:16:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 5E5BD61E86
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Mar 2016 21:16:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0C8F911E3F5
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Mar 2016 21:16:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2B1B2A89A
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Mar 2016 21:16:50 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <56F39E82.4090902@kyup.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 24, 2016 at 10:00:02AM +0200, Nikolay Borisov wrote:
> I've been running production kernels in production with those changes
> and so far I haven't observed a single crash resulting from this.
> Furthermore, I  believe that all the call sites of synproxy_build_ip
> should have the skb associated with a valid tcp socket, which must have
> originated from a particular namespace.

Please, always Cc: netfilter-devel@vger.kernel.org for patches that
modify netfilter code. Your change is buggy, we cannot assume skb->sk
set on packets that are being forwarded, we could have detected this
following this process.

Thanks.
