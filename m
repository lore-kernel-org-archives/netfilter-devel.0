From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nftables: Change the return type of
 nfulnl_set_timeout() and nfulnl_set_qthresh() to be void.
Date: Wed, 9 Dec 2015 14:51:58 +0100
Message-ID: <20151209135158.GA1309@salvia>
References: <1449576564-30233-1-git-send-email-rami.rosen@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
To: Rami Rosen <rami.rosen@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40104 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760AbbLINwF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Dec 2015 08:52:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B94711324D7
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 14:52:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A6D6CDA864
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 14:52:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 49400DA861
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 14:51:59 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1449576564-30233-1-git-send-email-rami.rosen@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 08, 2015 at 07:09:24AM -0500, Rami Rosen wrote:
>  This patch changes the return type of the static methods nfulnl_set_timeout() and
>  nfulnl_set_qthresh() to be void, as there is no justification and no need for these methods to return int.

Applied, thanks.

