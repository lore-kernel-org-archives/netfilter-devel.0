From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] include: xtables: Add enum for better nft translation
 code
Date: Fri, 25 Dec 2015 13:03:02 +0100
Message-ID: <20151225120302.GA4308@salvia>
References: <20151223142132.GA15698@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45797 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbbLYMDN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Dec 2015 07:03:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 52CD97B550
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:03:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 44557DA809
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:03:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5EA11DA804
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:03:07 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151223142132.GA15698@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 23, 2015 at 07:51:33PM +0530, Shivani Bhardwaj wrote:
> Add enum xt_op for ease to write cleaner and better code for
> nft translation.

Applied, thanks Shivani.
