From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1 rev. 1] nft: configure.ac: Replace magic dblatex dep.
Date: Sun, 3 Jul 2016 10:58:43 +0200
Message-ID: <20160703085843.GA8839@salvia>
References: <20160702183420.18609-1-nvinson234@gmail.com>
 <49591697-d895-7723-a20f-21b9712aed70@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Nick Vinson <nvinson234@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49975 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbcGCI6x (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Jul 2016 04:58:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id AE33BE5A58
	for <netfilter-devel@vger.kernel.org>; Sun,  3 Jul 2016 10:58:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 91AA39EBAE
	for <netfilter-devel@vger.kernel.org>; Sun,  3 Jul 2016 10:58:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9149AB505B
	for <netfilter-devel@vger.kernel.org>; Sun,  3 Jul 2016 10:58:48 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <49591697-d895-7723-a20f-21b9712aed70@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 02, 2016 at 11:37:50AM -0700, Nick Vinson wrote:
> The difference between this patch and the original one is that this
> patch defaults pdf documentation generation to 'disabled' instead of
> 'enabled'.

Thanks for explaining, I have applied this.
