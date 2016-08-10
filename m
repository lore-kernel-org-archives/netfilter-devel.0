From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3, libnftnl] tests: Fix tests for immediate and lookup
 expressions
Date: Wed, 10 Aug 2016 18:49:06 +0200
Message-ID: <20160810164906.GC28006@salvia>
References: <20160810151205.24975-1-carlosfg@riseup.net>
 <20160810151205.24975-3-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47914 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbcHJSFV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 14:05:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0AE291D103C
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 18:49:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F1637FF6DD
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 18:49:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EF7D6FF12D
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 18:49:07 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160810151205.24975-3-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 10, 2016 at 05:12:05PM +0200, Carlos Falgueras García wrote:
> An error at Makefile.am has caused that the tests
> 'nft-expr_immediate-test.c' and 'nft-expr_lookup-tests.c' have not been
> compiled since they were created. This patch fix that error and some errors
> in both tests.

Applied, thanks.
