From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: helper: Fix helper unregister count.
Date: Mon, 30 May 2016 11:31:51 +0200
Message-ID: <20160530093151.GA27946@salvia>
References: <1463231993-26917-1-git-send-email-ap420073@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, kadlec@blackhole.kfki.hu,
	netfilter-devel@vger.kernel.org
To: Taehee Yoo <ap420073@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36909 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333AbcE3Jb4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2016 05:31:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 493A91C0966
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:31:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 38D3115D643
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:31:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EA34115D647
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:31:52 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1463231993-26917-1-git-send-email-ap420073@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, May 14, 2016 at 10:19:53PM +0900, Taehee Yoo wrote:
> helpers should unregister the only registered ports.
> but, helper cannot have correct registered ports value when
> failed to register.

Applied, thanks.
