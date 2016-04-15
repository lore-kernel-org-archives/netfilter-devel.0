From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] NFQUEUE: Fix bug with order of fanout and bypass
Date: Fri, 15 Apr 2016 12:44:41 +0200
Message-ID: <20160415104441.GB10807@salvia>
References: <20160414152557.GA5338@shivani>
 <20160415104405.GA10807@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34055 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752AbcDOKou (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Apr 2016 06:44:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 676C7114818
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Apr 2016 12:44:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4D5FB9D0F3
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Apr 2016 12:44:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9EB2B9D0F9
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Apr 2016 12:44:46 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160415104405.GA10807@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 15, 2016 at 12:44:05PM +0200, Pablo Neira Ayuso wrote:
> Shivani, thanks for following up on this.
> 
> Would you also update extensions/libxt_NFQUEUE.t to add a test so we
> make sure this regression doesn't happen ever again?

Just to clarify: No need to resend this patchset.

A follow up standalone patch to update the test part would be
sufficient.
