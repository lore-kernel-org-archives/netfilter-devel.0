From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] extensions: libxt_NFQUEUE: Unstack different versions
Date: Wed, 27 Apr 2016 19:09:00 +0200
Message-ID: <20160427170900.GB7237@salvia>
References: <20160414152649.GA5365@shivani>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40057 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbcD0RJV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Apr 2016 13:09:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 3F955B191
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 19:09:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 273EB6449A
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 19:09:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0717F6447C
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 19:09:02 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160414152649.GA5365@shivani>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 14, 2016 at 08:56:49PM +0530, Shivani Bhardwaj wrote:
> Remove the stacking of older version into the newer one by adding the
> appropriate code corresponding to each version.

Also applied, thanks.
