From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] tests/shell: add some tests for network namespaces
Date: Thu, 7 Apr 2016 19:21:05 +0200
Message-ID: <20160407172105.GA6573@salvia>
References: <145994041032.27922.11144705527173452584.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59293 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756867AbcDGRVJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 13:21:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C23AD4B0FE
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 19:21:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A8E34DA38E
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 19:21:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 30939DA38F
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 19:21:05 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <145994041032.27922.11144705527173452584.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 06, 2016 at 01:00:10PM +0200, Arturo Borrero Gonzalez wrote:
> A basic tests to check we can perform operations in different network
> namespaces.

Applied, thanks.
