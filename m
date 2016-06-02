From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_devgroup: Fix order of mask and id
Date: Thu, 2 Jun 2016 16:53:12 +0200
Message-ID: <20160602145312.GB1354@salvia>
References: <20160602132442.GA7807@shivani>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45949 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932293AbcFBOxT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jun 2016 10:53:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B029AF6AB21
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2016 16:53:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A0E501B3223
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2016 16:53:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9FC4F1B3227
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2016 16:53:15 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160602132442.GA7807@shivani>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 02, 2016 at 06:54:42PM +0530, Shivani Bhardwaj wrote:
> The order of mask and id in the translated code is not apt
> so fix it.
> This patch follows commit 8548dd by Liping Zhang.

Applied, thanks.
