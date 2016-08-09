From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] xtables-compat: fix comments listing
Date: Tue, 9 Aug 2016 10:41:55 +0200
Message-ID: <20160809084155.GA9445@salvia>
References: <20160802142947.1388-1-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34298 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbcHIImD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Aug 2016 04:42:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 301BBD162F
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2016 10:41:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2223B9663E
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2016 10:41:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3A2EA9663E
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2016 10:41:57 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160802142947.1388-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 02, 2016 at 04:29:47PM +0200, Pablo M. Bermudo Garay wrote:
> ip[6]tables-compat -L was not printing the comments since commit
> d64ef34a9961 ("iptables-compat: use nft built-in comments support").
> 
> This patch solves the issue.

Applied, thanks.
