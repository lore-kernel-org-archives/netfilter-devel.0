From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: Add helper array register/unregister
 functions
Date: Tue, 19 Jul 2016 20:12:50 +0200
Message-ID: <20160719181250.GA6116@salvia>
References: <1468813163-18139-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57153 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424AbcGSSNA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jul 2016 14:13:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C41E6114819
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jul 2016 20:12:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B4A069D5BE
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jul 2016 20:12:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 39EDA9D5BE
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jul 2016 20:12:55 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1468813163-18139-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 18, 2016 at 11:39:23AM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> Add nf_ct_helper_init, nf_conntrack_helpers_register/unregister
> functions to enhance the conntrack helper codes.

Applied, thanks.

I have manually updated indentations to make it fit to our coding
style, btw.
