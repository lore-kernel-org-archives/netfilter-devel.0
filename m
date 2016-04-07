From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2] tests/shell: add new testcases for commit/rollback
Date: Thu, 7 Apr 2016 19:21:16 +0200
Message-ID: <20160407172116.GB6573@salvia>
References: <145941127225.11915.12615423955814437978.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59322 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757006AbcDGRVU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 13:21:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id CE2774B0F6
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 19:21:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B662DDA386
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 19:21:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 326ECDA386
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 19:21:16 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <145941127225.11915.12615423955814437978.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 31, 2016 at 10:01:12AM +0200, Arturo Borrero Gonzalez wrote:
> New simple testcases for kernel commit/rollback operations.
> 
> * ruleset A is loaded (good ruleset)
> * ruleset B is loaded (bad ruleset): fail is expected
> * ruleset A should remain in the kernel

Also applied, thanks.
