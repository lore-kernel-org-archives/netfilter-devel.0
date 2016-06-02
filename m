From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_connmark: Fix order of mask and mark
Date: Thu, 2 Jun 2016 13:06:55 +0200
Message-ID: <20160602110655.GA3272@salvia>
References: <20160601180827.GA5279@shivani>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60303 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932294AbcFBLHF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jun 2016 07:07:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 3DE9A765615
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2016 13:07:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2E1EE1B4052
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2016 13:07:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 889E11B405E
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2016 13:07:00 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160601180827.GA5279@shivani>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 01, 2016 at 11:38:27PM +0530, Shivani Bhardwaj wrote:
> The order of mask and mark in the output is wrong. This has been pointed
> out: http://git.netfilter.org/iptables/commit/?id=8548dd253833027c68ac6400c3118ef788fabe5d
> by Liping Zhang <liping.zhang@spreadtrum.com>.
> This patch fixes the same issue with connmark.

Applied, thanks Shivani.
